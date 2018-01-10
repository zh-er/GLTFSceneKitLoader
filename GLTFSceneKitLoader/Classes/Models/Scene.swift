//
//  Scene.swift
//  Pods
//
//  Created by zh-er on 24/8/17.
//  Copyright © 2017 zh-er. All rights reserved.
//

import Foundation
import Mapper

struct Scene: Mappable, CustomStringConvertible {
    
    /// the nodes the scene is referencing
    let nodes: [Int]
    
    init(map: Mapper) throws {
        nodes = map.optionalFrom("nodes") ?? []
    }
    
    var description: String {
        return "\n\t[Scene]\n\t> Nodes => \(nodes)\n"
    }
    
}

