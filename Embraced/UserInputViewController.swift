//
//  UserInputViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 6/8/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import Stormpath
import CoreData

class UserInputViewController: UIViewController {

    @IBOutlet weak var participantID: UILabel!
    @IBOutlet weak var dayOfTheWeekTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var countyTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var floorTextField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    let participant = UserDefaults.standard
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    fileprivate func setBottomBorder(_ textfield: UITextField) {
        let border = CALayer()
        let width = CGFloat(2.0)
        let borderColor = UIColor.darkGray.cgColor
        
        border.borderColor = borderColor
        border.borderWidth = width
        border.frame = CGRect(x: 0, y: textfield.frame.size.height, width:  textfield.frame.size.width, height: 1)
        
        textfield.layer.addSublayer(border)
        textfield.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        
        if Reachability.isConnectedToNetwork() == true {
            /* Preloading data  */
            let requestURL: URL = URL(string: "http://api.girlscouts.harryatwal.com/stimuli")!
            let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL)
            let session = URLSession.shared
            let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: {
                (data, response, error) -> Void in
                
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                if (statusCode == 200) {
                    print("Everyone is fine, file downloaded successfully.")
                    
                    do {
                        self.appDelegate.stimuli = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String: Any]
                        self.appDelegate.namingTaskStimuli = self.appDelegate.stimuli["naming_task"] as! [String: Any]
                        self.appDelegate.digitalSpanStimuli = self.appDelegate.stimuli["digital_span"] as! [String: Any]
                        self.appDelegate.pitchStimuli = self.appDelegate.stimuli["pitch"] as! [String: Any]
                        self.appDelegate.stroopStimuli = self.appDelegate.stimuli["stroop"] as! [String: Any]
                        self.appDelegate.wordlistStimuli = self.appDelegate.stimuli["wordlist"] as! [String: Any]
                        //                    self.practice = self.returnStimuli["practice"] as! Array<String>
                        //                    self.task = self.returnStimuli["task"] as! Array<String>
                    }catch {
                        print("Error with Json: \(error)")
                    }
                }
            })
            
            task.resume()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitBtn.backgroundColor = UIColor(red: 23.0/225.0, green: 145.0/255.0, blue: 242.0/255.0, alpha: 1.0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    @IBAction func submit(_ sender: AnyObject) {
        let uuid = UUID().uuidString
        let index = uuid.characters.index(uuid.endIndex, offsetBy: -15)
        
        participant.setValue(uuid.substring(to: index), forKey: "pid")
        participant.setValue(dayOfTheWeekTextField.text, forKey: "dayOfTheWeek")
        participant.setValue(countryTextField.text, forKey: "country")
        participant.setValue(countyTextField.text, forKey: "county")
        participant.setValue(cityTextField.text, forKey: "city")
        participant.setValue(locationTextField.text, forKey: "location")
        participant.setValue(floorTextField.text, forKey: "floor")

        var jsonObject = [String: AnyObject]()
        
        // Gather data for post
        jsonObject = [
            "id": uuid.substring(to: index) as AnyObject
        ]

        
//        print(jsonObject)
        
        // Push to API
        APIWrapper.post(id: "", test: "", data: jsonObject)
//        let notesEndpoint = NSURL(string: Stormpath.sharedSession.configuration.APIURL.absoluteString + "/participant")!
//        let request = NSMutableURLRequest(url: notesEndpoint as URL)
//        
//        request.httpMethod = "POST"
//        request.httpBody = try? JSONSerialization.data(withJSONObject: jsonObject, options: [])
//        request.setValue("application/json" , forHTTPHeaderField: "Content-Type")
//        
//        let task = URLSession.shared.dataTask(with: request as URLRequest)
//        
//        task.resume()

        
        let questionnaireViewController:StartViewController = StartViewController()
        let navController = UINavigationController(rootViewController: questionnaireViewController)
        self.present(navController, animated: true, completion: nil)
        
        
    }
}
