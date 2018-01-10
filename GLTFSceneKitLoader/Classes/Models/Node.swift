//
//  Node.swift
//  Pods
//
//  Created by zh-er on 24/8/17.
//  Copyright © 2017 zh-er. All rights reserved.
//

import Foundation
import Mapper
import SceneKit

struct Node: Mappable, CustomStringConvertible {
    
    let children: [Int]?
    
    let matrix: SCNMatrix4
    
    let mesh: Int?
    
    let translation: SCNVector3?
        
    
    init(map: Mapper) throws {
        children = map.optionalFrom("children") ?? []
        mesh =  map.optionalFrom("mesh")
        matrix = map.optionalFrom("matrix") ?? SCNMatrix4Identity
        translation = map.optionalFrom("translation")
    }
    
    var description: String {
        return "\n\t[Node]\n\t> Mesh => \(mesh?.description)\n\t> Children => \(children?.description)\n\t> matrix => \(matrix)\n\t> translation => \(translation)\n"
    }
}

