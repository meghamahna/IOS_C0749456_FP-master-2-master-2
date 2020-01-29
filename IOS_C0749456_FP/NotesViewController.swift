//
//  NotesViewController.swift
//  IOS_C0749456_FP
//
//  Created by Megha Mahna on 2020-01-27.
//  Copyright © 2020 Megha. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

var imagePicker: UIImagePickerController!
class NotesViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()

    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latitude: UILabel!
    
    @IBOutlet weak var longitude: UILabel!
    weak var taskTable: NotesTableViewController?
    
    @IBOutlet weak var titletext: UITextView!
    
    
    @IBOutlet weak var imageView: UIImageView!
//    let appdelegate = UIApplication.shared.delegate as! AppDelegate
//    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
 
   
    var editNotes: Notes?
    var userIsEditing =  true
    var mainCategory : Categories?
    
    var addNotes: Notes?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findCurrentLocation()
        latitudeLabel.isHidden = true
        longitudeLabel.isHidden = true
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if (userIsEditing == true) {
            print("Editing an existing note")
            titletext.text = editNotes?.title!
            self.imageView.image = UIImage(data: editNotes?.notesImage! as! Data)
            latitude.text = String(editNotes!.latitude)
            longitude.text = String(editNotes!.longitude)
            latitudeLabel.isHidden = false
            longitudeLabel.isHidden = false
            
        }
        else {
            
            print("Going to add a new note to: \(mainCategory?.name ?? "")")
            titletext.text = ""
            
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        

        
                                findCurrentLocation()
                                print(userIsEditing)
                                if (userIsEditing == true) {

                                    editNotes!.title = titletext.text!
                                }
                                else {


                                   addNotes = Notes(context:managedContext)
                                   addNotes!.notesToCategories = self.mainCategory
                                   addNotes?.setValue(Date(), forKey: "date")

                                    if (titletext.text!.isEmpty) {
                                       addNotes!.title = "No Title"
                                        //note.title = "No Title"
                                    }
                                    else{
                                        addNotes!.title = titletext.text!

                                    }

                                    let imageData = imageView.image!.pngData() as NSData?
                                    addNotes!.notesImage = imageData as Data?
                                    //addNotes!.notesToCategories = self.mainCategory
                                }

                                do {
                                    try managedContext.save()
                                    print("Note Saved!")


                                    // show an alert box
                                    let alertBox = UIAlertController(title: "Saved!", message: "Save Successful.", preferredStyle: .alert)
                                    alertBox.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                    self.present(alertBox, animated: true, completion: nil)
                                }
                                catch {
                                    print("Error saving note in Edit Note screen")

                                    // show an alert box with an error message
                                    let alertBox = UIAlertController(title: "Error", message: "Error while saving.", preferredStyle: .alert)
                                    alertBox.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                    self.present(alertBox, animated: true, completion: nil)
                                }

                                if (userIsEditing == false) {
                                    self.navigationController?.popViewController(animated: true)
                                    //self.dismiss(animated: true, completion: nil)
                                }
        
    }

    
    @IBAction func camera(_ sender: UIBarButtonItem) {
        
       let pickerController = UIImagePickerController()
       pickerController.delegate = self
       pickerController.allowsEditing = true
       
       let alertController = UIAlertController(title: "Add an Image", message: "Choose From", preferredStyle: .actionSheet)
       
       let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
           pickerController.sourceType = .camera
           self.present(pickerController, animated: true, completion: nil)
           }
       
       let photosLibraryAction = UIAlertAction(title: "Photos Library", style: .default) { (action) in
           pickerController.sourceType = .photoLibrary
           self.present(pickerController, animated: true, completion: nil)
           
       }
       
       let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
       alertController.addAction(cameraAction)
       alertController.addAction(photosLibraryAction)
       alertController.addAction(cancelAction)
       
       present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            let imageData = image.pngData() as NSData?

       self.imageView.image = UIImage(data: imageData! as Data)
               self.dismiss(animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           findCurrentLocation()
       }
    
    @IBAction func getLocation(_ sender: UIBarButtonItem) {
    }
    func findCurrentLocation() {
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           let userLocation:CLLocation = locations[0] as CLLocation
          
        editNotes?.latitude = userLocation.coordinate.latitude
        editNotes?.longitude = userLocation.coordinate.longitude
           print("user latitude = \(userLocation.coordinate.latitude)")
           print("user longitude = \(userLocation.coordinate.longitude)")
       }
       
       func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
       {
           print("Error \(error)")
       }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewWillDisappear(_ animated: Bool) {
        taskTable?.tableView.reloadData()
        taskTable?.loadCoreNotes()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
            if (segue.identifier == "LocationSegue") {
                    let destination = segue.destination as! MapViewController
                let lat:Double = editNotes!.latitude
                let long:Double = editNotes!.longitude
                destination.latitude = lat
                destination.longitude = long
                
            }
//        if(segue.identifier == "AudioSegue"){
//            
//            let destination = segue.destination as! ViewController
//            destination.audioDelegate = self
//            destination.audioTitle = editNotes?.title
//        }
      

    }

}
