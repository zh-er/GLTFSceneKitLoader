//
//  ViewController.swift
//  GLTFSceneKitLoader
//
//  Created by zh-er on 01/07/2018.
//  Copyright (c) 2018 zh-er. All rights reserved.
//

import UIKit
import GLTFSceneKitLoader
import SceneKit

class ViewController: UIViewController {

    
    let scene = SCNScene()
    let sceneView = SCNView()
    let loader = GLTFLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        setupScene()
        
        
        loader.load(baseURL: "https://raw.githubusercontent.com/mrdoob/three.js/master/examples/models/gltf/MetalRoughSpheres/glTF/", filename: "MetalRoughSpheres.gltf"){ node in
            print("new node => \(node)")
            if let node = node {
                self.scene.rootNode.addChildNode(node)
            }
            
        }
        
    }
    
    func setupScene() {
        sceneView.backgroundColor = .black
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.scene = scene
        view.addSubview(sceneView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneView.frame = view.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addAmbientLight() {
        let ambient = SCNLight()
        ambient.type = .ambient
        ambient.color = UIColor.white.cgColor
        ambient.intensity = 800
        let ambientNode = SCNNode()
        ambientNode.light = ambient
        scene.rootNode.addChildNode(ambientNode)
        
    }
    
    func addDirectionalLight() {
        let directionalLight = SCNLight()
        directionalLight.type = .directional
        directionalLight.intensity = 1000
        let dlNode = SCNNode()
        dlNode.light = directionalLight
        dlNode.position = SCNVector3(10,10,2)
        dlNode.eulerAngles.x = -45
        scene.rootNode.addChildNode(dlNode)
        
    }
    
    func addTorus() {
        let torus = SCNTorus(ringRadius: 1, pipeRadius: 0.35)
        let torusNode = SCNNode(geometry: torus)
        torus.firstMaterial?.diffuse.contents = UIColor.blue
        torus.firstMaterial?.specular.contents = UIColor.green
        scene.rootNode.addChildNode(torusNode)
    }

}

