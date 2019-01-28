//
//  CanvasViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 12/24/18.
//  Copyright © 2018 Domonique Dixon. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {

    @IBOutlet weak private var stepsLabel: UILabel!
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var nextBtn: UIButton!
    
    private var task = [String]()
    
    func initWithTask(task: [String]) {
        print(task)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
