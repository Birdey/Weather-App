//
//  WeatherData.swift
//  Weather App
//
//  Created by Christoffer Nilsson on 2022-07-05.
//

import Foundation

class WeatherData{
    
    private let _townName:String
    private let _lat:Float
    private let _lon:Float
    private var _dataLoaded = false
    
    init(_ townName:String, _ lat:Float, _ lon:Float) {
        _townName = townName
        _lat = lat
        _lon = lon
        
    }
    
    func getLatLon() -> (Float, Float){
        return (_lat, _lon)
    }
    
    func isDataLoaded() -> Bool{
        return _dataLoaded
    }
    
}
