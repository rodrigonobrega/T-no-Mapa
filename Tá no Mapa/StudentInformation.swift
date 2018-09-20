//
//  StudentLocation.swift
//  Tá no Mapa
//
//  Created by Rodrigo on 29/08/2018.
//  Copyright © 2018 Rodrigo. All rights reserved.
//

import UIKit

// MARK: - Struct StudentInformation
struct StudentInformation {

    var objectId:String?
    var uniqueKey:String?
    var firstName:String?
    var lastName:String?
    var mapString:String?
    var mediaURL:String?
    var latitude:NSNumber?
    var longitude:NSNumber?
    var createdAt:String?
    var updatedAt:String?
    var ACL:Any? //controle de permissões
    
}

extension StudentInformation {
    
    init?(json: [String: Any]) {
        self.objectId   = json["objectId"] as? String
        self.uniqueKey  = json["uniqueKey"] as? String
        self.firstName  = json["firstName"] as? String
        self.lastName   = json["lastName"] as? String
        self.mapString  = json["mapString"] as? String
        self.mediaURL   = json["mediaURL"] as? String
        self.latitude   = json["latitude"] as? NSNumber
        self.longitude  = json["longitude"] as? NSNumber
        self.createdAt  = json["createdAt"] as? String
        self.updatedAt  = json["updatedAt"] as? String
        self.ACL        = json["ACL"] as? String
    }
}
