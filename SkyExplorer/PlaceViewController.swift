//
//  PlaceViewController.swift
//  SkyExplorer
//
//  Created by Emir Kalkan on 29.11.2019.
//  Copyright © 2019 Emir Kalkan. All rights reserved.
//

import UIKit
import Firebase

class PlaceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var latitudeArray = [Double]()
    var longitudeArray = [Double]()
    var titleArray = [String]()
    var subtitleArray = [String]()
    var idArray = [UUID]()
    var chosenTitle = ""
    var chosenTitleId: UUID?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))

    tableView.delegate = self
    tableView.dataSource = self
        
    getData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newPlace"), object: nil)
    }
    
    @objc func getData() {
        
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("Pins").addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    for document in snapshot!.documents {
                        let documentId = document.documentID
                        
                        //if let user = document.get("uuid") as? UUID {
                            //self.idArray.append(user)
                        //}
                        if let title = document.get("title") as? String {
                                                   self.titleArray.append(title)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func addButtonClicked() {
        chosenTitle = ""
        performSegue(withIdentifier: "toMapSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = titleArray[indexPath.row]
        return cell
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenTitle = titleArray[indexPath.row]
        //chosenTitleId = idArray[indexPath.row]
        performSegue(withIdentifier: "toMapSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMapSegue" {
            let destinationVC = segue.destination as! MapViewController
            destinationVC.selectedTitle = chosenTitle
            //destinationVC.selectedTitleId = chosenTitleId
        }
    }

}
