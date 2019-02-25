//
//  MapPins.swift
//  Nomad Space 2
//
//  Created by Markith on 2/11/19.
//  Copyright © 2019 SwiftyMF. All rights reserved.
//

import UIKit
import MapKit

class MapPins: NSObject, MKAnnotation {
  
  var title: String?
  var coordinate: CLLocationCoordinate2D
  var info: String
  
  init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
    self.title = title
    self.coordinate = coordinate
    self.info = info
  }
}


