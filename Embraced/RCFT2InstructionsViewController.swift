//
//  RCFT2InstructionsViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 8/3/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class RCFT2InstructionsViewController: InstructionsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        orientation = .landscapeLeft
        rotateOrientation = .landscapeLeft
                
        instructionsLabel.text = "rcft_2_instructions".localized(lang: language)
        
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
    }
    
    @objc func moveOn() {
//        self.performSegue(withIdentifier: "moveToTask", sender: nil)
        let vc = RCFT2TaskViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
