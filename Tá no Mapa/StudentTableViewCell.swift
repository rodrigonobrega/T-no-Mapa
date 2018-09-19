//
//  StudentTableViewCell.swift
//  Tá no Mapa
//
//  Created by Rodrigo on 05/09/2018.
//  Copyright © 2018 Rodrigo. All rights reserved.
//

import UIKit

class StudentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var mediaUrlLabel: UILabel!
    
    var student:StudentInformation? {
        didSet {
            setupLayout()
        }
    }
    
    func setupLayout() {
        if let student = student {
            if let firstName = student.firstName {
                self.firstNameLabel?.text = "\(firstName) "
            }
            if let lastName = student.lastName {
                self.firstNameLabel?.text?.append(lastName)
            }
            if let mediaURL = student.mediaURL {
                self.mediaUrlLabel.text = mediaURL
            }
        }

    }

}
