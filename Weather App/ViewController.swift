//
//  ViewController.swift
//  Weather App
//
//  Created by Christoffer Nilsson on 2022-07-05.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    let _weatherManger: WeatherDataManager = WeatherDataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        checkLocationManager()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationObj = locations.last
        if let coord = locationObj?.coordinate{
            AppData.getInstance().setCurrentDeviceLovation(
                location: CLLocation.init(
                    latitude: coord.latitude,
                    longitude: coord.longitude
                )
            )
            locationManager.stopUpdatingLocation()
            FetchWeatherDataFromServer()
        }
    }
    
    func checkLocationManager(){
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestWhenInUseAuthorization()
            //locationManager.startUpdatingLocation()
            locationManager.requestLocation()
        } else {
            print("Location services are not enabled");
        }
    }
    
    
    func getCurrentLanLonOfDevice() -> (Double, Double){
        return (0,0)
    }

    func FetchWeatherDataFromServer(){
        _weatherManger.loadWeatherData(AppData.getInstance().getSelectedWeatherData()) {
            success in
            if(success){
                print("Loaded initial weather for selected city")
                print("Current Temp in \(AppData.getInstance()._selectedWeatherData.getTownName()) is \(AppData.getInstance()._selectedWeatherData.getCurrentTemp())")
                
            }else{
                print("Error loading data for selected city")
            }
        }
    }

}

