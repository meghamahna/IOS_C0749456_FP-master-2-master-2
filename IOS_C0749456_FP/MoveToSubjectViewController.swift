//
//  MoveToSubjectViewController.swift
//  FinalProject_C0749456_IOS
//
//  Created by Megha Mahna on 2020-01-22.
//  Copyright © 2020 Megha. All rights reserved.
//

import UIKit
import CoreData

class MoveToSubjectViewController: UIViewController, UITableViewDelegate , UITableViewDataSource {
    
    var notesDelegate : NotesTableViewController?
    
     let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var categories = [Categories]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCoreData()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
            
    }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard categories.count != 0  else{
                return UITableViewCell()
            }
            
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "")
            let category = categories[indexPath.row]
            cell.textLabel?.text = category.value(forKeyPath: "name") as? String
            return cell
           
            
        }
        
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let alert = UIAlertController(title: " move to \(categories[indexPath.row].name)", message: "Are  you sure", preferredStyle: .alert)
//                                       let cancelAction = UIAlertAction(title: "No", style: .default, handler: nil)
//        let okAction = UIAlertAction(title: "Move", style: .default)
//        { (action) in
//
//        self.notesDelegate?.notesToBeMoved(index: indexPath.row)
//         self.presentingViewController?.dismiss(animated: true, completion: nil)
//    }
//
//                                           alert.addAction(okAction)
//                                            alert.addAction(cancelAction)
//                                           self.present(alert, animated: true, completion:  nil)
//
//                                   }
    
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
        
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func cancelButton(_ sender: UIButton) {
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
