//
//  WeatherDataManager.swift
//  Weather App
//
//  Created by Christoffer Nilsson on 2022-07-05.
//

import Foundation

class WeatherDataManager {
    
    var _weatherDatas = Array<WeatherData>()
    
    init(){
        loadCitiesIntoWeatherDataPoints()
    }
    
    func loadCitiesIntoWeatherDataPoints(){
        for cityData in AppData.getInstance().getCitiesList(){
            if
                let name = cityData["name"],
                let lat = cityData["lat"],
                let lon = cityData["lon"]{
                _weatherDatas.append(WeatherData(name, Float(lat)!, Float(lon)!))
            }
        }
        
        AppData.getInstance().setSelectedWeatherData(_weatherDatas[0])
    }
    
    func loadWeatherData(_ weatherData:WeatherData){
        if weatherData.isDataLoaded(){
            //Callback with loaded Data!
        }
        
        let (lat, lon) = weatherData.getLatLon()
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
                        let weatherData = try decoder.decode(APIWeatherCore.self, from: data)
                        print(weatherData)
                    } catch {
                        print("Error decoding JSON in getting Product")
                        print(error)
                    }
                }
            }.resume()
        }
        
    }
}
