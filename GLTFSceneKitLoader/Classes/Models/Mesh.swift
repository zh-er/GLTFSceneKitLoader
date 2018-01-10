//
//  Mesh.swift
//  Pods
//
//  Created by zh-er on 24/8/17.
//  Copyright © 2017 zh-er. All rights reserved.
//

import Foundation
import Mapper


struct Mesh: Mappable, CustomStringConvertible {
    
    let primitives: [Primitive]
    
    init(map: Mapper) throws {
        primitives = map.optionalFrom("primitives") ?? []
    }
    
    var description: String {
        return "\n\t[Mesh]\n\t> Primitives => \(primitives.description)\n"
    }
    
}

struct Primitive: Mappable, CustomStringConvertible {
    
    let indices: Int
    
    let mode: PrimitiveMode?
    let material: Int?
    let attribute: PrimitiveAttributes?
    
    init(map: Mapper) throws {
        indices = try map.from("indices")
        
        mode = map.optionalFrom("mode")

        material = map.optionalFrom("material")
        
        attribute = map.optionalFrom("attributes")
    }
    
    var description: String {
        return "\n\t\t[Primitive]\n\t\t> indices => \(indices)\n\t\t> mode => \(mode)\n\t\t> material => \(material)\n\t\t> attribute => \(attribute)\n\t"
    }
}

struct PrimitiveAttributes: Mappable, CustomStringConvertible {
    
    let position: Int?
    let normal: Int?
    let tangent: Int?
    let texCoord_0: Int?
    let texCoord_1: Int?
    
    init(map: Mapper) throws {
        position = map.optionalFrom("POSITION")
        normal = map.optionalFrom("NORMAL")
        tangent = map.optionalFrom("TANGENT")
        texCoord_0 = map.optionalFrom("TEXCOORD_0")
        texCoord_1 = map.optionalFrom("TEXCOORD_1")
    }
    
    var description: String {
        return "\n\t\t\t[PrimitiveAttributes]\n\t\t\t> position => \(position)\n\t\t\t> normal => \(normal)\n\t\t\t> texCoord_0 => \(texCoord_0)\n\t\t\t> texCoord_1 \(texCoord_1)\n\t\t"
    }
}
