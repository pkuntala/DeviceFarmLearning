//
//  HospitalListTableViewController.swift
//  Superheroes
//
//  Created by Astha Singh on 14/12/21.
//

import UIKit

class HospitalListTableViewController: UITableViewController {
    var user:UserMO?
    var hospitals:Hospitals=[]
    var languageSelected = 0
    var imagesCache:[String:Data] = [:]
    @IBOutlet weak var hospitalsTableView:UITableView!
    var dataUpdated = false
    var message = ""
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        let msgView=UILabel()
        msgView.text=message
        hospitalsTableView.backgroundView = msgView
        hospitalsTableView.backgroundView?.isHidden=true
        if let _ = user{
        } else {
            user=AppInternalStates.internals?.userLogged
        }
        
            hospitals=[]
            imagesCache=[:]
        
        getHospitalJson{
            (responseData) in
            DispatchQueue.main.async {
                if(responseData.hasPrefix("Network Error")){
                    self.message="No Network Connectivity"
                    self.hospitalsTableView.backgroundView?.isHidden=false
                    self.hospitalsTableView.separatorStyle = .none
                }
                else{
                    let tempCount = self.hospitals.count
                    self.hospitals=getHospitals(jsonData: responseData)
                    if self.hospitals.isEmpty{
                        self.message="No Hospitals"
                        self.hospitalsTableView.backgroundView?.isHidden=false
                    }
                    if tempCount != self.hospitals.count{
                        self.hospitalsTableView.reloadData()
                    }
                }
                let msgView=UILabel()
                msgView.textAlignment = .center
                msgView.text=self.message
                self.hospitalsTableView.backgroundView = msgView
                self.dataUpdated=true
                if !self.hospitalsTableView.backgroundView!.isHidden
                {self.hospitalsTableView.reloadData()}
            }
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return hospitals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hospitalCell", for: indexPath) as! HospitalTableViewCell
            //let imageUrl:URL = URL(string: self.hospitals[indexPath.row].image)!
            //let imageData:NSData = NSData(contentsOf: imageUrl)!
            //cell.hospitalImage.image = UIImage(data: imageData as Data)
        if imagesCache.keys.contains(hospitals[indexPath.row].image){
            cell.hospitalImage.image = UIImage(data: imagesCache[hospitals[indexPath.row].image]!)
        }
        else
        if AppInternalStates.networkAvailability{
        let url = URL(string: hospitals[indexPath.row].image)

        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                guard data != nil else{return}
                if(!self.imagesCache.keys.contains(self.hospitals[indexPath.row].image)){
                    self.imagesCache[self.hospitals[indexPath.row].image] = data!
                }
               // cell.hospitalImage.image =
                cell.hospitalImage.image = UIImage(data: self.imagesCache[self.hospitals[indexPath.row].image]!)

            }
          }
        }
        cell.hospitalName.text = hospitals[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "hospitalCell", for: indexPath) as! HospitalTableViewCell
        AppInternalStates.pronounce(text:hospitals[indexPath.row].name)
      //  Voice.pronounce(text: cell.accessibilityIdentifier ?? "")
        
    }
    

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
        if segue.identifier=="showHospitalDetail"{
            let destinationController=segue.destination as! DetailHospitalTableViewController
            if let indexPath = tableView.indexPathForSelectedRow{
              destinationController.hospital = hospitals[indexPath.row]
              destinationController.languageSelected = languageSelected
                destinationController.imageCacheData = imagesCache[hospitals[indexPath.row].image]
            }
        }
        if segue.identifier=="showUserProfile"{
            let destinationController=segue.destination as! UserProfileViewController
            destinationController.user = user
            destinationController.languageSelected = languageSelected
        }
    }
    

}
