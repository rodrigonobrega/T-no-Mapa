//
//  StudentLocation.swift
//  Tá no Mapa
//
//  Created by Rodrigo on 29/08/2018.
//  Copyright © 2018 Rodrigo. All rights reserved.
//

import UIKit

struct StudentLocation {

    var objectId:String? //StudentLocation id
    
    
    var uniqueKey:String? // uma chave extra (opcional) usada para identificar exclusivamente um StudentLocation; você deve preencher este valor usando sua identificação da conta da Udacity
    
    var firstName:String? //o nome do aluno que corresponde ao nome do perfil na Udacity
    
    var lastName:String? //o sobrenome do aluno que corresponde ao sobrenome do perfil na Udacity
    
    var mapString:String? //o string de localização usado para geocodificar a localização do aluno
    
    var mediaURL:String? //a URL informada pelo aluno

    
    var latitude:NSNumber? //  latitude da localização do aluno (varia de -90 a 90)
    
    var longitude:NSNumber? //a longitude da localização do aluno (varia de -180 a 180)
    
    var createdAt:Date? //a data de criação da localização do aluno
    
    
    var updatedAt:Date? //a data de atualização mais recente da localização do aluno
    
    var ACL:Any? //a lista de acesso e controle (ACL) do Parse, ou seja, as permissões, para esta entrada do StudentLocation
    //Tipo do Parse: ACL
    
}

extension StudentLocation {
    init?(json: [String: Any]) {
        self.objectId   = json["objectId"] as? String
        self.uniqueKey  = json["uniqueKey"] as? String
        self.firstName  = json["firstName"] as? String
        self.lastName   = json["lastName"] as? String
        self.mapString  = json["mapString"] as? String
        self.mediaURL   = json["mediaURL"] as? String
        self.latitude   = json["latitude"] as? NSNumber
        self.longitude  = json["longitude"] as? NSNumber
        self.createdAt  = json["createdAt"] as? Date
        self.updatedAt  = json["updatedAt"] as? Date
        self.ACL        = json["ACL"] as? String // ?any
    }
}
