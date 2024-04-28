//
//  PasswordDetailVC.swift
//  MyPassKey
//
//  Created by Fırat Ören on 23.04.2024.
//

import UIKit
import CoreData

class PasswordDetailVC: UIViewController {

    
    @IBOutlet weak var titleTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    
    var passwordTitle: String?
    var password: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let title = passwordTitle , let pass = password {
            titleTf.placeholder = title
            passwordTf.placeholder = pass
        }
        
    }
    

    @IBAction func editTapped(_ sender: UIButton) {
        guard let newTitle = titleTf.text , let newPassword = passwordTf.text , !newTitle.isEmpty , !newPassword.isEmpty else {
            let alert = UIAlertController(title: "Missing", message: "Missing information!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert,animated: true)
            return
        }
        if let oldTitle = passwordTitle , let oldPassword = password {
            updatePassword(title: oldTitle, password: oldPassword,newT: newTitle.uppercased(),newP: newPassword)
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    func updatePassword(title:String, password: String,newT: String, newP: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
       // let entity = NSEntityDescription.entity(forEntityName: "Passwords", in: managedContext)
       // let passwords = NSManagedObject(entity: entity!, insertInto: managedContext)
        let fetchRequest : NSFetchRequest<Passwords> = Passwords.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        fetchRequest.predicate = NSPredicate(format: "password == %@", password)
        
        do{
            let pass = try managedContext.fetch(fetchRequest)
            for p in pass {
                p.setValue(newT, forKey: "title")
                p.setValue(newP, forKey: "password")
            }
            try managedContext.save()
        } catch {
            print("error!!")
        }
    }

}
