//
//  ComprehensionTaskInstructionViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 10/17/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class ComprehensionTaskInstructionViewController: InstructionsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        orientation = .portrait
        rotateOrientation = .portrait
                
        instructionsLabel.text = "comprehension_instructions".localized(lang: language)
        
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
    }
        
    @objc func moveOn() {
//        self.performSegue(withIdentifier: "moveToTask", sender: nil)
        let vc = ComprehensionTaskViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
