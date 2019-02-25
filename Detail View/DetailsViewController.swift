//
//  DetailsViewController.swift
//  Nomad Space 2
//
//  Created by Markith on 2/11/19.
//  Copyright © 2019 SwiftyMF. All rights reserved.
//

import Foundation
import UIKit

class DetailsViewController: UIViewController {
  

  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var isClosedLabel: UILabel!
  @IBOutlet weak var ratingLabel: UILabel!
  @IBOutlet weak var photosLabel: UILabel!
  
  var viewModel: Details? {
    didSet {
      updateView()
    }
  }

  var mapViewModels = [MapViewModel]() {
    didSet {
      loadSelectedBusinessDetails()
    }
  }
  
  var businessName: String?
  var businessID: String?
  var selectedBusiness: MapViewModel?
  var distance = ""
  @IBOutlet weak var idLabel: UILabel!
  
  override func viewDidLoad() {
    
    self.title = businessName
    distanceLabel.text = distance
  }
  
  func updateView() {
    if let viewModel = viewModel {
      distanceLabel?.text = viewModel.name
//      detailsFoodView?.hoursLabel?.text = viewModel.isOpen
//      detailsFoodView?.locationLabel?.text = viewModel.phoneNumber
//      detailsFoodView?.ratingsLabel?.text = viewModel.rating
      title = viewModel.name
      print("func updateView()")
    }
  }
  
  func loadSelectedBusinessDetails() {
    print("this started")
    print("mapViewModels: \(mapViewModels)")
    for business in mapViewModels {
      print("businessName: \(businessName)\nbusiness.id: \(business.id)")
      if businessName == business.name {
        businessID = business.id
        print(businessID)
      }
    }
  }
  
  
  
  
  
  
  
  
  
  
  
  
  
}
