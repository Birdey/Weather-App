//
//  APIDataStructs.swift
//  Weather App
//
//  Created by Christoffer Nilsson on 2022-07-06.
//

import Foundation

struct APIWeatherCore: Codable{
    let message:String?
    let cod:Int
    let id:Int
    let name:String
    let visibility:Int
    let coords:Dictionary<String, Double>?
    let main:APIWeatherDataMain
    let dt:Int
    let wind:Dictionary<String, Double>?
    let rain:Dictionary<String, Double>?
    let snow:Dictionary<String, Double>?
    let clouds:Dictionary<String, Int>
    let weather:Array<APIWeatherDataWeather>
}

struct APIWeatherDataMain: Codable{
    let temp:Double
    let feels_like:Double
    let temp_min:Double
    let temp_max:Double
    let preassure:Int?
    let humidity:Int?
}

struct APIWeatherDataWeather: Codable{
    let id:Int
    let main:String
    let description:String
    let icon:String
}

