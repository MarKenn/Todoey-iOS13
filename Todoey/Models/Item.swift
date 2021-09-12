//
//  Item.swift
//  Todoey
//
//  Created by Mark Kenneth Bayona on 8/21/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title = ""
    @Persisted var done = false
    @Persisted var dateCreated = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
