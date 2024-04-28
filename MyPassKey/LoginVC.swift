//
//  ViewController.swift
//  MyPassKey
//
//  Created by Fırat Ören on 16.04.2024.
//

import UIKit
import CoreData
import LocalAuthentication

class LoginVC: UIViewController {

   
    
    @IBOutlet weak var keyImage: UIImageView!
    @IBOutlet weak var emailTfLogin: UITextField!
    @IBOutlet weak var passwordTfLogin: UITextField!
    @IBOutlet weak var welcomeLbl: UILabel!
    @IBOutlet weak var continueBtn: UIButton!
    
    var faceIdBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let userEmail = UserDefaults.standard
//        let userName = UserDefaults.standard
//        userEmail.setValue("oren_2011@hotmail.com", forKey: "email")
//        userName.setValue("FIRAT", forKey: "name")
//        userEmail.synchronize()
//        userName.synchronize()
        self.hideKeyboardWhenTappedAround()
        faceIdBtn.center = view.center
        faceIdBtn.setTitle("Continue", for: .normal)
        faceIdBtn.setTitleColor(.yellow, for: .normal)
        faceIdBtn.titleLabel?.font = .systemFont(ofSize: 33, weight: .black)
        faceIdBtn.addTarget(self, action: #selector(myAuth), for: .touchUpInside)
        view.addSubview(faceIdBtn)
        faceIdBtn.isHidden = true
    

    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        if !isThereAnyAccount() {
            performSegue(withIdentifier: "showSignUp", sender: nil)
        } else {
            if self.faceIDAvailable() {
                if UserDefaults.standard.object(forKey: "islogged") != nil {
                    if let userName = UserDefaults.standard.string(forKey: "name") {
                        welcomeLbl.text = "WELCOME \(userName)"
                        faceIdBtn.isHidden = false
                        emailTfLogin.isHidden = true
                        passwordTfLogin.isHidden = true
                        continueBtn.isHidden = true
                    }
                } else {
                        welcomeLbl.text = "WELCOME"
                        faceIdBtn.isHidden = true
                        emailTfLogin.isHidden = false
                        passwordTfLogin.isHidden = false
                        continueBtn.isHidden = false
                }
            } else {
                if UserDefaults.standard.object(forKey: "islogged") != nil {
                    if let userName = UserDefaults.standard.string(forKey: "name") {
                        welcomeLbl.text = "WELCOME \(userName)"
                        faceIdBtn.isHidden = true
                        emailTfLogin.isHidden = false
                        passwordTfLogin.isHidden = false
                        continueBtn.isHidden = false
                    }
                } else {
                        welcomeLbl.text = "WELCOME"
                        faceIdBtn.isHidden = true
                        emailTfLogin.isHidden = false
                        passwordTfLogin.isHidden = false
                        continueBtn.isHidden = false
                }
            }

        }

    }
    
    
    @IBAction func loginPageContinueTapped(_ sender: UIButton) {
        if !isThereAnyAccount() {
            let alert = UIAlertController(title: "Error", message: "There is no account associated with this phone. Please Create One.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                self.performSegue(withIdentifier: "showSignUp", sender: nil)
            }))
            self.present(alert,animated: true)
        } else {
            guard let email = emailTfLogin.text , let password = passwordTfLogin.text , !email.isEmpty , !password.isEmpty else {
                let alert = UIAlertController(title: "Error", message: "Missing information", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert,animated: true)
                return
            }
            if isAccountExist(email: email, password: password) {
                emailTfLogin.text = ""
                passwordTfLogin.text = ""
                UserDefaults.standard.setValue("logged", forKey: "islogged")
                UserDefaults.standard.synchronize()
                self.performSegue(withIdentifier: "showHomePage", sender: nil)
                print("you will be directed to the homepage")
            } else {
                let alert = UIAlertController(title: "Error", message: "Wrong email or password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert,animated: true)
            }
            
        }
    }
    

    
    
    
    
    
    
    func deleteAccount() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Accounts> = Accounts.fetchRequest()
    
        do {
            let objects = try! managedContext.fetch(fetchRequest)
            for obj in objects {
                managedContext.delete(obj)
            }
            try managedContext.save()
        } catch {
            print("error deleting data")
        }
          
    }
    
    
    
    func isAccountExist(email: String, password: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return false}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Accounts> = Accounts.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "account_email == %@", email)
        fetchRequest.predicate = NSPredicate(format: "account_password == %@", password)
        fetchRequest.fetchLimit = 1
        
        do {
            let count = try! managedContext.count(for: fetchRequest)
            
            if count == 1 {
                print("Match..")
                return true
            } else {
                print("No Match")
            }
        }

        return false
    }
    
    func isThereAnyAccount() -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return false}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Accounts> = Accounts.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        do {
            let count = try! managedContext.count(for: fetchRequest)
            
            if count == 1 {
                print("There is one account.")
                return true
            } else {
                print("There is no account!")
            }
        }

        return false
        
    }
    
    func getAccounts(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Accounts> = Accounts.fetchRequest()
        
        do {
            let accounts = try managedContext.fetch(fetchRequest)
            for account in accounts {
                print("email: \(account.account_email), password: \(account.account_password), name: \(account.account_name) ")
            }
        } catch{
            print("error getting accounts")
        }
    }
    
    func getAccountHolderName(email: String, password: String) -> String {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return ""}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Accounts> = Accounts.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "account_email == %@", email)
        fetchRequest.predicate = NSPredicate(format: "account_password == %@", password)
        
        do {
            let accounts = try managedContext.fetch(fetchRequest)
            for account in accounts {
                return account.account_name!
            }
        } catch {
            print("error getting name data")
        }
        return "no name data"
    }
    
    
   @objc func myAuth() {
        let context = LAContext()
            var error: NSError?

            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Identify yourself!"
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                    [weak self] success, authenticationError in
                    
                    

                    DispatchQueue.main.async {
                        if success {
                            print("success")
                            self!.performSegue(withIdentifier: "showHomePage", sender: nil)
                        } else {
                            // error
                            print("wrong password")
                        }
                    }
                }
            } else {
                // no biometry
            }
    }

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
            let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        }
        
        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
    
    func faceIDAvailable() -> Bool {
        if #available(iOS 11.0, *) {
            let context = LAContext()
            return (context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: nil) && context.biometryType == .faceID)
        }
        return false
    }
}


