//
//  GLTFParser.swift
//  Pods
//
//  Created by Zheng Hui Er on 7/10/17.
//

import Foundation
import SceneKit
import Mapper



class GLTFParser: NSObject {
    
    typealias callback = ((SCNNode) -> Void)?
    
    // MARK: -
    
    let tag = "[GLTFParser]"
    
    var gltf: GLTF!
    var buffers: [Int: Data] = [:]
    var xhrLoader: GLTFNetworkLoader!
    var baseURL: String = ""
    
}



extension GLTFParser {
    
    func parseScene(_ completion: @escaping (SCNNode?) -> Void)  {
        
        print("\(tag) - parseScene ")
        guard gltf.scenes.count > gltf.scene else { return }
        
        let group = DispatchGroup()
        
        gltf.buffer.enumerated().forEach { [weak self] index, buffer in
            print("DispatchQueue.main.asyc")
            group.enter()
            DispatchQueue.main.async {
                print("loadBuffer")
                self?.loadBuffer(uri: buffer.uri as NSString) {data in
                    print("buffer loaded!")
                    self?.buffers[index] = data
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            print("buffer all loaded")
//            print("construct scene")
            print(self.gltf.scenes)
            let scene = self.gltf.scenes[self.gltf.scene]
            let sceneNode = self.constructScene(scene)
            completion(sceneNode)
        }
        
    }
    
    fileprivate func constructScene(_ scene: Scene) -> SCNNode {
        
        print("construct scene")
        
        let _scene = SCNNode()
        print(scene.nodes)
        
        scene.nodes.forEach {
            let node = constructNode(gltf.nodes[$0])
            _scene.addChildNode(node)
            print("scene child node: \(node)")
        }
        
        return _scene
    }
    
    fileprivate func constructNode(_ node: Node) -> SCNNode {
        
        var _node: SCNNode!
        
        if let meshIndex = node.mesh {
            // load mesh
            let mesh = gltf.meshes[meshIndex]
            let geometry = constructMesh(mesh)
            print("node geometry: \(geometry)")
            _node = SCNNode(geometry: geometry)
            
        } else {
            _node = SCNNode()
        }
        
        _node.transform = node.matrix
        
        if let translation = node.translation {
            _node.position = translation
        }
        
        
        if let children = node.children {
            // construct node
            for child in children {
                let childNode = constructNode(gltf.nodes[child])
                _node.addChildNode(childNode)
            }
        }
        
        
        return _node
        
    }
    
    
    
    fileprivate func constructMesh(_ mesh: Mesh) -> SCNGeometry {
        
        var sources: [SCNGeometrySource] = []
        var elements: [SCNGeometryElement] = []
        var materials: [SCNMaterial] = []
        
        for primitive in mesh.primitives {
            
            
            if let materialIndex = primitive.material {
                let material = constructMaterial(materialIndex)
                materials.append(material)
            }
            
            
            if let attribute = primitive.attribute {
                
                if let position = attribute.position {
                    if let source = accessorGetGeometrySource(position, semantic: .vertex) {
                        sources.append(source)
                    }
                }
                
                if let normal = attribute.normal {
                    if let source = accessorGetGeometrySource(normal, semantic: .normal) {
                        sources.append(source)
                    }
                }
                
                if let tangent = attribute.tangent {
                    if let source = accessorGetGeometrySource(tangent, semantic: .tangent) {
                        sources.append(source)
                    }
                }
                
                if let texCoord_0 = attribute.texCoord_0 {
                    if let source = accessorGetGeometrySource(texCoord_0, semantic: .texcoord) {
                        sources.append(source)
                    }
                    
                }
                
                if let texCoord_1 = attribute.texCoord_1 {
                    if let source = accessorGetGeometrySource(texCoord_1, semantic: .texcoord) {
                        sources.append(source)
                    }
                    
                }
                
            }
            
            
            let indices = primitive.indices
            if let element = accessorGetGeometryElement(indices, mode: primitive.mode?.scnPrimitive ?? .triangles) {
                elements.append(element)
            }
            
        }
        
        
        let geometry = SCNGeometry(sources: sources, elements: elements)
        
        if materials.count > 0 {
            geometry.materials = materials
        }
        
        return geometry
    }
    
    
    fileprivate func mapTextureAttribute(_ property: SCNMaterialProperty, textureSource: MaterialTexture, channel: CIColor? = nil) {
        let textureIndex = textureSource.index
        let texture = gltf.textures[textureIndex]
        
        //
        
        let imageIndex = texture.source
        
        if imageIndex < gltf.images.count {
            let imageUri = gltf.images[imageIndex]
            
            if baseURL.count > 0 {
                if let url = URL(string: baseURL)?.appendingPathComponent(imageUri.uri) {
                    xhrLoader.loadURL(url) { data, urlResponse in
                        if let data = data {
                            if let image = UIImage(data: data)?.cgImage {
                                if let channel = channel {
                                    property.contents = self.filterImage(image, channel: channel)
                                } else {
                                    property.contents = image
                                }
                            }
                        }
                    }
                }
            } else {
                if let image = UIImage(named: imageUri.uri)?.cgImage {
                    if let channel = channel {
                        property.contents = filterImage(image, channel: channel)
                    } else {
                        property.contents = image
                    }
                }
            }
        }
        
        
        // default
        property.wrapS = .repeat
        property.wrapT = .repeat
        property.minificationFilter = .nearest
        property.magnificationFilter = .linear
        
        //
        
        if let samplerIndex = texture.sampler, samplerIndex < gltf.samplers.count {
            let sampler = gltf.samplers[samplerIndex]
            property.wrapS = sampler.wrapS.SCNWrapMode
            property.wrapT = sampler.wrapT.SCNWrapMode
            property.minificationFilter = sampler.minFilter.scnfilter
            property.magnificationFilter = sampler.magFilter.scnfilter
        }
        
    }
    
    fileprivate func constructMaterial(_ index: Int) -> SCNMaterial {
        
        let material = gltf.materials[index]
        let _material = SCNMaterial()
        _material.lightingModel = .physicallyBased
        
        
        if let emissiveTexture = material.emissiveTexture {
            mapTextureAttribute(_material.emission, textureSource: emissiveTexture)
        }
        
        
        
        if let occlusionTexture = material.occlusionTexture {
            mapTextureAttribute(_material.ambientOcclusion, textureSource: occlusionTexture)
        }
        
        
        if let normalTexture = material.normalTexture {
            mapTextureAttribute(_material.normal, textureSource: normalTexture)
        }
        
        
        if let pbrMetallicRoughness = material.pbrMetallicRoughness {
            
            if let metallicRoughnessTexture = pbrMetallicRoughness.metallicRoughnessTexture {
                mapTextureAttribute(_material.metalness, textureSource: metallicRoughnessTexture, channel: CIColor(red: 0, green: 0, blue: 1))
                mapTextureAttribute(_material.roughness, textureSource: metallicRoughnessTexture, channel: CIColor(red: 0, green: 1, blue: 0))
            }
            
            if let baseColorTexture = pbrMetallicRoughness.baseColorTexture {
                mapTextureAttribute(_material.diffuse, textureSource: baseColorTexture)
            }
            
        }
        
        print("\n[constructMaterial]")
        print("> _material => \(_material)")
        print("> metalness: \(_material.metalness)")
        print("> roughness: \(_material.roughness)")
        print("> aoness: \(_material.ambientOcclusion)")
        
        return _material
    }
    
    fileprivate func accessorGetGeometrySource(_ index: Int, semantic: SCNGeometrySource.Semantic) -> SCNGeometrySource? {
        
        let accessor = gltf.accessors[index]
        let bufferViewIndex = accessor.bufferView
        let bufferView = gltf.bufferView[bufferViewIndex]
        
        guard let buffer = buffers[bufferView.buffer] else { return nil }
        
        
        print("\n[accessorGetGeometrySource]")
        print("> byteOffset => \(accessor.byteOffset)")
        print("> type => \(accessor.type)")
        print("> count => \(accessor.count)")
        print("> componentType => \(accessor.componentType)")
        print("> bufferOffset => \(bufferView.byteOffset)")
        print("> bufferLength => \(bufferView.byteLength)")
        print("> bufferStride => \(bufferView.byteStride)")
        let startIndex = accessor.byteOffset + bufferView.byteOffset
        let endIndex = bufferView.byteOffset + bufferView.byteLength
        let sourceBuffer = buffer.subdata(in: startIndex..<endIndex)
        
        return SCNGeometrySource(
            data: sourceBuffer,
            semantic: semantic,
            vectorCount: accessor.count,
            usesFloatComponents: true,
            componentsPerVector: accessor.type.componentsPerVector,
            bytesPerComponent: accessor.componentType.bytesPerComponent,
            dataOffset: 0,
            dataStride: bufferView.byteStride
        )
    }
    
    fileprivate func accessorGetGeometryElement(_ index: Int, mode: SCNGeometryPrimitiveType) -> SCNGeometryElement? {
        let accessor = gltf.accessors[index]
        
        
        let bufferViewIndex = accessor.bufferView
        let bufferView = gltf.bufferView[bufferViewIndex]
        
        guard let buffer = buffers[bufferView.buffer] else { return nil }
        let startIndex = accessor.byteOffset + bufferView.byteOffset
        let endIndex = bufferView.byteOffset + bufferView.byteLength
        
        
        let elementBuffer = buffer.subdata(in: startIndex..<endIndex)
        
        
        var primitiveCount = accessor.count
        switch mode {
        case .point:
            break;
        case .line:
            primitiveCount /= 2
            break;
        case .triangles,
             .triangleStrip:
            primitiveCount /= 3
            break;
        default:
            primitiveCount /= 3
            break;
        }
        
        
        print("\n[accessorGetGeometryElement]")
        print("> mode => \(mode.rawValue)")
        print("> startIndex => \(startIndex)\tendIndex => \(endIndex)")
        print("> buffer => \(buffer)")
        print("> elementBuffer => \(elementBuffer)")
        
        
        
        return SCNGeometryElement(
            data: elementBuffer,
            primitiveType: mode,
            primitiveCount: primitiveCount,
            bytesPerIndex: accessor.componentType.bytesPerComponent
        )
        
    }
    
    
    
    fileprivate func loadBuffer(uri: NSString, completion: @escaping (Data?) -> Void) {
        print("loadBuffer => uri: \(uri)")
        if baseURL.count == 0 {
            self.loadBufferFromFile(uri: uri, completion: completion)
        } else {
            self.loadBufferFromURL(uri: uri, completion: completion)
        }
        
    }
    
    private func loadBufferFromURL(uri: NSString, completion: @escaping (Data?) -> Void) {
        print("loadBufferFromURL => uri: \(uri)")
        if let url = URL(string: uri as String, relativeTo: URL(string: baseURL)) {
            xhrLoader?.loadURL(url) { data, response in
                completion(data)
            }
        }
//        completion(nil)
    }
    
    private func loadBufferFromFile(uri: NSString, completion: @escaping (Data?) -> Void){
        let file = uri.deletingPathExtension
        
        if let path = Bundle.main.path(forResource: file, ofType: "bin") {
            do {
                let data = try NSData(contentsOfFile: path, options: .mappedIfSafe) as Data
                print("[loadBuffer]\n > data: \(data)")
                completion(data)
            } catch {
                print("[loadBuffer] error loading buffer")
            }
        }
        completion(nil)
    }
    
    
    
    fileprivate func createKernel(_ channel: CIColor) -> CIColorKernel {
        var channelString = "0"
        
        channelString = channel.green == 1 ? "s.g" : channel.blue == 1 ? "s.b" : channel.red == 1 ? "s.r" : "0"
        print("channelString: \(channelString)")
        
        let kernelString =
            "kernel vec4 chromaKey( __sample s ) { \n" +
                "  float alpha = compare( \(channelString) - 0.001, 0.0, \(channelString)); \n" +
                //            "  return vec4( s.rgb, alpha ); \n" +
                "  return vec4(alpha,alpha,alpha,s.a); \n" +
        "}"
        return CIColorKernel(source: kernelString)!
    }
    
    fileprivate func filterImage(_ image: CGImage, channel:CIColor) -> CGImage {
        let ciImage = CIImage(cgImage: image)
        let kernel = createKernel(channel)
        let dod = ciImage.extent
        let args = [ciImage as AnyObject]
        let output = kernel.apply(extent: dod, arguments: args)
        let context = CIContext()
        let cgImage = context.createCGImage(output!, from: output!.extent)
        return cgImage!
    }
    
    
}

