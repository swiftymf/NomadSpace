//
//  ViewController.swift
//  Nomad Space 2
//
//  Created by Markith on 2/5/19.
//  Copyright © 2019 SwiftyMF. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

// This and the detailsViewModel: below need to be used in the TableViewController when I get there.
protocol ListActions: class {
  func didTapCell(_ viewController: UIViewController, viewModel: MapViewModel)
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
  
  // This and the protocol above need to be used in the TableViewController when I get there.
    var detailsViewModel: TableViewModel? {
      didSet {
        updateView()
      }
    }
  
  @IBOutlet weak var mapView: MKMapView!
  
  private var locationManager: CLLocationManager!
  private var currentLocation: CLLocation?
  let locationService = LocationService()
  var userLocation = MKCoordinateRegion()
  
  var mapViewModels = [MapViewModel]() {
    didSet {
      updateView()
    }
  }
  
  weak var delegate: ListActions?

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    locationManager = CLLocationManager()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    
    if CLLocationManager.locationServicesEnabled() {
      locationManager.requestWhenInUseAuthorization()
      locationManager.startUpdatingLocation()
    }
  }
  
  func updateView() {
    
    // MARK: TODO - Change Yelp search Parameters
    // Figure out what parameters are being used to return locations from Yelp because it seems random
    for place in mapViewModels {
      let location = MKPointAnnotation() //MapPins(title: place.name, coordinate: place.coordinates, info: "no info")
      location.title = place.name
      location.coordinate = place.coordinates
      if let distance = place.formattedDistance {
        location.subtitle = "\(distance) miles from your location"
      }
      mapView.addAnnotation(location)
    }
    print("done adding locations")
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard annotation is MKPointAnnotation else { return nil }
    
    let identifier = "Annotation"
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
    
    if annotationView == nil {
      annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      annotationView!.canShowCallout = true
      let btn = UIButton(type: .detailDisclosure)
      annotationView!.rightCalloutAccessoryView = btn
    } else {
      annotationView!.annotation = annotation
    }
    
    return annotationView
  }
  
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    performSegue(withIdentifier: "DetailViewSegue", sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if (segue.identifier == "DetailViewSegue") {
      
      // pass data to next view
      let annotation = self.mapView.selectedAnnotations[0] as MKAnnotation
      let detailsVC: DetailsViewController = segue.destination as! DetailsViewController
      detailsVC.businessName = annotation.title! //as! String
      
      for selectedBusiness in mapViewModels {
        if annotation.title == selectedBusiness.name {
          print(selectedBusiness)
          detailsVC.distance =  "\(selectedBusiness.formattedDistance ?? "???") miles"
        }
      }
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location = locations.last! as CLLocation
    
    let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    userLocation = region
    self.mapView.setRegion(region, animated: true)
  }
  
  @IBAction func myLocationAction(_ sender: UIButton) {
    
    switch locationService.status {
      
    case .notDetermined, .denied, .restricted:
      // permission denied { ask if user wants to share location }
      let alert = UIAlertController(title: "Turn on location", message: "Go to Settings > Privacy > Location Services and allow sharing while using the app.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
      self.present(alert, animated: true)
      print(".notDetermined or .denied")
      
    default:
      // permission given { move map to user location }
      self.mapView.setRegion(userLocation, animated: true)
      
      // MARK: TODO - Load nearby businesses that have reviews
      // Only load what's in the current view or within a mile radius or whatever the Yelp call is using
      
      
      print(".default")
    }
  }
}

