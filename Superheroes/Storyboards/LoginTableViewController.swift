//
//  LoginTableViewController.swift
//  Superheroes
//
//  Created by Murukuri Tejasvi Sri Kanaka Lakshmi  on 14/12/21.
//

import UIKit
import AVFoundation
import LocalAuthentication
import CoreData
//import Voice

class LoginTableViewController: UITableViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    var internals = AppInternalStates.internals
    var users: [UserMO] = []
    var fetchResultController: NSFetchedResultsController<UserMO>!
    //var fetchInternalsController: NSFetchedResultsController<AppInternalsStatesMO>!
    var user:UserMO?
    
    var languageSelected = 0
    
    @IBOutlet weak var welcomeHeaderTitle: UILabel!
        @IBOutlet weak var userIDLabel: UILabel!
        @IBOutlet weak var userIDTextblock: UITextField!
        @IBOutlet weak var passwordTextBlock: UITextField!
        @IBOutlet weak var passwordLabel: UILabel!
        @IBOutlet weak var loginButton: UIButton!
        //@IBOutlet weak var forgotPasswordLabel: UILabel!
    @IBOutlet weak var voiceLabel:UILabel!
    @IBOutlet weak var languageTextField: UITextField!
    @IBOutlet weak var accessibilitySpeechSwitch: UISwitch!
    let pickerView = UIPickerView()
    let languages:[String] = ["English","Spanish"]
    
   // var ss:AVSpeechSynthesizer=AVSpeechSynthesizer()
    
    @IBAction func itemSelected(_ sender: Any) {
        if let obj = sender as? UITextField{
            AppInternalStates.pronounce(text: obj.accessibilityIdentifier ?? "")
            AppInternalStates.pronounce(text:obj.text!)
        }
       /* if let obj = sender as? UIButton{
            AppInternalStates.pronounce(text:obj.accessibilityIdentifier ?? "")
        }
 */
    }
    @IBAction func speechToggle(_ sender: Any){
        if let switchState = sender as? UISwitch{
            AppInternalStates.changeAccessibilitySpeechState()
            switchState.isOn=AppInternalStates.getAccessibilitySpeechState()
            guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else {
                return
            }
            appDelegate.saveContext()
        }
        
        
    }
    
  /*  func pronounce(text:String){
        let temp:AVSpeechUtterance=AVSpeechUtterance(string: text)
        ss.speak(temp)
    }
 */
    override func viewWillAppear(_ animated: Bool) {
        if let _ = AppInternalStates.internals?.userLogged{
         performSegue(withIdentifier: "loginSegue", sender: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        //fetchInternalData()
        languageTextField.allowsEditingTextAttributes=false
        accessibilitySpeechSwitch.isOn=AppInternalStates.getAccessibilitySpeechState()
        AppInternalStates.pronounce(text: welcomeHeaderTitle.text!)
        
      
        pickerView.dataSource = self
        pickerView.delegate = self
        languageTextField.inputView = pickerView

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    func showAlert(_ message:String){
        let alertMessage=UIAlertController(title: "Validation Unsuccessfull", message:message , preferredStyle: .alert)
                    alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertMessage, animated: true, completion: nil)


    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let language = languages[row]
        self.view.endEditing(true)
        
        let alert = UIAlertController(title: "\(languages[row]) Language Selected ", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
        switch row {
                case 0:
                    languageSelected = 0
                    languageTextField.text = language.localizableString("en")
                    welcomeHeaderTitle.text = welcomeHeaderTitle.text?.localizableString("en")
                    userIDLabel.text = userIDLabel.text?.localizableString("en")
                    userIDTextblock.placeholder = userIDTextblock.placeholder?.localizableString("en")
                    passwordLabel.text = passwordLabel.text?.localizableString("en")
                    passwordTextBlock.placeholder = passwordTextBlock.placeholder?.localizableString("en")
                    //forgotPasswordLabel.text = forgotPasswordLabel.text?.localizableString("en")
                    loginButton.setTitle(loginButton.title(for: .normal)?.localizableString("en"), for: .normal)
                    voiceLabel.text = voiceLabel.text?.localizableString("en")
                    
                    
                case 1:
                    languageSelected = 1
                    languageTextField.text = language.localizableString("es")
                    welcomeHeaderTitle.text = welcomeHeaderTitle.text?.localizableString("es")
                    userIDLabel.text = userIDLabel.text?.localizableString("es")
                    userIDTextblock.placeholder = userIDTextblock.placeholder?.localizableString("es")
                    passwordLabel.text = passwordLabel.text?.localizableString("es")
                    passwordTextBlock.placeholder = passwordTextBlock.placeholder?.localizableString("es")
                    //forgotPasswordLabel.text = forgotPasswordLabel.text?.localizableString("es")
                    loginButton.setTitle(loginButton.title(for: .normal)?.localizableString("es"), for: .normal)
                    voiceLabel.text = voiceLabel.text?.localizableString("es")
                
                default:
                    break
                }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages[row]
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
    
    private func validateUserName(_ userName:String)->Bool {
            //ToDo:username validations
            if userName.isAlphanumeric && userName.count>=7 && !userName[0].isNumber
            {
                return true
            }
            return false
        }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier=="loginSegue"{
            let destinationController = segue.destination as! HospitalListTableViewController
            destinationController.user=user
            destinationController.languageSelected = languageSelected
        }
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier=="loginSegue"{
            guard let userName=userIDTextblock.text else{
                return false
            }
            guard let password=passwordTextBlock.text else{
                return false
            }
            if validateUserName(userName){
                var userSearch:UserMO?
                for user in users {
                    if user.userId! == userName{
                        userSearch = user
                    }
                }
                guard let userFound = userSearch else {
                    //print("invalid username")
                    showAlert("Invalid Username")
                    return false
                }
                user=userFound
                if password != userFound.password!{
                    showAlert("Invalid Password")
                    return false
                }
                AppInternalStates.internals?.userLogged=user
                guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else {
                    return false
                }
                appDelegate.saveContext()
                return true
            }
            else{
                //print("invalid username")
                showAlert("Invalid Username")
                return false
            }
            
        }
        return false
    }
    
    
    

}

extension String {
    func localizableString(_ name: String) -> String {
        let path = Bundle.main.path(forResource: name, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}

extension LoginTableViewController{
    @IBAction func faceIDTapped(_ sender : UIButton){
        let context = LAContext()
        var error : NSError? = nil
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "Please authorize with TouchID"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){
                [weak self ] success,error in
                DispatchQueue.main.async {
                    guard success,error == nil else{
                        //failed
                        let alert = UIAlertController(title: "Failed to Authenticate", message: "FaceID did not matched", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                        return
                    }
                    //show other screen
                    //success
                    print("Face ID Recognised Successfully !!")
                    let alert = UIAlertController(title: "Success", message: "FaceID Authenticated ", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                    }
                }
        }
        else{
            //Cannot used
            let alert = UIAlertController(title: "Could not perform FaceID Recognition", message: "You can't use this feature since the app didn't allow", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}
extension LoginTableViewController : NSFetchedResultsControllerDelegate{
    func fetchData(){
        let fetchRequest: NSFetchRequest<UserMO> = UserMO.fetchRequest()
        fetchRequest.sortDescriptors = []
        guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else {
            return }
        let context = appDelegate.persistentContainer.viewContext
          fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchResultController.delegate = self
        
        do{
            try fetchResultController.performFetch()
            if let fetchedObjects = fetchResultController.fetchedObjects {
                users = fetchedObjects
            }
        }catch{
            print(error)
        }
    }
  /*  func fetchInternalData()
    {
        let fetchRequest: NSFetchRequest<AppInternalsStatesMO> = AppInternalsStatesMO.fetchRequest()
        fetchRequest.sortDescriptors = []
        guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else {
            return }
        let context = appDelegate.persistentContainer.viewContext
          fetchInternalsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
       fetchInternalsController.delegate = self
        
        do{
            try fetchInternalsController.performFetch()
            if let fetchedObjects = fetchInternalsController.fetchedObjects {
                internals = fetchedObjects.first
            }
        }catch{
            print(error)
        }
    }*/
}
extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
extension String {
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
}
