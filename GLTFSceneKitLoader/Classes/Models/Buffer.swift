//
//  Buffer.swift
//  Pods
//
//  Created by zh-er on 24/8/17.
//  Copyright © 2017 zh-er. All rights reserved.
//

import Foundation
import Mapper


struct Buffer: Mappable, CustomStringConvertible {
    
    var byteLength: Int
    var uri: String
    
    init(map: Mapper) throws {
        
        byteLength = try map.from("byteLength")
        uri = try map.from("uri")
        
    }
    
    var description: String {
        return "\n\t[Buffer]\n\t> uri => \(uri)\n\t> byteLength => \(byteLength)\n"
    }
    
}
