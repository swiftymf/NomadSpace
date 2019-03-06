//
//  AppDelegate.swift
//  Nomad Space 2
//
//  Created by Markith on 2/5/19.
//  Copyright © 2019 SwiftyMF. All rights reserved.
//

import UIKit
import Moya
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow? = UIWindow() // Default declaration
  //let window = UIWindow() // Tutorial declaration - Why did he change this?
  let locationService = LocationService()
  let storyboard = UIStoryboard(name: "Main", bundle: nil)
  let service = MoyaProvider<YelpService.BusinessesProvider>()
  let jsonDecoder = JSONDecoder()
  var navigationController: UINavigationController?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    
    locationService.newLocation = { [weak self] result in
      switch result {
      case .success(let location):
        self?.loadBusinesses(with: location.coordinate)
      case .failure(let error):
        assertionFailure("Error getting user location \(error)")
      }
    }
    locationService.getLocation()
    return true
  }
  
  
//  private func loadDetails(viewController: UIViewController,  withId id: String) {
//    service.request(.details(id: id)) { [weak self] (result) in
//      switch result {
//      case .success(let response):
//        guard let strongSelf = self else { return }
//        if let tableViewDetails = try? strongSelf.jsonDecoder.decode(Details.self, from: response.data) {
//          let tableViewModel = TableViewModel(tableViewDetails: tableViewDetails)
//          (viewController as? MapViewController)?.detailsViewModel = tableViewModel
//          print("loadDetails ran")
//        }
//      case .failure(let error):
//        print("Failed getting details: \(error)")
//      }
//    }
//  }
  
  // MARK: - See viewModels from Yelp
  private func loadBusinesses(with coordinate: CLLocationCoordinate2D) {
    // crashes because User denied location permission
    // provide search results based on current map location instead of user location?
    service.request(.search(lat: coordinate.latitude, long: coordinate.longitude)) { [weak self] (result) in
      //private func loadBusinesses() {
      //service.request(.search(lat: 34.046418, long: -118.2426)) { (result) in
      guard let strongSelf = self else { return }
      switch result {
      case .success(let response):
        //        guard let strongSelf = self else { return }
        let root = try? strongSelf.jsonDecoder.decode(Root.self, from: response.data)
        let viewModels = root?.businesses.compactMap(MapViewModel.init).sorted(by: {$0.distance < $1.distance} )
        if let nav = strongSelf.window?.rootViewController as? UINavigationController,
          let mapViewController = nav.topViewController as? MapViewController {
          mapViewController.mapViewModels = viewModels ?? []
        }
        if let nav = strongSelf.window?.rootViewController as? UINavigationController,
          let detailsViewController = nav.topViewController as? DetailsViewController {
          detailsViewController.mapViewModels = viewModels ?? []
        }
      case .failure(let error):
        print("Error: \(error)")
      }
    }
  }
  
}

//extension AppDelegate: /*LocationActions,*/ ListActions {
//
//  func didTapAllow() {
//    locationService.requestLocationAuthorization()
//  }
//
//  func didTapCell(_ viewController: UIViewController, viewModel: MapViewModel) {
//    loadDetails(viewController: viewController, withId: viewModel.id)
//  }
//}
