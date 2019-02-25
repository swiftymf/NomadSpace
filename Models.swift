//
//  Models.swift
//  Nomad Space 2
//
//  Created by Markith on 2/10/19.
//  Copyright © 2019 SwiftyMF. All rights reserved.
//

import Foundation
import CoreLocation

struct Root: Decodable {
  let businesses: [Business]
}

struct Business: Decodable {
  let id: String
  let name: String
  let imageUrl: URL
  let distance: Double
  let coordinates: CLLocationCoordinate2D
}

struct MapViewModel {
  let name: String
  let imageUrl: URL
  let distance: Double
  let id: String
  let coordinates: CLLocationCoordinate2D
  
  
  static var numberFormatter: NumberFormatter {
    let nf = NumberFormatter()
    nf.numberStyle = .decimal
    nf.maximumFractionDigits = 2
    nf.minimumFractionDigits = 2
    return nf
}

  var formattedDistance: String? {
    return MapViewModel.numberFormatter.string(from: distance as NSNumber)
  }
}

extension MapViewModel {
  init(mapDetails: Business) {
    self.name = mapDetails.name
    self.id = mapDetails.id
    self.imageUrl = mapDetails.imageUrl
    self.distance = mapDetails.distance / 1609.344
    self.coordinates = mapDetails.coordinates
  }
}


struct Details: Decodable {
  let name: String
  let price: String
  let phone: String
  let isClosed: Bool
  let rating: Double
  let photos: [URL]
  let coordinates: CLLocationCoordinate2D
}

extension CLLocationCoordinate2D: Decodable {
  enum CodingKeys: CodingKey {
    case latitude
    case longitude
  }
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let latitude = try container.decode(Double.self, forKey: .latitude)
    let longitude = try container.decode(Double.self, forKey: .longitude)
    self.init(latitude: latitude, longitude: longitude)
  }
}

struct TableViewModel {
  let name: String
  let price: String
  let phoneNumber: String
  let isOpen: String
  let rating: String
  let imageUrls: [URL]
  let coordinate: CLLocationCoordinate2D
}


extension TableViewModel {
  init(tableViewDetails: Details) {
    self.name = tableViewDetails.name
    self.price = tableViewDetails.price
    self.isOpen = tableViewDetails.isClosed ? "Closed" : "Open"
    self.phoneNumber = tableViewDetails.phone
    self.rating = "\(tableViewDetails.rating) / 5.0"
    self.imageUrls = tableViewDetails.photos
    self.coordinate = tableViewDetails.coordinates
  }
  
}
