//
//  Item.swift
//  Todoey
//
//  Created by CHAO JIANG on 6/12/18.
//  Copyright © 2018 nickjc1. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var isChecked: Bool = false
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
