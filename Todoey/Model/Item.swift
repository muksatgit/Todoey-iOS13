//
//  Item.swift
//  Todoey
//
//  Created by Mukesh Kumar on 2020-04-24.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
struct Item:Codable {
    var title:String = ""
    var selected:Bool = false
    
    init(_ itemTitle:String, _ isSelected:Bool) {
        title = itemTitle
        selected = isSelected
    }
}
