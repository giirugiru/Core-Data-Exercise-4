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
    
    @IBAction func AddButtonTapped(_ sender: UIBarButtonItem) {
        alert()
    }
    
    // MARK: Textfield alert to add new data
    func alert(){
        
        // Pass textfield input to a variable
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Target Name", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (saveAction) in
            //self.targetName.append(textField.text!)
            
            // MARK: Save data to Core Data
            self.saveData(name: textField.text!)
            self.tableView.reloadData()
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Input target tame"
            textField = alertTextField
        }
        
        // Adding action to alert
        alert.addAction(saveAction)
        alert.addAction(cancel)
        
        // Presenting the alert
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: Function to save data to Core Data
    func saveData(name: String) {
        
        
        // Template code to activate core data
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // Add entity name here
        let entity =
            NSEntityDescription.entity(forEntityName: "Person",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // Add attribute name here
        person.setValue(name, forKeyPath: "name")
        
        // Append data to core data
        do {
            try managedContext.save()
            targetNames.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    // MARK: Function to fetch data from Core Data
    func fetchData(){
        
        // Template code to activate core data
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Add entity name here
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        // Fetch data to existing array
        do {
            targetNames = try managedContext.fetch(fetchRequest)
            print(targetNames.count)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: Function to delete data from Core Data
    
        func deleteData(){
            guard let appDelegate =
                    UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Person")
            fetchRequest.predicate = NSPredicate(format: "name = %@", targetNames)
//            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
          
            do {
                let dataToDelete = try managedContext.fetch(fetchRequest) [0] as! NSManagedObject
                managedContext.delete(dataToDelete)
//                try myPersistentStoreCoordinator.execute(deleteRequest, with: myContext)
                try managedContext.save()
            } catch let error{
                // TODO: handle the error
                print(error)
            }
        }
    
}

extension TargetTableVC{
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete{
            delete(targetNames[indexPath.row])
//            tableView.reloadData()
           
        }
    }
}
