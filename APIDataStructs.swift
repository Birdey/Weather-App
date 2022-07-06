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
    //let count:Int
    //let list:Array<APIWeatherData>
    let id:Int
    let name:String
    let coords:Dictionary<String, Double>?
    let main:APIWeatherDataMain
    let dt:Int
    let wind:Dictionary<String, Double>?
    //let sys:String
    let rain:Dictionary<String, Double>?
    let snow:Dictionary<String, Double>?
    let clouds:Dictionary<String, Int>
    let weather:Array<APIWeatherDataWeather>
}

struct APIWeatherData: Codable{
    let id:Int
    let name:String
    let coords:Dictionary<String, Double>
    let main:APIWeatherDataMain
    let dt:Int
    let wind:Dictionary<String, Int>
    let sys:String
    let rain:Dictionary<String,Int>
    let snow:String
    let clouds:Dictionary<String, Int>
    let weather:Array<APIWeatherDataWeather>
}

struct APIWeatherDataMain: Codable{
    let temp:Double
    let preassure:Int?
    let humidity:Int
    let temp_min:Double
    let temp_max:Double
}

struct APIWeatherDataWeather: Codable{
    let id:Int
    let main:String
    let description:String
    let icon:String
}

/*
API EXSAMPLE
{
 "message":"accurate",
 "cod":"200",
 "count":1,
 "list":[
    {
    "id":2643743,
    "name":"London",
    "coord":
        {
            "lat":51.5085,
            "lon":-0.1258
        },
        "main":
            {
                "temp":280.15,
                "pressure":1012,
                "humidity":81,
                "temp_min":278.15,
                "temp_max":281.15
            },
        "dt":1485791400,
        "wind":
            {
                "speed":4.6,
                "deg":90
        
            },
        "sys":
            {
                "country":"GB"
            },
        "rain":null,
        "snow":null,
        "clouds":{"all":90},
        "weather":
            [
                {
                    "id":701,
                    "main":"Mist",
                    "description":"mist",
                    "icon":"50d"

                },
                {
                    "id":300,
                    "main":"Drizzle",
                    "description":"light intensity drizzle",
                    "icon":"09d"
                }
            ]
        }
    ]
}
 */
