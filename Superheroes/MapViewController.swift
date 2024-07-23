//
//  MapViewController.swift
//  Superheroes
//
//  Created by Potula Sandeep Reddy on 14/12/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    var location:String?
   
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //mapView.delegate = self
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsTraffic = true
        mapView.showsBuildings = true
        mapView.showsUserLocation = true
       configure(location: location ?? "Prestige Takt 23, Kasturba Road Cross, Benguluru, KA 560001")
        AppInternalStates.pronounce(text:"Location is" )
        AppInternalStates.pronounce(text: location ?? "" )
        

        // Do any additional setup after loading the view.
    }
    @IBAction func mapDisplayed(_ sender: Any) {
        if let obj = sender as? UIButton{
            AppInternalStates.pronounce(text:obj.accessibilityIdentifier ?? "")
            AppInternalStates.pronounce(text: location ?? "" )
        }
        
    }
    
    
    
    func configure(location: String) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(location, completionHandler: { placemarks, error in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            if let placemarks = placemarks {
                let placemark = placemarks[0]
                
                let annotation = MKPointAnnotation()
                
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyMarker"
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        var annotationView: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        annotationView?.glyphText = "  "
        annotationView?.markerTintColor = UIColor.orange
        return annotationView
    }
}
