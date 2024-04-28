//
//  AddPasswordVC.swift
//  MyPassKey
//
//  Created by Fırat Ören on 22.04.2024.
//

import UIKit
import CoreData

class AddPasswordVC: UIViewController {

    
    @IBOutlet weak var titleTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func savePasswordTapped(_ sender: UIButton) {
        guard let title = titleTf.text , let password = passwordTf.text , !title.isEmpty , !password.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Missing information", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            present(alert,animated: true)
            return
        }
        addPassword(title: title.uppercased(), password: password)
        self.navigationController?.popViewController(animated: true)
    }
    
    func addPassword(title: String, password: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Passwords", in: managedContext)
        let passwords = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        passwords.setValue(title, forKey: "title")
        passwords.setValue(password, forKey: "password")
        
        do {
            try managedContext.save()
            print("password being added")
        } catch{
            print("error has occured adding password")
        }
    }

}
