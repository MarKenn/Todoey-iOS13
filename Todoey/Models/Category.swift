//
//  Category.swift
//  Todoey
//
//  Created by Mark Kenneth Bayona on 8/21/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var bgHexColor = ""
    @Persisted var name = ""
    @Persisted var items = List<Item>()
}
