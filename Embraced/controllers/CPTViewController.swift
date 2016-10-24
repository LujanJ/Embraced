//
//  CPTViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 9/2/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class CPTViewController: FrontViewController {

    @IBOutlet weak var myWebView: UIWebView!
    
    var alertController = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rotated()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(CPTViewController.next(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(CPTViewController.back(_:)))
        
        let url = URL (string: "http://girlscouts.harryatwal.com/cpt.php");
        let requestObj = URLRequest(url: url!);
        myWebView.loadRequest(requestObj);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func rotated() {
        if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation)) {
            alertController.dismiss(animated: true, completion: nil)
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation)) {
            alertController = UIAlertController(title: "Rotate", message: "Please rotate iPad to landscaping orientation", preferredStyle: UIAlertControllerStyle.alert)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Navigation
    
    @IBAction func next(_ sender: AnyObject) {
//        var navigationArray = self.navigationController?.viewControllers
//
//        navigationArray?.remove(at: 0)
        
        let eyeTestViewController:EyeTestViewController = EyeTestViewController()
//        navigationArray?.append(eyeTestViewController)
//        
//        self.navigationController?.setViewControllers(navigationArray!, animated: true)
        self.navigationController?.pushViewController(eyeTestViewController, animated: true)
    }

    @IBAction func back(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
