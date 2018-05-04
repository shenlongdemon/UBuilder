//
//  MyProfileViewController.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 4/30/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class MyProfileViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    var user: User = Store.getUser()!
    @IBOutlet weak var imgImage: UIImageView!
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtState: UITextField!
    
    @IBOutlet weak var txtZipcode: UITextField!
    
    @IBOutlet weak var txtCountry: UITextField!
    let imagePicker = UIImagePickerController()
    
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pickImage(tapGestureRecognizer:)))
        self.imgImage.isUserInteractionEnabled = true
        self.imgImage.addGestureRecognizer(tapGestureRecognizer)
        self.loadInfo()
        // Do any additional setup after loading the view.
    }
    @objc func pickImage(tapGestureRecognizer: UITapGestureRecognizer)
    {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    func loadInfo() {
        txtFirstName.text = user.firstName
        txtLastName.text = user.lastName
        txtState.text = user.state
        txtZipcode.text = user.zipCode
        txtCountry.text = user.country
        imgImage.image = Util.getImage(data64: user.image)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let image = Util.resizeImage(image: pickedImage)
            imgImage.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func save(_ sender: Any) {
        let user = Store.getUser()!
        user.firstName = txtFirstName.text!
        user.lastName = txtLastName.text!
        user.state = txtState.text!
        user.zipCode = txtZipcode.text!
        user.country = txtCountry.text!
        user.image = Util.getData64(image: imgImage.image! )
        Store.saveUser(user: user)
        WebApi.updateUser(user: user) { (done) in
            if (done){
                Util.showOKAlert(VC: self, message: "Update success.")
            }
            else {
                 Util.showOKAlert(VC: self, message: "Error.")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profile_qrcode"{
            let vc = segue.destination as! QRCODEViewController
            vc.prepareModel(item: self.user.id)
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    @IBAction func showQRCode(_ sender: Any) {
        self.performSegue(withIdentifier: "profile_qrcode", sender: self)
    }

}
