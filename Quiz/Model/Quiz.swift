//
//  Quiz.swift
//  Quiz
//
//  Created by andrei zeniukevich on 15/08/2018.
//  Copyright © 2018 andrei zeniukevich. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Quiz: Object, Mappable, Generics {
    
    @objc dynamic var buttonStart                   = ""
    @objc dynamic var shareTitle                    = ""
    @objc dynamic var createdAt                     = ""
    @objc dynamic var sponsored                     = false
    @objc dynamic var id                            = 0
    @objc dynamic var title                         = ""
    @objc dynamic var type                          = ""
    @objc dynamic var content                       = ""
    @objc dynamic var currentQuestionNumber         = 0
    @objc dynamic var procentSuccessForOneQuestion  = 0.0
    @objc dynamic var result                        = 0.0
    @objc dynamic var mainPhoto: QuizMainPhoto?
    var lastScore = RealmOptional<Int>()

    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func url() -> String {
        let url = "http://quiz.o2.pl/api/v1/quizzes/0/20"
        return url
    }
    
    static func keyPath() -> String {
        let keyPath = "items"
        return keyPath
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        buttonStart   <- map["buttonStart"]
        shareTitle    <- map["shareTitle"]
        createdAt     <- map["createdAt"]
        sponsored     <- map["sponsored"]
        id            <- map["id"]
        title         <- map["title"]
        type          <- map["type"]
        content       <- map["content"]
        mainPhoto     <- map["mainPhoto"]
    }  
}

class QuizMainPhoto: Object, Mappable {
    
    @objc dynamic var author     = ""
    @objc dynamic var width      = 0
    @objc dynamic var source     = ""
    @objc dynamic var title      = ""
    @objc dynamic var url        = ""
    @objc dynamic var height     = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        author     <- map["author"]
        width      <- map["width"]
        source     <- map["source"]
        title      <- map["title"]
        url        <- map["url"]
        height     <- map["height"]
    }
}

class QuizCategory: Object, Mappable {
    
    @objc dynamic var id    = 0
    @objc dynamic var name  = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        id      <- map["id"]
        name    <- map["name"]
    }
}

func getObjects<T:Object>()->[T] {
    let realm = try! Realm()
    let realmResults = realm.objects(T.self)
    return Array(realmResults)
    
}


