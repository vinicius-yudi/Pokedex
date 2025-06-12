//
//  Item.swift
//  Pokedex
//
//  Created by user277066 on 6/12/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
