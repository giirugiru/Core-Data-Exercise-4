//
//  HitlistTableVC.swift
//  Core Data Exercise 4
//
//  Created by Gilang Sinawang on 12/12/20.
//

import UIKit
import CoreData

// This project is using UITableViewController
// MARK: LAST UPDATE 15 DEC 10.53

class TargetTableVC: UITableViewController {
    
    // To append sample data, only for viewing
    //var targetName: [String] = []
    //var targetName: [String] = ["Alpha","Beta","Omega"]
    
    // Initialize NSManagedObject as array var
    var targetNames: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    
    // MARK: - Table view data source
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return targetNames.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let name = targetNames[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TargetCell", for: indexPath)
        
        // Configure the cell...
        //cell.textLabel?.text = targetNames[indexPath.row]
        cell.textLabel?.text = name.value(forKey: "name") as? String
        cell.textLabel?.textColor = .white
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    @IBAction func AddButtonTapped(_ sender: UIBarButtonItem) {
        addData()
    }
    
    // MARK: Textfield alert to add new data
    func addData(){
        
        // Pass textfield input to a variable
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Target Name", message: "", preferredStyle: .alert)
        
        let save = UIAlertAction(title: "Save", style: .default) { (saveAction) in
            //self.targetName.append(textField.text!)
            
            // MARK: Save data to Core Data
            if textField.text != "" {
            self.saveData(name: textField.text!)
            self.tableView.reloadData()
            } else {
                // Validate if the textfield empty
                let emptyAlert = UIAlertController(title: "Name cannot be empty", message: "", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                emptyAlert.addAction(okAction)
                self.present(emptyAlert, animated: true, completion: nil)
                print("Data cannot be empty")
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Input target tame"
            textField = alertTextField
        }
        
        // Adding action to alert
        alert.addAction(save)
        alert.addAction(cancel)
        
        // Presenting the alert
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: Function to save data to Core Data
    func saveData(name: String) {
        
        
        // Template code to activate core data
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Add entity name here
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        
        let data = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // Add attribute name here
        data.setValue(name, forKeyPath: "name")
        
        // Append data to core data
        do {
            try managedContext.save()
            targetNames.append(data)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    // MARK: Function to fetch data from Core Data
    func fetchData(){
        
        // Template code to activate core data
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Add entity name here
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        // Fetch data to existing array
        do {
            targetNames = try managedContext.fetch(fetchRequest)
            print(targetNames.count)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
//    func deleteData(){
//        //let items = list.mutableSetValue(forKey: "items")
//        //let data = targetNames.mutable
//
//        //if let anyItem = items.anyObject() as? NSManagedObject {
////            managedObjectContext.delete(anyItem)
////        }
//
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        let managedContext = appDelegate.persistentContainer.viewContext
//
//        // Add entity name here
//        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
//
//        let person = NSManagedObject(entity: entity, insertInto: managedContext)
//
//        // Add attribute name here
//        let data = person.mutableSetValue(forKey: "name")
//
//        if let anyItem = data.anyObject() as? NSManagedObject {
//            managedObjectContext.delete(anyItem)
//        }
//    }
    
    
    
//     MARK: Function to delete data from Core Data
//    
//        func deleteData(){
//            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Person")
//            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//    
//            do {
//                try myPersistentStoreCoordinator.execute(deleteRequest, with: myContext)
//            } catch let error as NSError {
//                // TODO: handle the error
//            }
//        }
    
    
    
}
