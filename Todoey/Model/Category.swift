//
//  Category.swift
//  Todoey
//
//  Created by Mukesh Kumar on 2020-04-27.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name:String = ""
    let items = List<Item>()
}
