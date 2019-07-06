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

class RequestManager {
    
    static var shared = RequestManager()
    
    let headers: HTTPHeaders = ["key": "Content-Type",
                                "value": "application/json",
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
}
