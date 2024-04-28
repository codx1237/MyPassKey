//
//  ForgotPasswordVC.swift
//  MyPassKey
//
//  Created by Fırat Ören on 22.04.2024.
//

import UIKit
import CoreData

class ForgotPasswordVC: UIViewController {

    
    @IBOutlet weak var emailTf: UITextField!
    
    @IBOutlet weak var nameTf: UITextField!
    
    let uilabel = UILabel(frame: CGRect(x: 0, y: 0, width: 500, height: 40))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        uilabel.textAlignment = .center
        uilabel.textColor = .white
        uilabel.center = view.center
        self.view.addSubview(uilabel)
        self.hideKeyboardWhenTappedAround()
        
    }
    

    @IBAction func forgotPasswordTapped(_ sender: UIButton) {
        guard let email = emailTf.text , let name = nameTf.text , !email.isEmpty , !name.isEmpty else {
            uilabel.text = "Missing Information"
            return
        }
        uilabel.text = getLoginAccount(email: email, name: name)
        
        
    }
    

    func getLoginAccount(email: String, name: String) -> String {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return ""}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<Accounts> = Accounts.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "account_email == %@", email)
        fetchRequest.predicate = NSPredicate(format: "account_name == %@", name)
        
        do{
            let accounts = try managedContext.fetch(fetchRequest)
            if accounts.count == 0 {
                return "No Account Found"
            } else {
                for account in accounts {
                    return "Your Password is: \(account.account_password!)"
                }
            }
        } catch {
            print("error when getting forgot password data")
        }
        return "no data"
    }

}
