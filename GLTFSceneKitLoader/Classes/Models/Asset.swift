//
//  Asset.swift
//  Pods
//
//  Created by zh-er on 24/8/17.
//  Copyright © 2017 zh-er. All rights reserved.
//

import Foundation
import Mapper


struct Asset: Mappable, CustomStringConvertible {
    
    let version: String
    
    init(map: Mapper) throws {
        version = try map.from("version")
    }
    
    var description: String {
        return "\n\t[Asset]\n\t> version => \(version)\n"
    }
    
}
