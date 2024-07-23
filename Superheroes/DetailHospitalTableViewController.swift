//
//  DetailHospitalTableViewController.swift
//  Superheroes
//
//  Created by Preetika Kuntala on 15/12/21.
//

import UIKit
import MapKit

class DetailHospitalTableViewController: UITableViewController {
    var hospital:Hospital?
    var languageSelected = 0
    var imageCacheData:Data?
    @IBOutlet weak var hospitalName: UILabel!
    @IBOutlet weak var hospitalImg : UIImageView!
    @IBOutlet weak var hospitalDescription: UITextView!
    @IBOutlet weak var addressDescription: UITextView!
    @IBOutlet weak var doctorsDescription: UITextView!
    
    @IBOutlet weak var aboutTheHospital : UILabel!
    @IBOutlet weak var address : UILabel!
    @IBOutlet weak var doctors : UILabel!
    @IBOutlet weak var mapView :MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hospitalDescription.text = hospital!.desc
        addressDescription.text = hospital!.address
        doctorsDescription.text = hospital!.doctors
        hospitalName.text = hospital!.name
        if let _ = imageCacheData
        {
            hospitalImg.image = UIImage(data: imageCacheData!)
        }
        else
        {
            if let imageUrl:URL = URL(string: hospital!.image){
                if let imageData:NSData = NSData(contentsOf: imageUrl)
               { hospitalImg.image = UIImage(data: imageData as Data)}
            }
        
        }
        configure(location: hospital!.address)
        //hospitalImg.image = hospital!.image
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        if languageSelected == 1{
            aboutTheHospital.text = aboutTheHospital.text?.localizableString("es")
            address.text = address.text?.localizableString("es")
            doctors.text = doctors.text?.localizableString("es")
        }
        else{
            aboutTheHospital.text = aboutTheHospital.text?.localizableString("en")
            address.text = address.text?.localizableString("en")
            doctors.text = doctors.text?.localizableString("en")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    @IBAction func elementSelected(_ sender: Any) {
        if let obj = sender as? UIButton{
            AppInternalStates.pronounce(text:obj.accessibilityIdentifier ?? "")
        }
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     //   let cell = tableView.dequeueReusableCell(withIdentifier: "hospitalCell", for: indexPath) as! HospitalTableViewCell
        switch indexPath.row{
        case 0:
            AppInternalStates.pronounce(text: hospitalName.text ?? "")
        case 1:
            AppInternalStates.pronounce(text: hospitalDescription.text)
        case 2:
            AppInternalStates.pronounce(text: addressDescription.text)
        case 3:
            AppInternalStates.pronounce(text: "Doctors of the hospital are")
            AppInternalStates.pronounce(text: doctorsDescription.text)
            
        
        default:
            fatalError("Failed to instantiate the table view cell for detail view controller")
        }
    }

    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "detailHospitalView", for: indexPath)
//
//
//
//        return cell
//    }
//

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier=="showFullMap"{
            let destinationController = segue.destination as! MapViewController
            destinationController.location = hospital!.address
        
            
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
    
    

}
extension DetailHospitalTableViewController: MKMapViewDelegate {
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
