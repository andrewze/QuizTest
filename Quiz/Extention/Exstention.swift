//
//  Exstention.swift
//  Quiz
//
//  Created by andrei zeniukevich on 24/08/2018.
//  Copyright © 2018 andrei zeniukevich. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

func <- <T: Mappable>(left: List<T>, right: Map)
{
    var array: [T]?
    
    if right.mappingType == .toJSON {
        array = Array(left)
    }
    
    array <- right
    
    if right.mappingType == .fromJSON {
        if let theArray = array {
            left.append(objectsIn: theArray)
        }
    }
}

extension Double {
    func toString() -> String {
        return String(format: "%.f",self)
    }
}
