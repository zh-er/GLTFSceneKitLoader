//
//  Sampler.swift
//  Pods
//
//  Created by zh-er on 24/8/17.
//  Copyright © 2017 zh-er. All rights reserved.
//

import Foundation
import Mapper
import SceneKit


struct Sampler: Mappable {
    
    let magFilter: SamplingFilter
    let minFilter: SamplingFilter
    let wrapS: SamplerWrapping
    let wrapT: SamplerWrapping
    
    init(map: Mapper) throws {
        magFilter = map.optionalFrom("magFilter") ?? .LINEAR
        minFilter = map.optionalFrom("minFilter") ?? .NEAREST
        wrapS = map.optionalFrom("wrapS") ?? .REPEAT
        wrapT = map.optionalFrom("wrapT") ?? .REPEAT
    }
    
    
    
}

