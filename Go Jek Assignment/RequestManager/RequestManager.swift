//
//  RequestManager.swift
//  Go Jek Assignment
//
//  Created by jogi on 04/07/19.
//  Copyright © 2019 ketanDemo. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

let BASE_URL: String = "http://gojek-contacts-app.herokuapp.com"
enum ScreenType{
    case Add
    case Edit
    case View
}
class RequestManager {
    
    static var shared = RequestManager()
    
    let headers: HTTPHeaders = ["Content-Type": "application/json",
                                "description": ""]
    
    func getContacts(completion: @escaping (Result<[Contacts]>) -> ()){
        let urlstring : String = BASE_URL + "/contacts.json"
        Alamofire.request(urlstring, method: .get, parameters: nil, headers: headers).responseJSON { (response) in
            if let err = response.result.error {
                print(err)
                completion(.failure(err))
                return
            }
            do{
                guard let data = response.data else{
                    return
                }
                let contacts = try JSONDecoder().decode([Contacts].self, from: data)
                completion(.success(contacts))
            }catch{
                completion(.failure(error))
            }
        }
    }
    func getContactDetail(profileUrl:String, completion: @escaping (Result<ContactDetail>) -> ()){
        let urlstring : String = profileUrl
        Alamofire.request(urlstring, method: .get, parameters: nil, headers: headers).responseJSON { (response) in
            if let err = response.result.error {
                print(err)
                completion(.failure(err))
                return
            }
            do{
                guard let data = response.data else{
                    return
                }
                let contactDetail = try JSONDecoder().decode(ContactDetail.self, from: data)
                completion(.success(contactDetail))
            }catch{
                completion(.failure(error))
            }
        }
    }
    func addContactWithDetail(contact:AddContact,completion: @escaping (Result<String>) -> ()){
        let urlstring : String = BASE_URL + "/contacts.json"
        let params : [String : Any]  = ["first_name":contact.firstName,"last_name":contact.lastName,"email":contact.email,"phone_number":contact.phone,"favorite":contact.isFavorite]
                
        Alamofire.request(urlstring, method: .post, parameters:["mode":"row","row":params], headers: headers).responseJSON { (response) in
            if let err = response.result.error {
                print(err)
                completion(.failure(err))
                return
            }
                completion(.success("suceess"))
        }
    }
    func editContactWithDetail(contact:AddContact,contactId:Int, completion: @escaping (Result<String>) -> ()){
        let urlstring : String = BASE_URL + "/contacts/\(contactId).json"
        let params : [String : Any]  = ["first_name":contact.firstName,"last_name":contact.lastName,"email":contact.email,"phone_number":contact.phone,"favorite":contact.isFavorite]
        
        Alamofire.request(urlstring, method: .put, parameters:["mode":"row","row":params], headers: headers).responseJSON { (response) in
            if let err = response.result.error {
                print(err)
                completion(.failure(err))
                return
            }
            completion(.success("suceess"))
        }
    }
}
