//
//  GLTF.swift
//  Pods
//
//  Created by zh-er on 24/8/17.
//  Copyright © 2017 zh-er. All rights reserved.
//

import Foundation
import Mapper

/// MARK: - CONSTANTS





struct GLTF: Mappable, CustomStringConvertible {
    
    let asset: Asset
    
    let scenes: [Scene]
    
    let scene: Int
    
    let nodes: [Node]
    
    let meshes: [Mesh]
    
    let accessors: [Accessor]
    
    let bufferView: [BufferView]
    
    let buffer: [Buffer]
    
    let materials: [Material]
    
    let textures: [Texture]
    
    let images: [Image]
    
    let samplers: [Sampler]
    
    
    init(map: Mapper) throws {
        
        asset = try map.from("asset")
        
        scene = map.optionalFrom("scene") ?? 0
        
        scenes = map.optionalFrom("scenes") ?? []
        
        nodes = map.optionalFrom("nodes") ?? []
        
        meshes = map.optionalFrom("meshes") ?? []
        
        accessors = map.optionalFrom("accessors") ?? []
        
        bufferView = map.optionalFrom("bufferViews") ?? []
        
        buffer = map.optionalFrom("buffers") ?? []
        
        materials = map.optionalFrom("materials") ?? []
        
        textures = map.optionalFrom("textures") ?? []
        
        images = map.optionalFrom("images") ?? []
        
        samplers = map.optionalFrom("samplers") ?? []
    }
    
    var description: String {
        return "\n[GLTF]\nasset => \n\(asset)\nscene => \n\(scene)\nscenes => \n\(scenes)\nnodes =>\n\(nodes)\nmeshes =>\n\(meshes)\naccessors => \(accessors)\nbufferView =>\n\(bufferView)\nbuffer =>\n\(buffer)\nmaterials => \n\(materials)\ntextures => \n\(textures)\nimages => \(images)\nsamplers => \(samplers)\n"
    }
    
}
