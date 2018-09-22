//
//  TaNoMapaDataSource.swift
//  Tá no Mapa
//
//  Created by Mac mini on 20/09/2018.
//  Copyright © 2018 Rodrigo. All rights reserved.
//

import UIKit



class TaNoMapaDataSource {
    static let sharedInstance = TaNoMapaService()
    static var userLogged:StudentInformation?
    
    private var students:[StudentInformation] = [StudentInformation]()
    private let kStudentKey = "StudentInformationKey"
    
    func getStudentLocation() -> [StudentInformation] {
        if let studentsDecoded = UserDefaults.standard.object(forKey: kStudentKey) as? NSData {
            if let studentsUserDefaults = NSKeyedUnarchiver.unarchiveObject(with: studentsDecoded as Data) as? [StudentInformation] {
                students = studentsUserDefaults
            }
        }
        return students
    }
    
    func save(student: StudentInformation) {
        self.students.append(student)
        saveStudentInUserDefaults()
    }
    
    func saveStudentInUserDefaults(){
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: students)
        UserDefaults.standard.set(encodedData, forKey: kStudentKey)
        UserDefaults.standard.synchronize()
    }
    
     
}
