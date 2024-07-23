//
//  UserProfileViewController.swift
//  Superheroes
//
//  Created by Chris Davis J on 14/12/21.
//
import Contacts
import ContactsUI
import UIKit
import MessageUI

class UserProfileViewController: UIViewController, CNContactPickerDelegate {
    var user:UserMO?
    var languageSelected = 0
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var displayImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var nameValueLbl: UILabel!
    @IBOutlet weak var contactLbl: UILabel!
    @IBOutlet weak var contactValueLbl: UILabel!
    @IBOutlet weak var updateDPButton: UIButton!
    @IBOutlet weak var uploadImageView: UIImageView!
    
    @IBOutlet weak var uploadReports : UIButton!
    @IBOutlet weak var invite : UIButton!
    
    @IBAction func inviteBtnPressed(_ sender: Any) {
        let vc = CNContactPickerViewController()
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    var viewSelector:Int = -1
    
    @IBAction func uploadImageBtnPressed(_ sender: UIButton) {
        toggleImagePicker(selector: 1)
        
    }
    @IBAction func logoutBtnPressed(_ sender: Any) {
        guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else {
            return
        }
        AppInternalStates.internals?.userLogged=nil
        appDelegate.saveContext()
        //exit(0)
        restartApplication()
        
    }
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        print("Contact Selected is: \(contact.givenName + " " + contact.familyName)")
        if !MFMessageComposeViewController.canSendText() {
            print("SMS services are not available")
        }
        else{
        sendText(contact: contact)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor = .none
        if let userFound = user{
            nameValueLbl.text=userFound.userName
            contactValueLbl.text=userFound.userPh
            if let userDp=userFound.userDp{
                displayImageView.image = UIImage(data: userDp)
                displayImageView.contentMode = .scaleAspectFill
            }
            if let report=userFound.report{
                uploadImageView.image = UIImage(data: report)
                uploadImageView.contentMode = .scaleAspectFill
            }
        }

        // Do any additional setup after loading the view.
        if languageSelected == 1{
            nameLbl.text = nameLbl.text?.localizableString("es")
            contactLbl.text = contactLbl.text?.localizableString("es")
            updateDPButton.setTitle(updateDPButton.title(for: .normal)?.localizableString("es"), for: .normal)
            uploadReports.setTitle(uploadReports.title(for: .normal)?.localizableString("es"), for: .normal)
            invite.setTitle(invite.title(for: .normal)?.localizableString("es"), for: .normal)
            logoutButton.setTitle(logoutButton.title(for: .normal)?.localizableString("es"), for: .normal)
        }
        else{
            nameLbl.text = nameLbl.text?.localizableString("en")
            contactLbl.text = contactLbl.text?.localizableString("en")
            updateDPButton.setTitle(updateDPButton.title(for: .normal)?.localizableString("en"), for: .normal)
            uploadReports.setTitle(uploadReports.title(for: .normal)?.localizableString("en"), for: .normal)
            invite.setTitle(invite.title(for: .normal)?.localizableString("en"), for: .normal)
            logoutButton.setTitle(logoutButton.title(for: .normal)?.localizableString("en"), for: .normal)
        }
    }
    @IBAction func UIElementSelected(_ sender: Any) {
        if let obj = sender as? UIButton{
            AppInternalStates.pronounce(text:obj.accessibilityIdentifier ?? "")
        }
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
extension UserProfileViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func toggleImagePicker(selector:Int){
        let photoSourceController = UIAlertController(title: "", message: "Choose your photo source", preferredStyle: .actionSheet)
                        
                        //create action for cameraa source
                        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
                            (action) in
                            if UIImagePickerController.isSourceTypeAvailable(.camera){
                                let imagePicker = UIImagePickerController()
                                imagePicker.allowsEditing = false
                                imagePicker.sourceType = .camera
                                imagePicker.delegate = self
                                self.viewSelector=selector
                                self.present(imagePicker, animated: true, completion: nil)
                            }
                        })
                        
                        //create action for photos
                        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: {
                            (action) in
                            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                                let imagePicker = UIImagePickerController()
                                imagePicker.allowsEditing = false
                                imagePicker.sourceType = .photoLibrary
                                imagePicker.delegate = self
                                self.viewSelector=selector
                                self.present(imagePicker, animated: true, completion: nil)
                            }
                        })
                        
                        //creating cancel action
                        
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                        
                        //add actions to the alert controller
                        photoSourceController.addAction(cameraAction)
                        photoSourceController.addAction(photoLibraryAction)
                        photoSourceController.addAction(cancelAction)
                        
                        present(photoSourceController, animated: true, completion: nil)
        
    }
    @IBAction func uploadDP(_ sender : UIButton){
       toggleImagePicker(selector: 0)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                var imgView:UIImageView
                switch viewSelector {
                case 0:
                    imgView=displayImageView
                    
                case 1:
                    imgView=uploadImageView
                default:
                    return
                }
                imgView.image = selectedImage
                imgView.contentMode = .scaleAspectFill
                guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else {
                    return
                }
                let image = imgView.image
                let data = image?.jpegData(compressionQuality: 0.5)
                switch viewSelector {
                case 0:
                    user?.userDp=data
                    
                case 1:
                    user?.report=data
                default:
                    return
                }
                appDelegate.saveContext()
                //photoImage.clipToBounds = true
            }
            
            dismiss(animated: true, completion: nil)
        }
}
extension UserProfileViewController:MFMessageComposeViewControllerDelegate{
    
     func sendText(contact: CNContact) {
            if (MFMessageComposeViewController.canSendText()) {
                let controller = MFMessageComposeViewController()
                controller.body = "Use SuperHeroes App with ease."
                controller.recipients = contact.phoneNumbers.map { number in
                    number.value.stringValue}
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil)
            }
        }

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            //... handle sms screen actions
            self.dismiss(animated: true, completion: nil)
        }
    func restartApplication () {
        let firstWindow = UIApplication.shared.windows.first
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        UIView.transition(with: firstWindow!, duration: 0.3, options: .transitionCrossDissolve, animations: {
            firstWindow?.rootViewController = storyboard.instantiateInitialViewController()
            })
        
    }
}
