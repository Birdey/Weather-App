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

    @IBOutlet weak var _weatherListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _weatherListView.delegate = self
        _weatherListView.dataSource = self
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
                
                DispatchQueue.main.async {
                    //self._weatherListView.reloadData()
                }
            }else{
                print("Error loading data for selected city")
            }
        }
    }

}

extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let weatherData:WeatherData = _weatherManger._weatherDatas[indexPath.row]
        print("You tapped on \(weatherData.getTownName())!")
    }
    
}

extension ViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("TableView haz \(_weatherManger._weatherDatas.count) rows")
        return _weatherManger._weatherDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:WeatherCell = _weatherListView.dequeueReusableCell(withIdentifier: "weatherListCell", for: indexPath) as! WeatherCell
        
        print("Updating cell att index \(indexPath)")
        
        cell.townNameLabel.text = _weatherManger._weatherDatas[indexPath.row].getTownName()
        cell.tempratureLabel.text = "..."
        
        //tableView.reloadRows(at: [indexPath], with: .automatic)
        
        return cell
    }
    
}
