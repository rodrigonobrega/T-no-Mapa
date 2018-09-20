//
//  AppDelegate.swift
//  Tá no Mapa
//
//  Created by Rodrigo on 29/08/2018.
//  Copyright © 2018 Rodrigo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var memes:[StudentInformation] = [StudentInformation]()
    private let kMemesKey = "students"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // check if exist meme in user defaults
        if let memesDecoded = UserDefaults.standard.object(forKey: kMemesKey) as? NSData {
            if let memesUserDefaults = NSKeyedUnarchiver.unarchiveObject(with: memesDecoded as Data) as? [StudentInformation] {
                memes = memesUserDefaults
            }
        }
        return true
    }
    
    // MARK: - Use UserDefaults to simulate a database
    func save(meme: StudentInformation) {
        self.memes.append(meme)
        saveMemeInUserDefaults()
    }
    
    func saveMemeInUserDefaults(){
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: memes)
        UserDefaults.standard.set(encodedData, forKey: kMemesKey)
        UserDefaults.standard.synchronize()
    }
    
    static func memes() -> [StudentInformation] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }

}

