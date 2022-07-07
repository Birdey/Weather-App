//
//  WeatherDataManager.swift
//  Weather App
//
//  Created by Christoffer Nilsson on 2022-07-05.
//

import Foundation
import CoreLocation

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
}
