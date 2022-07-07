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
    
    @IBOutlet weak var _fineWeatherView: UIView!
    @IBOutlet weak var _fineTownNameLabel: UILabel!
    @IBOutlet weak var _fineImageView: UIImageView!
    @IBOutlet weak var _fineTemratureLabel: UILabel!
    @IBOutlet weak var _fineMinMaxLabel: UILabel!
    @IBOutlet weak var _fineExtraData: UILabel!
    
    @IBOutlet var _tapGeastureRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _weatherListView.delegate = self
        _weatherListView.dataSource = self
        
        setView(view: _fineWeatherView, hidden: true)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        _fineWeatherView.addGestureRecognizer(tapGesture)
        
        checkLocationManager()
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        hideDetailView()
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
    
    func showDetailView(){
        let weatherData:WeatherData = AppData.getInstance().getSelectedWeatherData()
        _fineTownNameLabel.text = weatherData.getTownName()
        let temprature = Int(weatherData.getCurrentTemp()*100)/100
        let lowTemp = Int(weatherData.getMinTemp()*100)/100
        let highTemp = Int(weatherData.getMaxTemp()*100)/100
        _fineTemratureLabel.text = "\(temprature) °C"
        _fineImageView.image = _weatherManger.getIconBasedOnWeatherID(weatherID: weatherData.getWeatherID())
        _fineMinMaxLabel.text = "Low: \(lowTemp) - High: \(highTemp)"
        _fineExtraData.text = "humidity: \(weatherData.getHumidity())%"
        
    
        setView(view: _fineWeatherView, hidden: false)
        
    }
    
    func hideDetailView(){
        setView(view: _fineWeatherView, hidden: true)
    }
    
    func setView(view: UIView, hidden: Bool) {
        DispatchQueue.main.async {
            UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
                view.isHidden = hidden
            })
        }
    }

}

extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let weatherData:WeatherData = _weatherManger._weatherDatas[indexPath.row]
        AppData.getInstance().setSelectedWeatherData(weatherData)
        showDetailView()
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
        
        let weatherData:WeatherData = _weatherManger._weatherDatas[indexPath.row]
        
        cell.townNameLabel.text = _weatherManger._weatherDatas[indexPath.row].getTownName()
        
        if (weatherData.isDataLoaded()){
            print("Weather Data for \(weatherData.getTownName()) is loaded")
            let temprature = Int(weatherData.getCurrentTemp()*100)/100
            cell.tempratureLabel.text = "\(temprature) °C"
            cell.iconImageView.image = _weatherManger.getIconBasedOnWeatherID(weatherID: weatherData.getWeatherID())
        }else{
            print("Weather Data for \(weatherData.getTownName()) is NOT loaded")
            cell.tempratureLabel.text = "..."
            _weatherManger.loadWeatherData(weatherData) { done in
                if (done){
                    DispatchQueue.main.async {
                        self._weatherListView.reloadRows(at: [indexPath], with: .fade)
                    }
                }
            }
        }
        
        
        //tableView.reloadRows(at: [indexPath], with: .automatic)
        
        return cell
    }
    
}
