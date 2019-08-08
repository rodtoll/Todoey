//
//  Category.swift
//  Todoey
//
//  Created by Rod Toll on 8/7/19.
//  Copyright © 2019 Rod Toll. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var title: String = ""
    var items = List<Item>()
}
