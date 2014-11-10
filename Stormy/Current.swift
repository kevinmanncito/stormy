//
//  Current.swift
//  Stormy
//
//  Created by Kevin Mann on 11/6/14.
//  Copyright (c) 2014 Freedom Software. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class Current {
    
    var currentTime: String?
    var temperature: Int
    var humidity: Double
    var precipProbability: Double
    var summary: String
    var icon: UIImage?
    var windSpeed: Double
    
    init(weatherDictionary: NSDictionary) {
        let currentWeather = weatherDictionary["currently"] as NSDictionary
        
        temperature = currentWeather["temperature"] as Int
        humidity = currentWeather["humidity"] as Double
        precipProbability = currentWeather["precipProbability"] as Double
        summary = currentWeather["summary"] as String
        windSpeed = currentWeather["windSpeed"] as Double
        
        let currentTimeIntVale = currentWeather["time"] as Int
        currentTime = dateStringFromUnixTime(currentTimeIntVale)
        
        let iconString = currentWeather["icon"] as String
        icon = weatherIconFromString(iconString)
    }
    
    // Default constructor (mostly for testing)
    init() {
        self.temperature = 10
        self.precipProbability = 0
        self.summary = "Partly Cloudy"
        self.windSpeed = 5.49
        self.humidity = 0.4
        self.currentTime = dateStringFromUnixTime(1415592795)
        self.icon = weatherIconFromString("partly-cloudy-night")
    }
    
    func dateStringFromUnixTime(unixTime: Int) -> String {
        let timeInSeconds = NSTimeInterval(unixTime)
        let weatherDate = NSDate(timeIntervalSince1970: timeInSeconds)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .ShortStyle
        return dateFormatter.stringFromDate(weatherDate)
    }
    
    func weatherIconFromString(stringIcon: String) -> UIImage! {
        var imageName: String
        
        switch stringIcon {
        case "clear-day":
            imageName = "clear-day"
        case "clear-night":
            imageName = "clear-night"
        case "rain":
            imageName = "rain"
        case "snow":
            imageName = "snow"
        case "sleet":
            imageName = "sleet"
        case "wind":
            imageName = "wind"
        case "fog":
            imageName = "fog"
        case "cloudy":
            imageName = "cloudy"
        case "partly-cloudy-day":
            imageName = "partly-cloudy"
        case "partly-cloudy-night":
            imageName = "cloudy-night"
        default:
            imageName = "default"
        }
        
        var iconName = UIImage(named: imageName)
        return iconName
    }
    
}
