//
//  NetworkServices.swift
//  Nomad Space 2
//
//  Created by Markith on 2/5/19.
//  Copyright © 2019 SwiftyMF. All rights reserved.
//

import Moya
import Foundation

private let apiKey = "J3YvjJP9NyYxXgT6dYmbIr5t6-jB9cm51aSMnI0cV3EfHvfaDrPAnJw2qM1j5gRgqmAvXahzizNkgWFjRd_NOvoo0wfzBOUUl-gHpBn6en4_2DdNhXnEFefeJJxTXHYx"

enum YelpService {
  enum BusinessesProvider: TargetType {
    case search(lat: Double, long: Double)
    case details(id: String)
    
    var baseURL: URL {
      return URL(string: "https://api.yelp.com/v3/businesses")!
    }
    
    var path: String {
      switch self {
      case .search:
        return "/search"
      case let .details(id):
        return "/\(id)"
      }
    }
    
    var method: Moya.Method {
      return .get
    }
    
    var sampleData: Data {
      return Data()
    }
    
    var task: Task {
      switch self {
      case let .search(lat, long):
        return .requestParameters(parameters: ["latitude": lat, "longitude": long, "limit": 10], encoding: URLEncoding.queryString)
      case .details:
        return .requestPlain
      }
    }
    
    var headers: [String : String]? {
      return ["Authorization": "Bearer \(apiKey)"]

    }
    
  }
  
}
