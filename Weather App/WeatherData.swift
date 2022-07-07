//
//  WeatherData.swift
//  Weather App
//
//  Created by Christoffer Nilsson on 2022-07-05.
//

import Foundation
import CoreLocation

class WeatherData{
    
    private let _townName:String
    private let _location:CLLocation
    private var _dataLoaded = false
    
    private var _maxTemp:Double?
    private var _minTemp:Double?
    private var _currentTemp:Double?
    
    private var _humidity:Int?
    
    private var _weatherID:Int?
    
    
    init(_ townName:String, _ location:CLLocation) {
        _townName = townName
        _location = location
        
    }
    
    func getTownName() -> String{
        return _townName
    }
    
    func getLocation() -> CLLocation{
        return _location
    }
    
    func isDataLoaded() -> Bool{
        return _dataLoaded
    }
    
    func dataIsLoaded(){
        _dataLoaded = true
    }
    
    func convertTemp(temprature:Double, tempScale:AppData.Temp_Scale) -> Double {
        var convertedTemp = temprature
        switch(tempScale){
        case AppData.Temp_Scale.Celcius:
            convertedTemp = temprature - 273.15
            break
        case AppData.Temp_Scale.Farenheit:
            convertedTemp = 1.8*(temprature-273) + 3
            break
        }
        
        return convertedTemp
    }
    
    //Weather Data Fill out
    
    func setTempratures(current:Double, max:Double, min:Double){
        setCurrentTemp(current: current)
        setMaxTemp(max: max)
        setMinTemp(min: min)
        
    }
    
    func setCurrentTemp(current:Double){
        _currentTemp = current
    }
    
    func setMaxTemp(max:Double){
        _maxTemp = max
    }
    
    func setMinTemp(min:Double){
        _minTemp = min
    }
    
    func getCurrentTemp() -> Double{
        if let t = _currentTemp{
            return convertTemp(temprature: t, tempScale: AppData.getInstance().getPreferedTempScale())
        }
        return 0.0
    }
    
    func getMaxTemp() -> Double{
        if let t = _maxTemp{
            return convertTemp(temprature: t, tempScale: AppData.getInstance().getPreferedTempScale())
        }
        return 0.0
    }
    
    func getMinTemp() -> Double{
        if let t = _minTemp{
            return convertTemp(temprature: t, tempScale: AppData.getInstance().getPreferedTempScale())
        }
        return 0.0
    }
    
    func setHumidity(humidity:Int){
        _humidity = humidity
    }
    
    func getHumidity() -> Int{
        return _humidity ?? 0
    }
    
    func setWeatherID(id:Int){
        _weatherID = id
    }
    
    func getWeatherID() -> Int{
        return _weatherID ?? 0
    }
    
}
