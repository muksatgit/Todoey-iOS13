//
//  Item.swift
//  Todoey
//
//  Created by Mukesh Kumar on 2020-04-27.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift
class Item: Object {
    @objc dynamic var title:String = ""
    @objc dynamic var selected:Bool = false
    @objc dynamic var dateCreated:Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
