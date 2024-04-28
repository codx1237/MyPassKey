//
//  HomePageVC.swift
//  MyPassKey
//
//  Created by Fırat Ören on 21.04.2024.
//

import UIKit
import CoreData

class HomePageVC: UIViewController , UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var passwordsTableView: UITableView!
    
    var passwords = [Password]()
    var tapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        passwordsTableView.delegate = self
        passwordsTableView.dataSource = self
        passwordsTableView.tableHeaderView = UIView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        passwords.removeAll()
        getPasswords()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPasswordDetail" {
            if let indexPath = self.passwordsTableView.indexPathForSelectedRow {
                let controller = segue.destination as! PasswordDetailVC
                controller.passwordTitle = passwords[indexPath.row].password_title
                controller.password = passwords[indexPath.row].password_password
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passwords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "password_cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = passwords[indexPath.row].password_title.uppercased()
        cell.detailTextLabel?.text = tapped ? passwords[indexPath.row].password_password : "*****"
        cell.detailTextLabel?.textColor = .white
        cell.detailTextLabel?.font = .systemFont(ofSize: 17,weight: .black)
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = .systemFont(ofSize: 19, weight: .semibold)
//        let cell = tableView.dequeueReusableCell(withIdentifier: "password_cell", for: indexPath) as? PasswordCell
//        cell?.pp = tapped ? passwords[indexPath.row].password_password : "*****"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tapped.toggle()
        tableView.reloadData()
//        let actionSheet = UIAlertController(title: "EDIT", message: "", preferredStyle: .actionSheet)
//        actionSheet.addAction(UIAlertAction(title: "DELETE", style: .destructive, handler: { _ in
//            print("deleting..")
//            self.deletePassword(passwordTitle: self.passwords[indexPath.row].password_title)
//            self.passwords.remove(at: indexPath.row)
//            self.passwordsTableView.reloadData()
//            
//        }))
//        actionSheet.addAction(UIAlertAction(title: "EDIT", style: .default, handler: { _ in
//            print("editing")
//            self.performSegue(withIdentifier: "showPasswordDetail", sender: nil)
//        }))
//        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//        self.present(actionSheet,animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alertDelete = UIAlertController(title: "DELETE", message: "Are you sure ?", preferredStyle: .alert)
            alertDelete.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alertDelete.addAction(UIAlertAction(title: "Okey", style: .default, handler: { _ in
                self.deletePassword(passwordTitle: self.passwords[indexPath.row].password_title,password: self.passwords[indexPath.row].password_password)
                self.passwords.remove(at: indexPath.row)
                self.passwordsTableView.reloadData()
                
            }))
            self.present(alertDelete,animated: true)
        }
    }
    

    func getPasswords(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<Passwords> = Passwords.fetchRequest()
        
        do{
            let passwords = try managedContext.fetch(fetchRequest)
            for passkey in passwords {
                let p = Password(password_title: passkey.title!, password_password: passkey.password!)
                self.passwords.append(p)
                passwordsTableView.reloadData()
            }
        } catch{
            print("error getting passwords")
        }
    }
    
    func deletePassword(passwordTitle: String,password: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<Passwords> = Passwords.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", passwordTitle)
        fetchRequest.predicate = NSPredicate(format: "password == %@", password)
        fetchRequest.fetchLimit = 1
        
        do {
            let passwords = try managedContext.fetch(fetchRequest)
            for pass in passwords {
                managedContext.delete(pass)
            }
            try managedContext.save()
        } catch {
            print("error when deleting passwords")
        }
    }


}


struct Password {
    let password_title: String
    let password_password: String
}
