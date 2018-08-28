//
//  Answer.swift
//  Quiz
//
//  Created by andrei zeniukevich on 19/08/2018.
//  Copyright © 2018 andrei zeniukevich. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Answer: Object, Mappable {
    
    @objc dynamic var order     = 1
    @objc dynamic var text      = ""
    @objc dynamic var isCorrect = 0
    
    override static func primaryKey() -> String? {
        return "text"
    }

    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        order       <- map["order"]
        text        <- map["text"]
        isCorrect   <- map["isCorrect"]   
    }
}
