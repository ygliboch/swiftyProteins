//
//  LigandModelViewController.swift
//  swiftyProteins
//
//  Created by Yaroslava HLIBOCHKO on 7/19/19.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import UIKit
import SceneKit

class LigandModelViewController: UIViewController {

    @IBOutlet weak var sceneKitView: SCNView!
    var file: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneKitView.scene = MyScene(file: self.file)
        
        //изначальное положение камеры, на сколько от нашего объекта
        print(file)
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(0, 0, 35)
        sceneKitView.scene?.rootNode.addChildNode(cameraNode)
        sceneKitView.allowsCameraControl = true
        sceneKitView.autoenablesDefaultLighting = true      
    }
}
