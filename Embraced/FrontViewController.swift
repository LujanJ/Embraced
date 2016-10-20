//
//  FrontViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 6/29/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class FrontViewController: UIViewController {

    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var nextBtn: UIBarButtonItem!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    var alertController = UIAlertController()
    
    var orientation = "portrait"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Embraced_bg.png")!)
        
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOpacity = 0.7
        mainView.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        mainView.layer.shadowRadius = 10
//        mainView.layer.shadowPath = UIBezierPath(rect: mainView.bounds).CGPath
        mainView.layer.shouldRasterize = true
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(FrontViewController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func rotated() {
        if orientation == "landscape" {
            if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation)) {
                alertController.dismiss(animated: true, completion: nil)
            }
        
            if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation)) {
                alertController = UIAlertController(title: "Rotate", message: "Please rotate iPad to landscaping orientation", preferredStyle: UIAlertControllerStyle.alert)
                self.present(alertController, animated: true, completion: nil)
            }
        } else if orientation == "portrait" {
            if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation)) {
                alertController = UIAlertController(title: "Rotate", message: "Please rotate iPad to portrait orientation", preferredStyle: UIAlertControllerStyle.alert)
                self.present(alertController, animated: true, completion: nil)
            }
            
            if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation)) {
                alertController.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
