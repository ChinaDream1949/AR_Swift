//
//  ViewController.swift
//  AR_Swift
//
//  Created by MR.Sahw on 2020/11/12.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.debugOptions = .showFeaturePoints
//        sceneView.debugOptions = [.showFeaturePoints,.showCameras]
        
//        let sphere = SCNSphere(radius: 0.2)
//        sphere.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/8k_earth_nightmap.jpg")
//        let note = SCNNode(geometry: sphere)
//        note.position = SCNVector3(0, 0, -0.5)
//        sceneView.scene.rootNode.addChildNode(note)
        
        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/airways.scn")!
    
        // Set the scene to the view
//        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        configuration.planeDetection = .horizontal // 水平检测
//        configuration.planeDetection = [.horizontal,.vertical]  // 水平 + 垂直 检测
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let planeAcnchor = anchor as? ARPlaneAnchor {
            let plane = SCNPlane(width: CGFloat(planeAcnchor.extent.x), height: CGFloat(planeAcnchor.extent.z))
            guard let material = plane.firstMaterial else {
                return
            }
            material.diffuse.contents = UIColor.init(white: 1, alpha: 0.5)
            
            let planeNote = SCNNode(geometry: plane)
            planeNote.simdPosition = planeAcnchor.center
            planeNote.eulerAngles.x = -.pi/2
            node.addChildNode(planeNote)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 点击坐标
        guard let location = touches.first?.location(in: sceneView) else {return}
        //二维坐标转化为三维坐标
        guard let results = sceneView.hitTest(location, types: .existingPlaneUsingExtent).first else {return}
        let position = results.worldTransform.columns.3
        
        guard let scene = SCNScene(named: "art.scnassets/airways.scn") else {return}
        
        guard let teapotNote = scene.rootNode.childNode(withName: "Group73", recursively: true) else {return}
        
        teapotNote.position = SCNVector3(position.x, position.y, position.z)
        
        // 找到 sceneView根节点 覆盖
        sceneView.scene.rootNode.addChildNode(teapotNote)
    }
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
