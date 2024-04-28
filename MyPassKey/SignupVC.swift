//
//  SignupVC.swift
//  MyPassKey
//
//  Created by Fırat Ören on 16.04.2024.
//

import UIKit
import CoreData

class SignupVC: UIViewController {

    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var nameTf: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

//        if UserDefaults.standard.object(forKey: "email") != nil || UserDefaults.standard.object(forKey: "name") != nil {
//            UserDefaults.standard.removeObject(forKey: "email")
//            UserDefaults.standard.removeObject(forKey: "name")
//            UserDefaults.standard.synchronize()
//            print("userdefault deleted")
//        } else {
//            print("no userdefault")
//        }
    }
    

    @IBAction func signUpContinueTapped(_ sender: UIButton) {
        guard let email = emailTf.text , let password = passwordTf.text , let name = nameTf.text , !email.isEmpty , !password.isEmpty , !name.isEmpty else {return}
        
        createAccount(email: email, password: password, name: name.uppercased())
            let userEmail = UserDefaults.standard
            let userName = UserDefaults.standard
            //let userLogged = UserDefaults.standard
            userEmail.setValue(email, forKey: "email")
            userName.setValue(name, forKey: "name")
            //userLogged.setValue("logged", forKey: "islogged")
            userEmail.synchronize()
            userName.synchronize()
            //userLogged.synchronize()
            self.dismiss(animated: true)
        
    }
    
    
    
    
    
    
    func createAccount(email: String, password: String, name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Accounts", in: managedContext)
        let accounts = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        accounts.setValue(email, forKey: "account_email")
        accounts.setValue(password, forKey: "account_password")
        accounts.setValue(name, forKey: "account_name")
        
        do {
            try managedContext.save()
            print("account being created")
        } catch{
            print("error has occured creating account")
        }
    }

}
