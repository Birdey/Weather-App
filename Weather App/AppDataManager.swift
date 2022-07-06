//
//  AppDataManager.swift
//  Weather App
//
//  Created by Christoffer Nilsson on 2022-07-05.
//

import Foundation
import CoreLocation

class AppData {
    
    enum Temp_Scale{
        case Celcius
        case Farenheit
    }
    
    private static var instance: AppData = {
        let appData = AppData()
        return appData
    }();
    
    var _selectedWeatherData:WeatherData = WeatherData("NaN", CLLocation.init())
    private var _API_KEY = "0daf23edbed3ca153db9bf41574ee61b"
    private var _preffered_temp_scale:Temp_Scale = Temp_Scale.Celcius
    
    private var _currentDeviceLocation:CLLocation = CLLocation.init()
    
    var _cities:Array<Dictionary<String, String>> = [
        ["name": "Stockholm", "lat":"59.3293", "lon":"18.0686"],
        ["name": "Gothenburg", "lat":"57.7089", "lon":"11.9746"],
    ]
    
    init() {
        
    }
    
    class func getInstance() -> AppData {
        return instance
    }
    
    func getAPIKey() -> String{
        return _API_KEY
    }
    
    func getCitiesList() -> Array<Dictionary<String, String>>{
        return _cities
    }
    
    func setSelectedWeatherData(_ weatherData:WeatherData){
        _selectedWeatherData = weatherData
    }
    
    func getSelectedWeatherData() -> WeatherData{
        return _selectedWeatherData
    }
    
    func setPreferecTempScale(tempScale:Temp_Scale){
        _preffered_temp_scale = tempScale
    }
    
    func getPreferedTempScale() -> Temp_Scale{
        return _preffered_temp_scale
    }
    
    func setCurrentDeviceLovation(location:CLLocation){
        _currentDeviceLocation = location
    }
    
    func getCurrentDeviceLocation() -> CLLocation{
        return _currentDeviceLocation
    }
    
}
