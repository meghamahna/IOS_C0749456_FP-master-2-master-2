//
//  NotesTableViewController.swift
//  IOS_C0749456_FP
//
//  Created by Megha Mahna on 2020-01-27.
//  Copyright © 2020 Megha. All rights reserved.
//

import UIKit
import CoreData

class NotesTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var filteredNotes = [Notes]()
    var notes = [Notes]()
    var categories: [Categories]?
    var selectedrows : [IndexPath]?
    var mainCategory : Categories?{
        
        didSet{
            loadCoreNotes()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCoreNotes()
        filteredNotes = notes
        searchBar.delegate = self
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
        return filteredNotes.count
    }

    
    
     
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = filteredNotes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell")
        cell?.textLabel?.text = note.title!
        cell?.detailTextLabel?.text = "\(note.date!)"
        return cell!
    }
  

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
         guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
             return
         }
         let managedContext = appDelegate.persistentContainer.viewContext
         managedContext.delete(self.notes[indexPath.row])
        filteredNotes.remove(at: indexPath.row)
         do{
             try managedContext.save()
             loadCoreNotes()
             self.tableView.reloadData()
             }
             
         catch{
             print("Failed")
         }
             
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   if (segue.identifier == "EditNoteSegue") {
       
       let destination = segue.destination as! NotesViewController
       //destination.taskTable = self
       let i = (self.tableView.indexPathForSelectedRow?.row)!
       destination.editNotes = notes[i]
       
   }
   else if (segue.identifier == "AddNoteSegue") {
       // person wants to add a new note
       let destination = segue.destination as! NotesViewController
       //destination.taskTable = self
       destination.userIsEditing = false
       destination.mainCategory = self.mainCategory
    
       
      }
    }
    
    
    
    func loadCoreNotes() {
        
        let fetchRequest:NSFetchRequest<Notes> = Notes.fetchRequest()
        
            let mainCategoryPradicate = NSPredicate(format: "notesToCategories.name MATCHES %@", self.mainCategory!.name!)
      

        fetchRequest.predicate = mainCategoryPradicate
        do {
            notes = try managedContext.fetch(fetchRequest)
            self.tableView.reloadData()
        } catch {
            print("cannot fetch from database")
        }
        tableView.reloadData()
    }
    
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
        
        //tableView.reloadData()
        loadCoreNotes()
        
    }
    
//    func notesToBeMoved(index : Int){
//
//        selectedrows = tableView.indexPathsForSelectedRows!
//
//        for i in selectedrows!{
//
//            let move = notes[i.row]
//            //notes[index].notesToCategories = move
//            categories![index].categoriesToNotes = move
//            do{
//                try managedContext.save()
//            }
//            catch{
//                print("error")
//            }
//            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//                        return
//                    }
//                    let managedContext = appDelegate.persistentContainer.viewContext
//                    managedContext.delete(move)
//                    do{
//                        try managedContext.save()
//                        loadCoreNotes()
//                        self.tableView.reloadData()
//                        }
//
//                    catch{
//                        print("Failed")
//                    }
//
//        }
//        loadCoreNotes()
//
//    }

}

extension NotesTableViewController: UISearchBarDelegate{

func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
    filteredNotes = searchText.isEmpty ? notes : notes.filter({ (item: Notes) -> Bool in
        return item.title!.range(of: searchText, options: .caseInsensitive) != nil
    })
    
    tableView.reloadData()
  }
}
