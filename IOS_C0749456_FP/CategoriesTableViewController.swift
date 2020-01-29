//
//  CategoriesTableViewController.swift
//  IOS_C0749456_FP
//
//  Created by Megha Mahna on 2020-01-27.
//  Copyright © 2020 Megha. All rights reserved.
//

import UIKit
import CoreData

class CategoriesTableViewController: UITableViewController {
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

 
    var categories = [Categories]()
    override func viewDidLoad() {
        super.viewDidLoad()
     
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let category = categories[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell",for: indexPath)
        cell.textLabel?.text = category.value(forKeyPath: "name") as? String
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
  
        if editingStyle == .delete {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(self.categories[indexPath.row])
        do{
            try managedContext.save()
            loadCoreData()
            self.tableView.reloadData()
            }
            
        catch{
            print("Failed")
        }
            
       }
    }
    
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    
    func callSegueFromCell(myData dataobject: AnyObject) {
      //try not to send self, just to avoid retain cycles(depends on how you handle the code on the next controller)
      self.performSegue(withIdentifier: "catgoryToNotesSegue", sender:dataobject )
    }
    

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New Category Name",message: "Add a new category",preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .destructive)
        {
                [unowned self] action in
                guard let textField = alert.textFields?.first,
                  let nameToSave = textField.text else {
                    return
                }
                self.saveCoreData(name: nameToSave)
                self.tableView.reloadData()
              }
                let cancelAction = UIAlertAction(title: "Cancel",style: .cancel)
                  alert.addTextField()
                  alert.addAction(saveAction)
                  alert.addAction(cancelAction)
                present(alert, animated: true)
    }
    
    func saveCoreData(name: String)
    {
        guard (UIApplication.shared.delegate as? AppDelegate) != nil else {
        return
      }
      let entity = NSEntityDescription.entity(forEntityName:"Categories",in: managedContext)!
        
      let category = Categories(context: self.managedContext)
      category.name = name
      categories.append(category)
        
      do {
        try managedContext.save()
      }
        
      catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }    }
    

    func loadCoreData(with request : NSFetchRequest<Categories> = Categories.fetchRequest())
     {
        
        do{
             categories = try managedContext.fetch(request)
         }
         
         catch
         {
             print("Could not fetch. \(error)")
         }
     }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
           
           guard (UIApplication.shared.delegate as? AppDelegate) != nil else {
             return
         }
           loadCoreData()
       }
    
    override func prepare(for segue: UIStoryboardSegue,sender: Any?)
    {
        let destination = segue.destination as! NotesTableViewController
        if let indexpath = tableView.indexPathForSelectedRow{
            destination.mainCategory = categories[indexpath.row]
        }

    }
    
        

}
