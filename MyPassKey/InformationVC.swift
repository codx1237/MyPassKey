//
//  InformationVC.swift
//  MyPassKey
//
//  Created by Fırat Ören on 22.04.2024.
//

import UIKit
import CoreData

class InformationVC: UIViewController {

    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let name = UserDefaults.standard.string(forKey: "name") , let email = UserDefaults.standard.string(forKey: "email") {
            nameLbl.text = name
            emailLbl.text = email
        }
        
    }
    

    @IBAction func signOutTapped(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "islogged")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func deleteAccoutTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "DELETE", message: "Your account and saved passwords will be deleted.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            if let email = UserDefaults.standard.string(forKey: "email") {
                self.deleteAccount(email: email)
                self.deletePasswords()
                UserDefaults.standard.removeObject(forKey: "email")
                UserDefaults.standard.removeObject(forKey: "name")
                UserDefaults.standard.removeObject(forKey: "islogged")
                UserDefaults.standard.synchronize()
                self.navigationController?.popToRootViewController(animated: true)
            }
            
        }))
        self.present(alert,animated: true)
    }
    
    
    func deleteAccount(email: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Accounts> = Accounts.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "account_email == %@", email)
        fetchRequest.fetchLimit = 1
    
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
    
    func deletePasswords(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Passwords> = Passwords.fetchRequest()
        
        do{
            let passwords = try! managedContext.fetch(fetchRequest)
            for pass in passwords {
                managedContext.delete(pass)
            }
            try managedContext.save()
        } catch {
            print("error when deleting passwordss")
        }
    }
    
    
    
}
