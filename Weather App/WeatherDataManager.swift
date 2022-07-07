//
//  WeatherDataManager.swift
//  Weather App
//
//  Created by Christoffer Nilsson on 2022-07-05.
//

import Foundation
import CoreLocation
import UIKit

class WeatherDataManager {
    
    var _weatherDatas = Array<WeatherData>()
    
    init(){
        loadCitiesIntoWeatherDataPoints()
    }
    
    func loadCitiesIntoWeatherDataPoints(){
        for cityData in AppData.getInstance().getCitiesList(){
            if
                let name = cityData["name"],
                let lat = Double(cityData["lat"]!),
                let lon = Double(cityData["lon"]!){
                _weatherDatas.append(WeatherData(name, CLLocation(latitude: lat, longitude: lon)))
            }
        }
        
        let currentDeviceLocation:CLLocation = AppData.getInstance().getCurrentDeviceLocation()
        
        AppData.getInstance().setSelectedWeatherData(getClosestCity(currentlatLong: currentDeviceLocation))
    }
    
    func getClosestCity(currentlatLong:CLLocation) -> WeatherData{
        var maxDist = Double.greatestFiniteMagnitude
        var closestWeatherData:WeatherData = _weatherDatas.first!
        for weatherData in _weatherDatas {
            let d = calcDistance(
                lat1: currentlatLong.coordinate.latitude,
                lon1: currentlatLong.coordinate.longitude,
                lat2: weatherData.getLocation().coordinate.latitude,
                lon2: weatherData.getLocation().coordinate.longitude)
            if(d < maxDist){
                closestWeatherData = weatherData
                maxDist = d
            }
        }
        return closestWeatherData
    }
    
    func calcDistance(lat1:Double, lon1:Double, lat2:Double, lon2:Double) -> Double{
        return ((lat1 - lat2) * (lat1 - lat2)) + ((lon1 - lon2) * (lon1 - lon2))
    }
    
    func loadWeatherData(_ weatherData:WeatherData, completion: @escaping (Bool)->()){
        if weatherData.isDataLoaded(){
            //Callback with loaded Data!
        }
        
        let location = weatherData.getLocation()
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        let API_KEY = AppData.getInstance().getAPIKey()
        
        //Get WeatherData using URL https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
        let urlString:String = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(API_KEY)"
        
        if let url:URL = URL(string: urlString){
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: urlRequest){
                data, responce, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    do{
                        let weatherCoreData = try decoder.decode(APIWeatherCore.self, from: data)
                        //print(weatherCoreData)
                        weatherData.setTempratures(
                            current: weatherCoreData.main.temp,
                            max: weatherCoreData.main.temp_max,
                            min: weatherCoreData.main.temp_min
                        )
                        if let weather = weatherCoreData.weather.first{
                            weatherData.setWeatherID(id: weather.id)
                        }
                        weatherData.setHumidity(humidity: Int(weatherCoreData.main.humidity!))
                        weatherData.dataIsLoaded()
                        completion(true)
                    } catch {
                        print("Error decoding JSON in getting Product")
                        print(error)
                        completion(false)
                    }
                }
            }.resume()
        }
        
    }
    
    func getIconBasedOnWeatherID(weatherID:Int) -> UIImage{
        var imageName:String
        
        switch(weatherID){
        case 200...299:
            imageName = "01d" //Thunderstorm
            break
        case 300...399, 520...599:
            imageName = "09d" // Heavy Rain
            break
        case  500...504:
            imageName = "10d" // Light Rain
            break
        case 511, 600...699:
            imageName = "13d" //Snow
            break
        case 700...799:
            imageName = "50d" //Fog
            break
        case 800:
            imageName = "01d" //Clear
            break
        case 801:
            imageName = "02d" // Few Couds
            break
        case 802:
            imageName = "03d" //Clouds
            break
        case 803, 804:
            imageName = "04d" //Lots of clouds
            break
        default:
            imageName = "03d" //Defaulting to clouds
            break
        }
        
        //print("Weather id \(weatherID) gives the image \(imageName)")
        
        return UIImage.init(named: imageName)!
    }
}
