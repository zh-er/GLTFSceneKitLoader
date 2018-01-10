//
//  XHRLoader.swift
//  Nimble
//
//  Created by Zheng Hui Er on 14/10/17.
//

import Foundation

protocol GLTFNetworkLoader {
    func loadURL(_ url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?) -> Void)
}

public class XHRLoader: NSObject, GLTFNetworkLoader {    
    
    public static let instance = XHRLoader()
    
    func loadURL(_ url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?) -> Void){
        
        print("[XHRLoader] - load: url => \(url)")
        
        URLSession.shared.dataTask(with: url) { [weak self]
            (data, response, error) in
            
            if error != nil {
                completion(nil, response)
            }
            
            DispatchQueue.main.async {
                print("[getDataFromUrl] => \(url) data retrieved !")
                completion(data, response)
            }
            
            }.resume()
        
    }
    
}


