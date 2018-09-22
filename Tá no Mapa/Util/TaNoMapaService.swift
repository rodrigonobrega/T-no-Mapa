//
//  TaNoMapaService.swift
//  Tá no Mapa
//
//  Created by Rodrigo on 02/09/2018.
//  Copyright © 2018 Rodrigo. All rights reserved.
//

import UIKit
import MapKit

class TaNoMapaService: NSObject {

    
    private static let kURLStudentsLocation = "https://parse.udacity.com/parse/classes/StudentLocation"
    private static let kURLStudentsSession = "https://www.udacity.com/api/session"
    private static let kApplicationJson = "application/json"
    private static let kContentType = "Content-Type"
    private static let kHeaderFieldApplicationKey = "X-Parse-Application-Id"
    private static let kHeaderFieldApplicationValue = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    private static let kHeaderFieldAPIKey = "X-Parse-REST-API-Key"
    private static let kHeaderFieldAPIValue = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    private static let kResultsKey = "results"
    private static let kAccept = "Accept"
    private static let kPost = "POST"
    private static let kGet = "GET"
    private static let kDelete = "DELETE"
    private static let kErrorKey = "error"
    private static let kErrorMessage = "Something went wrong"
    private static let kWrongCredentials = "Wrong credentials"
    private static let kResultsService = "results"
    typealias userDictionary = ([String:Any]?, String?) -> Void
    typealias addUserSuccess = (Bool) -> Void
    
    // MARK: Capture student locations
    func locations(closure:  @escaping ([StudentInformation]? , String?) -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: "\(TaNoMapaService.kURLStudentsLocation)?limit=100&order=-updatedAt" )!)
        request.addValue(TaNoMapaService.kHeaderFieldApplicationValue, forHTTPHeaderField: TaNoMapaService.kHeaderFieldApplicationKey)
        request.addValue(TaNoMapaService.kHeaderFieldAPIValue, forHTTPHeaderField: TaNoMapaService.kHeaderFieldAPIKey)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                closure(nil, TaNoMapaService.kErrorMessage)
                return
            }
            
            guard let dataJson = data else {
                closure(nil, TaNoMapaService.kErrorMessage)
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: dataJson, options: []) as? [String:AnyObject] else {
                closure(nil, TaNoMapaService.kErrorMessage)
                return
            }
            
            var students = [StudentInformation]()
            
            if let results = json![TaNoMapaService.kResultsKey] as? [Any] {
                
                for item in results {
                    if let studentLocation = item as? [String:Any] {
                        students.append(StudentInformation(json: studentLocation)!)
                    }
                }
            }
            closure( students, nil)
        }
        task.resume()
    }
    
    
    // MARK: - Add new user(user, location and url)
    static func addUser(annotation: MKPointAnnotation, completion: @escaping addUserSuccess) {
        let locationString = annotation.title
        let mediaURL = annotation.subtitle
        let latitude = annotation.coordinate.latitude
        let longitude = annotation.coordinate.longitude
        let uniqueKey = TaNoMapaDataSource.userLogged?.uniqueKey
        let firstName = TaNoMapaDataSource.userLogged?.firstName
        let lastName = TaNoMapaDataSource.userLogged?.lastName
        
        let request = NSMutableURLRequest(url: URL(string: TaNoMapaService.kURLStudentsLocation)!)
        request.httpMethod = TaNoMapaService.kPost
        request.addValue(TaNoMapaService.kHeaderFieldApplicationValue, forHTTPHeaderField: TaNoMapaService.kHeaderFieldApplicationKey)
        request.addValue(TaNoMapaService.kHeaderFieldAPIValue, forHTTPHeaderField: TaNoMapaService.kHeaderFieldAPIKey)
        request.addValue(TaNoMapaService.kApplicationJson, forHTTPHeaderField: TaNoMapaService.kContentType)
        request.httpBody = "{\"uniqueKey\": \"\(uniqueKey ?? String())\", \"firstName\": \"\(firstName ?? String())\", \"lastName\": \"\(lastName ?? String())\",\"mapString\": \"\(locationString ?? String())\", \"mediaURL\": \"\(mediaURL ?? String())\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error == nil {
                completion(true)
            } else {
                completion(false)
            }
            
        }
        task.resume()
    }
    
    // MARK: - login(email: String, password:String, completion: @escaping userDictionary)
    func login(email: String, password:String, completion: @escaping userDictionary) {
        
        let request = NSMutableURLRequest(url: URL(string: TaNoMapaService.kURLStudentsSession)!)
        request.httpMethod = TaNoMapaService.kPost
        request.addValue(TaNoMapaService.kApplicationJson, forHTTPHeaderField: TaNoMapaService.kAccept)
        request.addValue(TaNoMapaService.kApplicationJson, forHTTPHeaderField: TaNoMapaService.kContentType)
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if error != nil {
                completion(nil, TaNoMapaService.kErrorMessage)
                return
            }
            
            let statusCode = (response as! HTTPURLResponse).statusCode
            
            if statusCode == 403 {
                completion(nil, TaNoMapaService.kWrongCredentials)
                return
            }
            
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            do {
                if let json = try JSONSerialization.jsonObject(with: newData!, options: .mutableContainers) as? [String:AnyObject] {
                    completion(json, nil)
                }
            } catch {
                completion(nil, TaNoMapaService.kErrorMessage)
            }
        }
       
        task.resume()
        
    }
    
    // MARK: - logout())
    func logout() {
        let request = NSMutableURLRequest(url: URL(string: TaNoMapaService.kURLStudentsSession)!)
        request.httpMethod = TaNoMapaService.kDelete
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            
            /* Logout! */
            
        }
        task.resume()
    }
    
    // MARK: - Update a logged user
    func updateUserWithKey(_ userKey: String) {
        let url = "\(TaNoMapaService.kURLStudentsLocation)?where=%7B%22uniqueKey%22%3A%22\(userKey)%22%7D"
        
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.addValue(TaNoMapaService.kHeaderFieldApplicationValue, forHTTPHeaderField: TaNoMapaService.kHeaderFieldApplicationKey)
        request.addValue(TaNoMapaService.kHeaderFieldAPIValue, forHTTPHeaderField: TaNoMapaService.kHeaderFieldAPIKey)
        
        request.httpMethod = TaNoMapaService.kGet
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            
            if error == nil {
                
                do {
                    
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String:AnyObject] {
                        if let result = json[TaNoMapaService.kResultsService] as? [[String:AnyObject]] {
                           
                            if let user = StudentInformation(json: result.first!) {
                                TaNoMapaDataSource.userLogged = user
                            }
                        }
                    }
                } catch {
                    print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
                }
            }
        }
        task.resume()
        
    }
}
