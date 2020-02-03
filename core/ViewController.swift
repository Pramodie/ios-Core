//
//  ViewController.swift
//  core
//
//  Created by pramodie athauda on 2/1/20.
//  Copyright © 2020 pramodie athauda. All rights reserved.
//table view with add data array in table//

import UIKit
import CoreData

class ViewController: UIViewController {
    var names:[NSManagedObject]=[]
   
    @IBOutlet weak var tableNames: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title="The Names"
        tableNames.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Names")
        
        //3
        do {
            names = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    @IBAction func add(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New name", message: "Add a new name", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default){[unowned self] action in
            guard let textField = alert.textFields?.first, let nameToSave = textField.text
                else{
                    return
            }
           // self.names.append(nameToSave)
            self.save(name:  nameToSave)
            self.tableNames.reloadData()
        }
            alert.addTextField()
            alert.addAction(saveAction)
            present(alert, animated: true  )
        
    }
    //drag and drop delete button access
    func delteData(name: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Names")
        fetchRequest.predicate = NSPredicate(format: "name = %@", name)
        
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            
            let objectToDelete = test[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            
            do{
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
            
        }
        catch
        {
            print(error)
        }
    }
    //end delete button
    func save(name: String)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let  entity = NSEntityDescription.entity(forEntityName: "Names", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(name, forKeyPath: "name")
        
        do {
            try managedContext.save()
            names.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        
    }
    
}
extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        //        return cell
       let pNames = names[indexPath.row]
//
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        //
//        //        cell.textLabel?.text = people[indexPath.row]
//        //
//
        cell.textLabel?.text =
            pNames.value(forKeyPath: "name") as? String
        return cell
    }
}


