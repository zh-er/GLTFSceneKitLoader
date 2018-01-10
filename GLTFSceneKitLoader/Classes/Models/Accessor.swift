//
//  Accessor.swift
//  Pods
//
//  Created by zh-er on 24/8/17.
//  Copyright © 2017 zh-er. All rights reserved.
//

import Foundation
import Mapper


struct Accessor: Mappable, CustomStringConvertible {
    
    let bufferView: Int
    let byteOffset: Int
    let componentType: ComponentType
    let count: Int
    
    let max: [Float]?
    let min: [Float]?
    
    let type: AccessorType
    
    
    init(map: Mapper) throws {
        bufferView = try map.from("bufferView")
        byteOffset = map.optionalFrom("byteOffset") ?? 0
        componentType = try map.from("componentType")
        count = try map.from("count")

        max = map.optionalFrom("max")
        min = map.optionalFrom("min")
        
        type = try map.from("type")
    }
    
    var description: String {
        return "\n\t[Accessor]\n\t> bufferView => \(bufferView)\n\t> byteOffset => \(byteOffset)\n\t> componentType => \(componentType)\n\t> count => \(count)\n\t> type => \(type)\n\t> max => \(max)\n\t> min => \(min)\n"
    }
    
}


