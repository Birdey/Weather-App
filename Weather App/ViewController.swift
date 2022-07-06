//
//  ViewController.swift
//  Weather App
//
//  Created by Christoffer Nilsson on 2022-07-05.
//

import UIKit


class ViewController: UIViewController {
    
    let _weatherManger: WeatherDataManager = WeatherDataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        FetchWeatherDataFromServer()
    }

    func FetchWeatherDataFromServer(){
        _weatherManger.loadWeatherData(AppData.getInstance().getSelectedWeatherData())
    }

}

