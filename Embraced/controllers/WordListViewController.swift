//
//  WordListViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 9/3/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Alamofire
import FirebaseStorage
import CoreData

class WordListViewController: FrontViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet var practiceView: UIView!
    @IBOutlet var trial1View: UIView!
    @IBOutlet var completeView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var trialRecordBtn: UIButton!
    @IBOutlet weak var InstructionsLabel: UILabel!
    @IBOutlet weak var instructions2Label: UILabel!
    @IBOutlet weak var listenBtn: UIButton!
    @IBOutlet weak var practiceLabel: UILabel!
    @IBOutlet weak var practiceInstruction: UILabel!
    @IBOutlet weak var trialLabel: UILabel!
    @IBOutlet weak var completeLabel: UILabel!
    @IBOutlet weak var completeBtn: UIButton!
    @IBOutlet weak var startBtn: NavigationButton!
    @IBOutlet weak var wordNextBtn: NavigationButton!
    
    var recordingSession: AVAudioSession!
    var soundRecorder: AVAudioRecorder!
    var fileName = "testWordlistAudioFile.m4a"
    
    var startTime = TimeInterval()
    var timer = Timer()
    var count = 3
    var trials = Array<String>()
    var sound = String()
    var practice = true
    var position = 1
    var instructions = Array<String>()
    var instructions2 = Array<String>()
    
    let APIUrl = "http://www.embracedapi.ugr.es/"
    let userDefaults = UserDefaults.standard
    var token: String = ""
    var id: String = ""
    var headers: HTTPHeaders = [:]
    var documentPath: URL?
    let context = DatabaseController.persistentContainer.viewContext
    let network: NetworkManager = NetworkManager.sharedInstance
    
    // MARK: - Private
    
    private func setSubview(_ current: UIView, next: UIView) {
        current.removeFromSuperview()
        containerView.addSubview(next)
        
        let leftConstraint = next.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        let topConstraint = next.topAnchor.constraint(equalTo: containerView.topAnchor)
        let rightConstraint = next.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        let bottomConstraint = next.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        NSLayoutConstraint.activate([leftConstraint, topConstraint, rightConstraint, bottomConstraint])
    }
    
    override func viewDidLoad() {
        step = AppDelegate.position
        
        super.viewDidLoad()
        
        language = participant.string(forKey: "language")!
//        showOrientationAlert(orientation: "landscape")
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        // Insert row in database
        id = participant.string(forKey: "pid")!
        token = userDefaults.string(forKey: "token")!
        headers = [
            "x-access-token": token
        ]
        
        Alamofire.request(APIUrl + "api/wordlist/new/" + id, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
        }
        
        practiceView.translatesAutoresizingMaskIntoConstraints = false
        trial1View.translatesAutoresizingMaskIntoConstraints = false
        completeView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(practiceView)
        
        let leftConstraint = practiceView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        let topConstraint = practiceView.topAnchor.constraint(equalTo: containerView.topAnchor)
        let rightConstraint = practiceView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        let bottomConstraint = practiceView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        NSLayoutConstraint.activate([leftConstraint, topConstraint, rightConstraint, bottomConstraint])
        
        recordingSession = AVAudioSession.sharedInstance()
        
//        do {
//            try recordingSession.setCategory(convertFromAVAudioSessionCategory(AVAudioSession.Category.playAndRecord))
//            try recordingSession.setActive(true)
//            recordingSession.requestRecordPermission() { [unowned self] allowed in
//                DispatchQueue.main.async {
//                    if allowed {
//                        self.recordBtn.isEnabled = true
//                    } else {
//                        // failed to record!
//                    }
//                }
//            }
//        } catch {
//            // failed to record!
//        }
        
        // Fetch audios
        self.trials = DataManager.sharedInstance.wordListTasks

        practiceLabel.text = "Practice".localized(lang: language)
        practiceInstruction.text = "wordlist1_practice_instruction".localized(lang: language)
        startBtn.setTitle("Start".localized(lang: language), for: .normal)
        recordBtn.setTitle("Start_Record".localized(lang: language), for: .normal)
        playBtn.setTitle("Play".localized(lang: language), for: .normal)
        trialLabel.text = "Round".localized(lang: language) + " 1"
        listenBtn.setTitle("Listen".localized(lang: language), for: .normal)
        trialRecordBtn.setTitle("Start_Record".localized(lang: language), for: .normal)
        wordNextBtn.setTitle("Done".localized(lang: language), for: .normal)
        instructions = ["wordlist1_instructionA1".localized(lang: language),
                        "wordlist1_instructionA2".localized(lang: language),
                        "wordlist1_instructionA2".localized(lang: language),
                        "wordlist1_instructionA2".localized(lang: language),
                        "wordlist1_instructionA3".localized(lang: language),
                        "wordlist1_instructionA4".localized(lang: language),
                        "wordlist1_instructionA5".localized(lang: language)
        ]
        instructions2 = ["wordlist1_instructionB1".localized(lang: language),
                        "wordlist1_instructionB2".localized(lang: language),
                        "wordlist1_instructionB2".localized(lang: language),
                        "wordlist1_instructionB2".localized(lang: language),
                        "wordlist1_instructionB2".localized(lang: language),
                        "wordlist1_instructionB1".localized(lang: language),
                        ""
        ]
        
        loadingView.stopAnimating()
        
        playBtn.isEnabled = false
        
//        let documentsPath1 = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        documentPath = getDocumentsDirectory().appendingPathComponent("\(FirebaseStorageManager.shared.pid!)/WordList")
        
        do
        {
            try FileManager.default.createDirectory(atPath: documentPath!.path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppUtility.lockOrientation(.landscape)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
        
        deleteAudioFile(fileURL: getDocumentsDirectory().appendingPathComponent("\(FirebaseStorageManager.shared.pid!)/WordList").appendingPathComponent(fileName))
    }
    
    func setup() {
        instructions2Label.isHidden = true
        
        if position <= 6 {
            trialLabel.text = "Round".localized(lang: language) + " " + String(position)
        } else {
            trialLabel.text = "" //"Interference list"
        }
        
        InstructionsLabel.text = instructions[position-1]
        instructions2Label.text = instructions2[position-1]
        trialRecordBtn.isEnabled = false
        listenBtn.isEnabled = true
        
        if position == 7 {
            listenBtn.isHidden = true
            trialRecordBtn.isEnabled = true
        }
    }
    
    
    func startRecording(_ button: UIButton, fileName: String) {
        let audioFilename = documentPath?.appendingPathComponent(fileName)
        print(audioFilename)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            soundRecorder = try AVAudioRecorder(url: audioFilename!, settings: settings)
            soundRecorder.delegate = self
            soundRecorder.record()
            
            button.setTitle("Stop_Recording".localized(lang: language), for: .normal)
        } catch {
            finishRecording(button, success: false)
        }
        
        playBtn.isEnabled = false
    }
    
    
    func finishRecording(_ button: UIButton, success: Bool) {
        if soundRecorder.isRecording {
            soundRecorder.stop()
            soundRecorder = nil
        }
        
        if success {
            button.setTitle("Start_Record".localized(lang: language), for: .normal)
            playBtn.isEnabled = true
        }
    }
    
    func finishPlaying() {
        if (soundPlayer?.isPlaying)! {
            soundPlayer?.stop()
        }
        
        if practice {
            playBtn.setTitle("Play".localized(lang: language), for: .normal)
            recordBtn.isEnabled = true
        } else {
            instructions2Label.isHidden = false
            trialRecordBtn.isEnabled = true
            listenBtn.isEnabled = false
        }
    }
    
    func preparePlayer() {
        print(documentPath?.appendingPathComponent(fileName))
        
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: (documentPath?.appendingPathComponent(fileName))!)
            soundPlayer?.delegate = self
//            soundPlayer?.prepareToPlay()
            soundPlayer?.volume = 1.0
        } catch let error as NSError{
            print("Error: \(error.localizedDescription)")
        }
    }
    
    
    
    func log(logMessage: String, functionName: String = #function) {
        print("\(functionName): \(logMessage)")
    }
    
    func startTimer() {
        if !timer.isValid {
            
            let aSelector : Selector = #selector(WordListViewController.update)
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: aSelector, userInfo: nil, repeats: true)
            
            startTime = Date.timeIntervalSinceReferenceDate
        }
    }
    
    @objc func update() {
        if(count > 0) {
            countLabel.text = String(count)
            count -= 1
        } else {
            resetTimer()
            countLabel.text = ""
            
            if position <= 5 {
                self.play(trials[0])
            } else {
                self.play(trials[1])
            }
        }
    }
    
    func resetTimer() {
        timer.invalidate()
    }

    
    // MARK: - Navigation
    
    @IBAction func next(_ sender: AnyObject) {
        AppDelegate.position += 1
        AppDelegate.testPosition += 1
        self.navigationController?.pushViewController(TestOrder.sharedInstance.getTest(AppDelegate.testPosition), animated: true)
    }

    @IBAction func done(_ sender: AnyObject) {
        self.deleteFile(fileName)
        self.next(self)
    }
    
    @IBAction func moveToTrial1(_ sender: AnyObject) {
        if (soundPlayer != nil) {
            if (soundPlayer?.isPlaying)! {
                soundPlayer?.stop()
            }
        }
        setSubview(practiceView, next: trial1View)
        setup()
        practice = false
        
        wordNextBtn.setTitle("Next".localized(lang: language), for: .normal)
        wordNextBtn.isHidden = true
    }
    
    
    // MARK: - Action
    
    @IBAction func recordTappedTest(_ sender: UIButton) {
        if soundRecorder == nil {
            startRecording(sender, fileName: fileName)
        } else {
            finishRecording(sender, success: true)
            trialRecordBtn.isEnabled = false
        }
    }
    
    @IBAction func recordTapped(_ sender: UIButton) {
        if soundRecorder == nil {
            startRecording(sender, fileName: "wordlist\(position).m4a")
        } else {
            finishRecording(sender, success: true)
            trialRecordBtn.isEnabled = false
            wordNextBtn.isHidden = false
        }
    }
    
    
    
    func postToAPI(object: [String: AnyObject]) {
        let index = object["index"] as! Int
        
        NetworkManager.isUnreachable { _ in
            self.internalStorage(index: index)
        }
        
        NetworkManager.isReachable { _ in
            self.externalStorage(index: index)
        }
    }
    
    private func internalStorage(index: Int) {
        let fileURL = getDocumentsDirectory().appendingPathComponent("\(FirebaseStorageManager.shared.pid!)/WordList/wordlist\(index).m4a")
        let newStoredFile = StoredFile(context: context)
        
        newStoredFile.pid = FirebaseStorageManager.shared.pid!
        newStoredFile.test = "WordList"
        newStoredFile.path = "\(FirebaseStorageManager.shared.pid!)/WordList/wordlist\(index).m4a"
        
        do {
            try DatabaseController.saveContext()
            print("saved")
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    private func externalStorage(index: Int) {
        let filePath = "\(FirebaseStorageManager.shared.pid!)/WordList/wordlist\(index).m4a"
        let fileURL = getDocumentsDirectory().appendingPathComponent(filePath)
        
        if fileExist(filePath) {
            var jsonObject = [String: AnyObject]()
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let participantRef = storageRef.child(filePath)
            
            participantRef.putFile(from: fileURL, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("Error: \(error?.localizedDescription)")
                }
                
                participantRef.downloadURL { (url, error) in
                    if error != nil {
                        print("Error: \(error?.localizedDescription)")
                    }
                    guard let downloadURL = url else { return }
                    
                    // Deprecate
                    jsonObject = [
                        "name": "wordList\(index)" as AnyObject,
                        "audio": downloadURL.absoluteString as AnyObject
                    ]
                    
                    Alamofire.request(self.APIUrl + "api/wordlist/" + self.id, method: .post, parameters: jsonObject, encoding: JSONEncoding.default, headers: self.headers).responseJSON { response in
                    }
                    
                    switch (index) {
                    case 1: WordListModel.shared.task_1 = downloadURL.absoluteString
                    case 2: WordListModel.shared.task_2 = downloadURL.absoluteString
                    case 3: WordListModel.shared.task_3 = downloadURL.absoluteString
                    case 4: WordListModel.shared.task_4 = downloadURL.absoluteString
                    case 5: WordListModel.shared.task_5 = downloadURL.absoluteString
                    case 6: WordListModel.shared.interference = downloadURL.absoluteString
                    case 7: WordListModel.shared.shortTerm = downloadURL.absoluteString
                    default: break
                    }
                    
                    
                    FirebaseStorageManager.shared.addDataToDocument(payload: [
                        "wordList": WordListModel.shared.printModel()
                    ])
                    
                    // Delete file from device
                    self.deleteAudioFile(fileURL: fileURL)
                }
            }
        }
    }
    
    @IBAction func playSound(_ sender: UIButton) {
        self.play((documentPath?.appendingPathComponent(fileName).absoluteString)!)
        
        if sender.titleLabel!.text == "Play".localized(lang: language) {
            recordBtn.isEnabled = false
            sender.setTitle("Stop".localized(lang: language), for: .normal)
            preparePlayer()
            soundPlayer?.play()
        } else {
            if (soundPlayer?.isPlaying)! {
                soundPlayer?.stop()
            }
            sender.setTitle("Play".localized(lang: language), for: .normal)
        }
    }
    
    @IBAction func listen(_ sender: AnyObject) {
        count = 3
        startTimer()
        listenBtn.isEnabled = false
    }
    
    @IBAction func nextTrial(_ sender: AnyObject) {
        postToAPI(object: createPostObject(index: position))
        position += 1
        
        if soundPlayer != nil {
            if (soundPlayer?.isPlaying)! {
                soundPlayer?.stop()
            }
        }
        
        if position <= instructions.count {
            setup()
            wordNextBtn.isHidden = true
        } else {
            setSubview(trial1View, next: completeView)
            
            completeLabel.text = "Test_complete".localized(lang: language)
            completeBtn.setTitle("Submit".localized(lang: language), for: .normal)
        }
    }
    
    func createPostObject(index: Int) -> [String: AnyObject] {
        var jsonObject = [String: AnyObject]()
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent("wordlist\(index).m4a")
        
        // Gather data for post
        jsonObject = [
            "index": index as AnyObject,
            "audio": fileURL as AnyObject
        ]
        
        return jsonObject
    }
    
    // MARK: - Delegate
    
    override func audioPlayerDidFinishPlaying(successfully flag: Bool) {
        print("finished playing")
        finishPlaying()
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
