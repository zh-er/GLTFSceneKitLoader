//
//  Texture.swift
//  Pods
//
//  Created by zh-er on 24/8/17.
//  Copyright © 2017 zh-er. All rights reserved.
//

import Foundation
import Mapper

struct Texture: Mappable, CustomStringConvertible {
    
    let sampler: Int?
    let source: Int
    
    init(map: Mapper) throws {
        sampler = map.optionalFrom("sampler")
        source = try map.from("source")
    }
    
    var description: String {
        let samplerDescription = "> sampler => \(sampler)"
        let sourceDescription = "> source => \(source)"
        return "\n\t[Texture]\n\t" + samplerDescription + "\n\t" + sourceDescription + "\n"
    }
}
