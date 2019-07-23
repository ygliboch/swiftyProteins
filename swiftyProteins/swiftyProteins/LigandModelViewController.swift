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

    @IBOutlet weak var atomsCount: UILabel!
    @IBOutlet weak var formula: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var proteinName: UILabel!
    @IBOutlet weak var sceneKitView: SCNView!
    var file: String = ""
    var name: String = ""
    var info: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = name
        sceneKitView.scene = MyScene(file: self.file)

        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(0, 0, 35)
        sceneKitView.scene?.rootNode.addChildNode(cameraNode)
        
        sceneKitView.allowsCameraControl = true
        sceneKitView.autoenablesDefaultLighting = true
        getInfo()
    }
    
    func getInfo () {
        let splitInfo = info.split(separator: "\n")
        for subInfo in splitInfo {
            if subInfo.contains("name") {
                let getName = subInfo.split(separator: " ")
                proteinName.text = "\(getName[1])"
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchLocation = touches.first?.location(in: sceneKitView)
        let hit = sceneKitView.hitTest(touchLocation!, options: nil)
        if hit.isEmpty == false {
            let node = hit[0].node
            if (node.name != nil) {
                showToast(message: "Atom \(node.name!)")
            }
        }
    }
    
    func showToast(message : String)
    {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-150, width: 150, height: 35))
        
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations:
            {
                toastLabel.alpha = 0.0
        }, completion:
            {
                (isCompleted) in
                toastLabel.removeFromSuperview()
        })
    }
    
    @IBAction func shareButton(_ sender: Any) {
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, true, 0.0)
        self.view.drawHierarchy(in: self.view.frame, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let img = image {
            let shareObject = [img] as [UIImage]
            let vc = UIActivityViewController(activityItems: shareObject, applicationActivities: nil)
            vc.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
//    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, true, 0.0)
//    self.view.drawHierarchy(in: self.view.frame, afterScreenUpdates: false)
//    let img = UIGraphicsGetImageFromCurrentImageContext()
//    UIGraphicsEndImageContext()
//
//    if let img = img {
//        let objectsToShare = [img] as [UIImage]
//        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//        activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
//        self.present(activityVC, animated: true, completion: nil)
//    }
}
