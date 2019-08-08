//
//  Item.swift
//  Todoey
//
//  Created by Rod Toll on 8/7/19.
//  Copyright © 2019 Rod Toll. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
