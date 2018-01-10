//
//  BufferView.swift
//  Pods
//
//  Created by zh-er on 24/8/17.
//  Copyright © 2017 zh-er. All rights reserved.
//

import Foundation
import Mapper

struct BufferView: Mappable, CustomStringConvertible {
    
    let buffer: Int
    let byteLength: Int
    let byteOffset: Int
    let target: Int?
    let byteStride: Int
    
    init(map: Mapper) throws {
        
        buffer = try map.from("buffer")
        byteLength = try map.from("byteLength")
        byteOffset = try map.optionalFrom("byteOffset") ?? 0
        byteStride = try map.optionalFrom("byteStride") ?? 0
        target = map.optionalFrom("target")
        
        
    }
    
    var description: String {
        return "\n\t[BufferView]\n\t> buffer => \(buffer)\n\t> byteLength => \(byteLength)\n\t> byteOffset => \(byteOffset)\n\t> byteStride => \(byteStride)\n\t> target => \(target)\n"
    }
}
