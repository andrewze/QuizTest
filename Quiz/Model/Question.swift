//
//  Quiestion.swift
//  Quiz
//
//  Created by andrei zeniukevich on 19/08/2018.
//  Copyright © 2018 andrei zeniukevich. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm

class Question: Object, Mappable, Generics {
    
    static var quizID: Int?
    
    var image: QuestionImage?
    var answers = List<Answer>()
    @objc dynamic var text      = ""
    @objc dynamic var type      = ""
    @objc dynamic var order     = 0
    @objc dynamic var id        = 0
    
    static func url() -> String {
        let url = "http://quiz.o2.pl/api/v1/quiz/\(quizID!)/0"
        return url
    }
    
    static func keyPath() -> String {
        let keyPath = "questions"
        return keyPath
    }
    
    override static func primaryKey() -> String? {
        return "text"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        image   <- map["image"]
        answers <- map["answers"]
        text    <- map["text"]
        type    <- map["type"]
        order   <- map["order"]
        id = Question.quizID!
    }
    
}

class QuestionImage: Object, Mappable {
    
    @objc dynamic var author    = ""
    @objc dynamic var width     = ""
    @objc dynamic var mediaId   = ""
    @objc dynamic var source    = ""
    @objc dynamic var url       = ""
    @objc dynamic var height    = ""
    
    override static func primaryKey() -> String? {
        return "url"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        width     <- map["width"]
        mediaId   <- map["mediaId"]
        source    <- map["source"]
        url       <- map["url"]
        height    <- map["height"]
        
    }
}
