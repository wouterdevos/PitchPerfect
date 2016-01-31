//
//  RecordAudioViewController.swift
//  PitchPerfect
//
//  Created by Wouter de Vos on 2015/07/13.
//  Copyright (c) 2015 Wouter. All rights reserved.
//

import UIKit
import AVFoundation

class RecordAudioViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var tapToRecordLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder : AVAudioRecorder!
    var recordedAudio : RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        recordingLabel.hidden = true
        tapToRecordLabel.hidden = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        recordButton.enabled = true
        stopButton.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecordingSegue" {
            let playAudioVC : PlayAudioViewController = segue.destinationViewController as! PlayAudioViewController
            let data = sender as! RecordedAudio
            playAudioVC.receivedAudio = data
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            recordedAudio = RecordedAudio(filePathUrl : recorder.url, title : recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecordingSegue", sender: recordedAudio)
        }
        else {
            print("Recording finished unsuccessfully")
            recordButton.enabled = true
            stopButton.hidden = true
        }
        
    }
    
    @IBAction func startRecording(sender: UIButton) {
        recordingLabel.hidden = false
        tapToRecordLabel.hidden = true
        recordButton.enabled = false
        stopButton.hidden = false
                
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)[0]
        
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        // Setup audio session
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        // Initialise and prepare the recorder
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        recordingLabel.hidden = true
        tapToRecordLabel.hidden = false
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
}

