//
//  TrailMakingTask2ViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 8/3/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit
import SVProgressHUD

class TrailMakingTask2ViewController: ActiveStepViewController {

    let TEST_NAME = "TrailMaking"
    var documentPath: URL?
    let fileName = "task2.png"
    var saveImagePath: URL!
    var start: CFAbsoluteTime!
    var reactionTime: Int?
    
    let canvas: CanvasView = {
        var canvasView = CanvasView()
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        canvasView.layer.borderColor = UIColor.black.cgColor
        canvasView.layer.borderWidth = 0.5
        canvasView.isUserInteractionEnabled = true
        return canvasView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        orientation = .portrait
        rotateOrientation = .portrait
        
        instructionsLabel.text = "trailMaking_task_instructions".localized(lang: language)
        
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
        
        setupViews()
        
        canvas.image = Utility.getImage(path: "trailMaking/\(DataManager.sharedInstance.trailMaking[1])")
        
        documentPath = Utility.getDocumentsDirectory().appendingPathComponent("\(FirebaseStorageManager.shared.pid!)/\(TEST_NAME)")
        do
        {
            try FileManager.default.createDirectory(atPath: documentPath!.path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print("Unable to create directory \(error.debugDescription)")
        }
        
        start = CFAbsoluteTimeGetCurrent()
    }
    
    private func setupViews() {
        contentView.addSubview(canvas)
        
        instructionsLabel.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        instructionsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16.0).isActive = true
        
        canvas.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        canvas.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        canvas.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        canvas.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    @objc func moveOn() {
        let elapsed = CFAbsoluteTimeGetCurrent() - start
        let mill = elapsed * 1000
        reactionTime = Int(mill)
        
        if let image = canvas.image {
            if let data = image.pngData() {
                if let path = documentPath {
                    let imageFilename = path.appendingPathComponent(fileName)
                    saveImagePath = imageFilename
                    try? data.write(to: imageFilename)
                    externalStorage()
                }
            }
        }
    }
    
    private func externalStorage() {
        SVProgressHUD.show()
        let filePath = "\(FirebaseStorageManager.shared.pid!)/\(TEST_NAME)/\(fileName)"
        
        if Utility.fileExist(filePath) {
            FirebaseStorageManager.shared.externalStorage(filePath: filePath, fileUrl: saveImagePath) { (uploadTask, error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: error?.localizedDescription)
                }
                
                if let task = uploadTask {
                    task.observe(.success, handler: { (snapshot) in
                        TrailMakingModel.shared.file_2 = filePath
                        TrailMakingModel.shared.time_2 = self.reactionTime
                        
                        FirebaseStorageManager.shared.addDataToDocument(payload: [
                            "trailMaking": TrailMakingModel.shared.getModel()
                        ])
                        
                        Utility.deleteFile(filePath)
                        SVProgressHUD.dismiss()
                        
                        let vc = TrailMakingDoneViewController()
                        self.navigationController?.pushViewController(vc, animated: true)
                    })
                }
            }
        }
    }
}
