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
    var conectsArray : [SCNNode] = []
    
    init(file: String) {
        super.init()
        let splitFile = file.split(separator: "\n")
        
        for split in splitFile {
            let spaceString = split.split(separator: " ")
            if spaceString[0] == "ATOM" {
                newAtom(atomString: spaceString)
            } else if spaceString[0] == "CONECT" {
                newConect(connectString: spaceString)
            }
        }
    }
    
    func newConect(connectString: [Substring.SubSequence]) {
        let firstIndex = (connectString[1] as NSString).integerValue - 1
        if firstIndex < 0 || firstIndex >= atomsArray.count { return }
        let firstNode = atomsArray[firstIndex]
        
        var i = 2
        
        while i < connectString.count  {
            let secondIndex = (connectString[i] as NSString).integerValue - 1
            if secondIndex < 0 || secondIndex >= atomsArray.count { break }
            let secondNode = atomsArray[(connectString[i] as NSString).integerValue - 1]
            
            if firstIndex < secondIndex {
                let newConectNode = CylinderLine(v1: firstNode.position, v2: secondNode.position)
                if firstNode.name == "H" || secondNode.name == "H" {
                    newConectNode.name = "conect with hydrogen"
                }
                conectsArray.append(newConectNode)
                self.rootNode.addChildNode(newConectNode)
            }
            i += 1
        }
    }
    
    func newAtom(atomString: [Substring.SubSequence]) {
        let newSphereGeometry = SCNSphere(radius: 0.4)
        newSphereGeometry.firstMaterial!.diffuse.contents = UIColor.purple
        newSphereGeometry.firstMaterial!.diffuse.contents = ColorsForAtoms.colors["\(atomString[11])"]
        
        let newSphereNode = SCNNode(geometry: newSphereGeometry)
        newSphereNode.position = SCNVector3Make((atomString[6] as NSString).floatValue, (atomString[7] as NSString).floatValue, (atomString[8] as NSString).floatValue)
        newSphereNode.name = "\(atomString[11])"
        
        atomsArray.append(newSphereNode)
        self.rootNode.addChildNode(newSphereNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class   CylinderLine: SCNNode {
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

