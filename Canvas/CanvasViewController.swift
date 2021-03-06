//
//  CanvasViewController.swift
//  Canvas
//
//  Created by Joe Antongiovanni on 3/18/18.
//  Copyright © 2018 Joe Antongiovanni. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {
    @IBOutlet weak var trayView: UIView!
    var trayOriginalCenter: CGPoint!
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanTary(_:)))
        trayView.addGestureRecognizer(panGestureRecognizer)
        
        trayDownOffset = 160
        trayUp = trayView.center
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPanTary(_ sender: UIPanGestureRecognizer) {
        let velocity = sender.velocity(in: view)
        let translation = sender.translation(in: view)
        UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                       animations: { () -> Void in
                        self.trayView.center = self.trayDown
            }, completion: nil)
        
        if sender.state == .began {
            print("Gesture began")
            trayOriginalCenter = trayView.center
        } else if sender.state == .changed {
            print("Gesture is changing")
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)

        } else if sender.state == .ended {
            print("Gesture ended")
            if velocity.y > 0 {
                UIView.animate(withDuration: 0.3) {
                    self.trayView.center = self.trayDown
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.trayView.center = self.trayUp                 
                }
            }
        }
    }
    
    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)

        if sender.state == .began {
            let imageView = sender.view as! UIImageView
            newlyCreatedFace = UIImageView(image: imageView.image)
            view.addSubview(newlyCreatedFace)
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            newlyCreatedFace.isUserInteractionEnabled = true
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(newPanFace(sender:)))
            newlyCreatedFace.addGestureRecognizer(panGestureRecognizer)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapTwice(sender:)))
            tapGestureRecognizer.numberOfTapsRequired = 2
            newlyCreatedFace.addGestureRecognizer(tapGestureRecognizer)
            
        } else if sender.state == .changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)

        } else if sender.state == .ended {
        }
    }
    
    func tapTwice(sender: UITapGestureRecognizer){
    newlyCreatedFace = sender.view as! UIImageView
    newlyCreatedFace.removeFromSuperview()
    }
    
    func newPanFace(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            print("Gesture began")
            newlyCreatedFace = sender.view as! UIImageView // to get the face that we panned on.
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center // so we can offset by translation later.
            UIView.animate(withDuration:0.1, animations: {
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                },completion: nil)
        } else if sender.state == .changed {
            print("Gesture is changing")
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            print("Gesture ended")
            UIView.animate(withDuration:0.1, animations: {
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                },completion: nil)
        }
    }
    

    
}
