//
//  Material.swift
//  Pods
//
//  Created by zh-er on 24/8/17.
//  Copyright © 2017 zh-er. All rights reserved.
//

import Foundation
import Mapper


struct Material: Mappable, CustomStringConvertible {
    
    let name: String
    let emissive: [Float]
    let pbrMetallicRoughness: PbrMetallicRoughness?
    
    let normalTexture: MaterialTexture?
    let occlusionTexture: MaterialTexture?
    let emissiveTexture: MaterialTexture?
    
    init(map: Mapper) throws {
        
        name = map.optionalFrom("name") ?? ""
        emissive = map.optionalFrom("emissiveFactor") ?? [0,0,0]
        pbrMetallicRoughness = map.optionalFrom("pbrMetallicRoughness")
        
        normalTexture = map.optionalFrom("normalTexture")
        occlusionTexture = map.optionalFrom("occlusionTexture")
        emissiveTexture = map.optionalFrom("emissiveTexture")
        
    }
    
    var description: String {
        let levelPadding = "\n\t"
        let nameDescriptor = "> name => \(name)"
        let emissiveDescriptor = "> emissiveFactor => \(emissive)"
        let pbrMetallicRoughnessDescriptor = "> pbrMetallicRoughness => \(String(describing: pbrMetallicRoughness))"
        let normalTextureDescriptor = "> normalTexture => \(String(describing: normalTexture))"
        let occlusionTextureDescriptor = "> occlusionTexture => \(String(describing: occlusionTexture))"
        let emissiveTextureDescriptor = "> emissiveTextureDescriptor => \(String(describing: emissiveTexture))"
        return "\n\t[Material]\n\t" + nameDescriptor + "\n\t" + emissiveDescriptor + "\n\t" + pbrMetallicRoughnessDescriptor + levelPadding + normalTextureDescriptor + levelPadding + occlusionTextureDescriptor + levelPadding + emissiveTextureDescriptor + "\n"
    }
    
}


struct PbrMetallicRoughness: Mappable, CustomStringConvertible {
    
    let baseColorTexture: MaterialTexture?
    let metallicRoughnessTexture: MaterialTexture?
    let metallicFactor: Float
    
    init(map: Mapper) throws {
        
        baseColorTexture = map.optionalFrom("baseColorTexture")
        metallicRoughnessTexture = map.optionalFrom("metallicRoughnessTexture")
        metallicFactor = map.optionalFrom("metallicFactor") ?? 0
        
    }
    
    var description: String {
        let baseColorDescriptor = "> baseColorTexture => \(String(describing: baseColorTexture))"
        let metallicRoughnessTextureDescriptor = "> metallicRoughnessTexture => \(String(describing: metallicRoughnessTexture))"
        let metallicFactorDescriptor = "> metallicFactor => \(metallicFactor)"
        let levelPadding = "\n\t\t"
        return levelPadding + "[PbrMetalicRoughness]" + levelPadding + baseColorDescriptor + levelPadding + metallicRoughnessTextureDescriptor + levelPadding + metallicFactorDescriptor + "\n\t"
    }
    
}

struct MaterialTexture: Mappable, CustomStringConvertible {
    
    let index: Int
    let texCoord: Int?
    
    init(map: Mapper) throws {
        
        index = try map.from("index")
        texCoord = map.optionalFrom("texCoord")
    }
    
    var description: String {
        let levelPadding = "\n\t\t\t"
        let indexDescriptor = "> index => \(index)"
        let texCoordDescriptor = "> texCoord => \(String(describing: texCoord))"
        
        return levelPadding + "[MaterialTexture]" + levelPadding + indexDescriptor + levelPadding + texCoordDescriptor + "\n\t\t"
    }
}


