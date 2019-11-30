//
//  CompassViewController.swift
//  SkyExplorer
//
//  Created by Emir Kalkan on 24.11.2019.
//  Copyright © 2019 Emir Kalkan. All rights reserved.
//

import UIKit
import CoreLocation

class CompassViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var compassView: UIView!
    @IBOutlet weak var angleLabel: UILabel!
    
    let canvasView = Canvasview()
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        canvasView.frame = compassView.bounds
        compassView.addSubview(canvasView)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.headingAvailable() {
            locationManager.headingFilter = 5
            locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
          if newHeading.headingAccuracy < 0
          {
              return
          }
          // Get the heading(direction)
        let heading: CLLocationDirection = ((newHeading.trueHeading > 0) ?
              newHeading.trueHeading : newHeading.magneticHeading);
          
          UIView.animate(withDuration: 0.5)
          {
              let angle = CGFloat(heading).degreesToRadians // convert from degrees to radians
              
              self.canvasView.transform = CGAffineTransform(rotationAngle: -CGFloat(angle))
          }
         
          var strDirection = String()
          if(heading > 23 && heading <= 67)
          {
              strDirection = "NE";
          } else if(heading > 68 && heading <= 112)
          {
              strDirection = "E";
          } else if(heading > 113 && heading <= 167)
          {
              strDirection = "SE";
          } else if(heading > 168 && heading <= 202)
          {
              strDirection = "S";
          } else if(heading > 203 && heading <= 247)
          {
              strDirection = "SW";
          } else if(heading > 248 && heading <= 293)
          {
              strDirection = "W";
          } else if(heading > 294 && heading <= 337)
          {
              strDirection = "NW";
          } else if(heading >= 338 || heading <= 22)
          {
              strDirection = "N";
          }
          angleLabel.text = "\(String(format: "%0.0f", heading))Â°\(strDirection)"
    }

}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
