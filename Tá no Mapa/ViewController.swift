//
//  ViewController.swift
//  Tá no Mapa
//
//  Created by Rodrigo on 29/08/2018.
//  Copyright © 2018 Rodrigo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var students = [StudentLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //teste()
        studentsLocation()
    }

    
    
//    // Convert from NSData to json object
//    func nsdataToJSON(data: NSData) -> AnyObject? {
//        do {
//            return try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as AnyObject
//        } catch let myJSONError {
//            print(myJSONError)
//        }
//        return nil
//    }
//
//    // Convert from JSON to nsdata
//    func jsonToNSData(json: AnyObject) -> NSData?{
//        do {
//            return try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
//        } catch let myJSONError {
//            print(myJSONError)
//        }
//        return nil;
//    }
    
    private static let kURLStudentsLocation = "https://parse.udacity.com/parse/classes/StudentLocation"
    private static let kHeaderFieldApplicationKey = "X-Parse-Application-Id"
    private static let kHeaderFieldApplicationValue = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    private static let kHeaderFieldAPIKey = "X-Parse-REST-API-Key"
    private static let kHeaderFieldAPIValue = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    private static let kResultsKey = "results"
    
    
    func studentsLocation()  {
        let request = NSMutableURLRequest(url: URL(string: ViewController.kURLStudentsLocation)!)
        request.addValue(ViewController.kHeaderFieldApplicationValue, forHTTPHeaderField: ViewController.kHeaderFieldApplicationKey)
        request.addValue(ViewController.kHeaderFieldAPIValue, forHTTPHeaderField: ViewController.kHeaderFieldAPIKey)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                return
            }
  
            if let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let results = json![ViewController.kResultsKey] as? [Any]{
                    for item in results {
                        if let re = item as? [String:Any] {
                            self.students.append(StudentLocation(json: re)!)
                        }
                    }
                }
            }
        }
        task.resume()
    }

    func teste() {
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation"
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error
                return
            }
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
    }
    
    func postAddStudent() {
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
    }
    
    func locationStudent() {
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/8ZExGR5uX8"
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Cupertino, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.322998, \"longitude\": -122.032182}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
    }
}

