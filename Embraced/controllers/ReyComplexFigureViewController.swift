//
//  ReyComplexFigureViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 9/2/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import WebKit

class ReyComplexFigureViewController: WebViewController {
    
    override func viewDidLoad() {
        step = AppDelegate.position
        showOrientationAlert(orientation: "portrait")
        url = URL(string: "http://www.embraced.ugr.es/reyComplexFigure.php?id=" + participant.string(forKey: "pid")! + "&lang=" + participant.string(forKey: "language")! + "&token=" + participant.string(forKey: "token")!)
        
        super.viewDidLoad()    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    func next(_ sender:Any) {
//        let vc:ClockDrawingTestViewController = ClockDrawingTestViewController()
//        nextViewController(viewController: vc)
        AppDelegate.position += 1
        nextViewController2(position: AppDelegate.position)
    }

    // MARK: - Delegate
    override func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if (message.name == "callbackHandler") {
            next(self)
        }
        
    }
}
