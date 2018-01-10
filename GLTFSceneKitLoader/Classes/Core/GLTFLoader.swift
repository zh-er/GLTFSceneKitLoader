//
//  GLTFLoader.swift
//  Pods
//
//  Created by Zheng Hui Er on 7/1/18.
//

import Foundation
import UIKit
import SceneKit


open class GLTFLoader: NSObject {
    
    typealias callback = ((SCNNode) -> Void)?
    
    let tag = "[GLTFLoader]"
    
    
    var verbose = false
    var baseURL: String = ""
    
    var xhrLoader:GLTFNetworkLoader?
    
    convenience init(networkLoader: GLTFNetworkLoader) {
        self.init()
        self.xhrLoader = networkLoader
    }
    
    public override init() {
        super.init()
        self.xhrLoader = XHRLoader()
    }
    
    public func load(baseURL: String, filename: String, complete: @escaping (SCNNode?) -> Void ) {
        self.baseURL = baseURL
        guard let url = URL(string: filename, relativeTo: URL(string: baseURL)) else { return }
        xhrLoader?.loadURL(url, completion: { (data, response) in
            print("\(self.tag) - load => ")
            guard let data = data else { return }
            print("baseURL => \(self.baseURL)")
            self.parse(data: data, completion: complete)
        })
    }
    
    public func load(filename: String, complete: @escaping (SCNNode?) -> Void ) {
        if let data = processFile(filename) {
            parse(data: data, completion: complete)
        }
    }
    
    fileprivate func parse(data: Data, completion: @escaping (SCNNode?) -> Void) {
        print("\(tag) - parse")
        let parser = GLTFParser()
        parser.xhrLoader = xhrLoader
        parser.baseURL = baseURL
        print("data > \(data.debugDescription)")
        if let gltf = serializeData(data) {
            print("here")
            parser.gltf = gltf
            parser.parseScene(completion)
        }
    }
    
    
    
}

extension GLTFLoader {
   
    fileprivate func processFile(_ filename: String) -> Data?{
        let nsFilename = filename as NSString
        let fileExtension = nsFilename.pathExtension
        let file = nsFilename.deletingPathExtension
        
        print(tag, "loadFile \n> filename: \(file)\n> extension: .\(fileExtension)")
        
        if let path = Bundle.main.path(forResource: file, ofType: fileExtension) {
            print(tag, "path:\(path)")
            do {
                let jsonData = try NSData(contentsOfFile: path, options: .mappedIfSafe)
                return jsonData as Data
            } catch {
                print(tag, "Data loading failed: \(error)")
            }
        }
        return nil
    }
    
    fileprivate func serializeData(_ data: Data) -> GLTF? {
//        log("\n", tag, "serializeData")
        print("here")
        do {
            if let jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any> {
                print("and here")
                let gltf = GLTF.from(jsonResult as NSDictionary)
                return gltf
            }
            print("something")
        } catch {
            print("JSONSerialization failed: \(error)")
//            log(tag, "JSONSerialization failed: \(error)")
        }
        return nil
    }
    
    
    /// helper function to print debug message
    fileprivate func log(_ items: Any...) {
        if self.verbose {
            print(items)
        }
    }
}
