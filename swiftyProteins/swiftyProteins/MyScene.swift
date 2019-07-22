//
//  MyScene.swift
//  swiftyProteins
//
//  Created by Yaroslava HLIBOCHKO on 7/22/19.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import Foundation
import SceneKit

class MyScene: SCNScene, SCNSceneRendererDelegate {
    var atomsArray : [SCNNode] = []
    
    init(file: String) {
        super.init()
        let splitFile = file.split(separator: "\n")
        for split in splitFile {
            let spaceString = split.split(separator: " ")
            if spaceString[0] == "ATOM" {
                let newSphereGeometry = SCNSphere(radius: 0.4)
                newSphereGeometry.firstMaterial!.diffuse.contents = UIColor.purple
                newSphereGeometry.firstMaterial!.diffuse.contents = ColorsForAtoms.colors["\(spaceString[11])"]
                let newSphereNode = SCNNode(geometry: newSphereGeometry)
                newSphereNode.position = SCNVector3Make((spaceString[6] as NSString).floatValue, (spaceString[7] as NSString).floatValue, (spaceString[8] as NSString).floatValue)
                atomsArray.append(newSphereNode)
                newSphereNode.name = "\(spaceString[11])"
                self.rootNode.addChildNode(newSphereNode)
            } else if spaceString[0] == "CONECT" {
                var i = 2
                let lastIndex = spaceString.count - 1
                for _ in spaceString {
                    if i <= lastIndex  && (spaceString[1] as NSString).integerValue - 1 < (spaceString[i] as NSString).integerValue - 1 {
                        let node = CylinderLine(v1: atomsArray[(spaceString[1] as NSString).integerValue - 1].position, v2: atomsArray[(spaceString[i] as NSString).integerValue - 1].position)
                        self.rootNode.addChildNode(node)
                    }
                    i += 1
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class   CylinderLine: SCNNode
{
    init (v1: SCNVector3, v2: SCNVector3) {
        super.init()
        let parentNode = SCNNode()
        var height = vectorLength(pos1: v1, pos2: v2)
        if (height < 0){
            height *= -1
        }
        
        self.position = v1
        let nodeV2 = SCNNode()
        nodeV2.position = v2
        parentNode.addChildNode(nodeV2)
        
        let layDown = SCNNode()
        layDown.eulerAngles.x = Float(Double.pi / 2)
        
        let cylinder = SCNCylinder(radius: 0.1, height: CGFloat(height))
        cylinder.firstMaterial?.diffuse.contents = UIColor.white
        
        let cylinderNode = SCNNode(geometry: cylinder)
        cylinderNode.position.y = -height / 2
        layDown.addChildNode(cylinderNode)
        
        self.addChildNode(layDown)
        self.constraints = [SCNLookAtConstraint(target: nodeV2)]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func vectorLength(pos1: SCNVector3, pos2: SCNVector3) -> Float{
        return sqrt(pow(pos2.x - pos1.x, 2.0) + pow(pos2.y - pos1.y, 2.0) + pow(pos2.z - pos1.z, 2.0))
    }
}

