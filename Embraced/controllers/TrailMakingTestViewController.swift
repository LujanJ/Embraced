//
//  TrailMakingTestViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 9/2/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class TrailMakingTestViewController: FrontViewController {

    @IBOutlet weak var myWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(TrailMakingTestViewController.next(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(TrailMakingTestViewController.back(_:)))
        
        let url = URL (string: "http://girlscouts.harryatwal.com/trailMaking.php");
        let requestObj = URLRequest(url: url!);
        myWebView.loadRequest(requestObj);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func rotated() {
        if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation)) {
            let alertController = UIAlertController(title: "Rotate", message: "Please rotate iPad to portrait orientation", preferredStyle: UIAlertControllerStyle.alert)
            self.present(alertController, animated: true, completion: nil)
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation)) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Navigation
    
    @IBAction func next(_ sender: AnyObject) {
//        var navigationArray = self.navigationController?.viewControllers
//        
//        navigationArray?.remove(at: 0)
        
        let stroopViewController:StroopViewController = StroopViewController()
//        navigationArray?.append(stroopViewController)
//        
//        self.navigationController?.setViewControllers(navigationArray!, animated: true)
        self.navigationController?.pushViewController(stroopViewController, animated: true)
    }

    @IBAction func back(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}