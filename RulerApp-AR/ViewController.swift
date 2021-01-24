//
//  ViewController.swift
//  RulerApp-AR
//
//  Created by Egor Lass on 23.01.2021.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusLabel.text = "Wait"
        // Set the view's delegate
        sceneView.delegate = self
        
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let location = touches.first?.location(in: sceneView) {
            guard let query = sceneView.raycastQuery(from: location, allowing: .existingPlaneInfinite, alignment: .any) else {
                return
            }
            
            let results = sceneView.session.raycast(query)
            guard let hitTestResult = results.first else {
                
                let alert = UIAlertController(title: "Surface not found yet", message: "Please wait for surface detection", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)

                return
            }
            
            addDot(at: hitTestResult)
            print("surface has been found")
        }
    }

    
    func addDot(at hitResult : ARRaycastResult) {
        
        let dotGeometry = SCNSphere(radius: 0.008)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        
        dotGeometry.materials = [material]
        
        let dotNode = SCNNode(geometry: dotGeometry)
        
        dotNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(dotNode)
        
    }
    

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            
            DispatchQueue.main.async {
                
                self.statusLabel.text = "OK"
                
            }
//            let planeAnchor = anchor as! ARPlaneAnchor
//
//            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
//
//            let planeNode = SCNNode()
//
//            planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
//
//            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
//
//            let gridMaterial = SCNMaterial()
//
//            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
//
//            plane.materials = [gridMaterial]
//
//            planeNode.geometry = plane
//
//            node.addChildNode(planeNode)
            
        } else {
            return
        }
    }

    
}


