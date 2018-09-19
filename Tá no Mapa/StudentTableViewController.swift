//
//  StudentTableViewController.swift
//  Tá no Mapa
//
//  Created by Rodrigo on 02/09/2018.
//  Copyright © 2018 Rodrigo. All rights reserved.
//

import UIKit

class StudentTableViewController: UITableViewController {

    var students = [StudentInformation]()
    private let kAlertTitle = "On the map"
    @IBOutlet var studentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshLocations()
        
    }
    
    @IBAction func refreshLocations() {
        let service = TaNoMapaService.init()
        service.locations { (students) in
            self.students = students
            DispatchQueue.main.async {
                self.studentTableView.reloadData()
            }
        }
    }

    @IBAction func logout(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.students.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! StudentTableViewCell
        let student = self.students[indexPath.row]
        cell.student = student
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = self.students[indexPath.row]
        if let mediaURL = student.mediaURL {
            if let url = URL(string: mediaURL) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.openURL(url)
                } else {
                    let alert = UIAlertController.init(title: self.kAlertTitle, message: "Invalid input URL", preferredStyle: .alert)
                    let okButton = UIAlertAction.init(title: "ok", style: .default, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
