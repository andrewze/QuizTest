//
//  APIManager.swift
//  Quiz
//
//  Created by andrei zeniukevich on 15/08/2018.
//  Copyright © 2018 andrei zeniukevich. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import RealmSwift

protocol Generics {
    static func url() -> String
    static func keyPath() -> String
}

class APIManager {
    
    static func getItemsForType <T: Object> (type: T.Type,
                                      success: @escaping () -> Void,
                                      fail:    @escaping (_ error: Error) -> Void) -> Void where T: Mappable, T: Generics {
        
        Alamofire.request(type.url()).responseArray(keyPath: type.keyPath()) { (response:
            DataResponse<[T]>) in

            switch response.result {
            case .success (let items):
                do {
                    let realm = try Realm()
                    try realm.write {
                        for item in items {
                            realm.add(item, update: true)
                        }
                    }
                } catch let error as NSError {
                    fail(error)
                }
                success()
            case .failure(let error):
                fail(error as NSError)
            }
        }
    }
}





