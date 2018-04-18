//
//  ViewController.swift
//  AR Drawing
//
//  Created by Yash Pahade on 2018-17-04.
//  Copyright © 2018 Yash Pahade. All rights reserved.
//

import UIKit
import ARKit
class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var draw: UIButton!
    @IBOutlet weak var SceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.SceneView.showsStatistics = true
        self.SceneView.session.run(configuration)
        self.SceneView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        //print("rendering")
        guard let pointOfView = self.SceneView.pointOfView else {return}
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31,-transform.m32,-transform.m33)
        let location = SCNVector3(transform.m41,transform.m42,transform.m43)
        let position = orientation + location
        //print(orientation.x, orientation.y, orientation.z)
        DispatchQueue.main.async {
            if self.draw.isHighlighted{
                //print("Draw button is highlighted")
                let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.02))
                sphereNode.position = position
                self.SceneView.scene.rootNode.addChildNode(sphereNode)
                sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
            } else {
                let pointer = SCNNode(geometry: SCNSphere(radius: 0.02))
                pointer.name = "pointer"
                pointer.position = position
                self.SceneView.scene.rootNode.enumerateHierarchy({ (node, _) in
                    if node.name == "pointer"{
                        node.removeFromParentNode()
                    }
                })
                self.SceneView.scene.rootNode.addChildNode(pointer)
                pointer.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                
            }
        }

    }


}

func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}


