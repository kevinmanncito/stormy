//
//  ViewController.swift
//  Stormy
//
//  Created by Kevin Mann on 11/5/14.
//  Copyright (c) 2014 Freedom Software. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let apiKey = "f34d35d4671226d9c2af3d4d6c98109e"
    let locationManager = CLLocationManager()
    let sharedSession = NSURLSession.sharedSession()
    var baseURL = NSURL()
    var forecastURL = NSURL()

    var latitude = CLLocationDegrees()
    var longitude = CLLocationDegrees()
    let coordinates = "37.8267,-122.423"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestAlwaysAuthorization()
        
        if (CLLocationManager.locationServicesEnabled())
        {
            println("setting up location services")
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")!
        activityIndicator.hidden = true;
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var locValue:CLLocationCoordinate2D = manager.location.coordinate
        latitude = locValue.latitude
        longitude = locValue.longitude
        CLGeocoder().reverseGeocodeLocation(manager.location) { (placemarks, error) -> Void in
            if (error == nil) {
                if placemarks.count > 0 {
                    self.addressLabel.text = "\(placemarks[0].locality), \(placemarks[0].administrativeArea)"
                }
            }
        }
        
        forecastURL = NSURL(string: "\(latitude),\(longitude)", relativeToURL: baseURL)!
        
        let downloadTask: NSURLSessionDownloadTask = self.sharedSession.downloadTaskWithURL(forecastURL, completionHandler: { (location: NSURL!,response: NSURLResponse!, error: NSError!) -> Void in
            if (error == nil) {
                let dataObject = NSData(contentsOfURL: location)
                let weatherDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as NSDictionary
                let currentWeather = Current(weatherDictionary: weatherDictionary)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.temperatureLabel.text = "\(currentWeather.temperature)"
                    self.iconView.image = currentWeather.icon
                    self.currentTimeLabel.text = "At \(currentWeather.currentTime!) it is"
                    self.humidityLabel.text = "\(currentWeather.humidity)"
                    self.precipitationLabel.text = "\(currentWeather.precipProbability)"
                    self.summaryLabel.text = "\(currentWeather.summary)"
                    self.refreshButton.hidden = false
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                })
            } else {
                let networkIssueController = UIAlertController(title: "Error", message: "Unable to load data from forecast.io", preferredStyle: .Alert)
                
                let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
                networkIssueController.addAction(okButton)
                
                let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                networkIssueController.addAction(cancelButton)
                
                
                self.presentViewController(networkIssueController, animated: true, completion: nil)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    //Stop refresh animation
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                    self.refreshButton.hidden = false
                })
            }
        })
        
        downloadTask.resume()
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager.stopUpdatingLocation()
        let networkIssueController = UIAlertController(title: "Error", message: "Unable to get location.", preferredStyle: .Alert)
        
        let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
        networkIssueController.addAction(okButton)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        networkIssueController.addAction(cancelButton)
        
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidden = true
        self.refreshButton.hidden = false

        self.presentViewController(networkIssueController, animated: true, completion: nil)
    }
    
    
    @IBAction func refreshWeather(sender: AnyObject) {
        refreshButton.hidden = true
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        locationManager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

