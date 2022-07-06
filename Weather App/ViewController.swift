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
        FetchWeatherDataFromServer()
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager.stopUpdatingLocation()
        if (error) != nil {
            print(error)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let locationArray:Array<CLLocation> = locations as! Array<CLLocation>
        let locationObj = locationArray.last
        var coord = locationObj?.coordinate
        
    }
    
    func checkLocationManager(){
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
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

