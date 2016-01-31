//
//  PlayAudioViewController.swift
//  PitchPerfect
//
//  Created by Wouter de Vos on 2015/07/16.
//  Copyright (c) 2015 Wouter. All rights reserved.
//

import UIKit
import AVFoundation

class PlayAudioViewController: UIViewController {

    enum Rate : Float {
        case Default = 0.0, Fast = 1.5, Slow = 0.5
    }
    
    enum Pitch : Float {
        case Default = 1.0, High = 1000, Low = -1000
    }
    
    var audioEngine : AVAudioEngine!
    var audioFile : AVAudioFile!
    var receivedAudio : RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudio(Rate.Slow)
    }

    @IBAction func playFastAudio(sender: UIButton) {
        playAudio(Rate.Fast)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudio(Pitch.High)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudio(Pitch.Low)
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        audioEngine.stop()
    }
    
    func playAudio(rate : Rate) {
        // Create an audio unit that controls the rate and pitch, and set the rate
        let audioTimePitch = AVAudioUnitTimePitch()
        if rate != Rate.Default {
            audioTimePitch.rate = rate.rawValue
        }
        
        playAudio(audioTimePitch)
    }
    
    func playAudio(pitch : Pitch) {
        // Create an audio unit that controls the rate and pitch, and set the pitch
        let audioTimePitch = AVAudioUnitTimePitch()
        if pitch != Pitch.Default {
            audioTimePitch.pitch = pitch.rawValue
        }
        
        playAudio(audioTimePitch)
    }
    
    func playAudio(audioTimePitch : AVAudioUnitTimePitch) {
        // Stop and reset the audio engine
        audioEngine.stop()
        audioEngine.reset()
        
        // Create and stop the audio player
        let audioPlayer = AVAudioPlayerNode()
        audioPlayer.stop()
        
        // Attach the audio player node and the audio time pitch node to the audio engine
        audioEngine.attachNode(audioPlayer)
        audioEngine.attachNode(audioTimePitch)
        
        // Connect the audio from the audio player to the audio time-pitch unit and then
        // connect the audio time-pitch unit to the audio engine output
        audioEngine.connect(audioPlayer, to: audioTimePitch, format: nil)
        audioEngine.connect(audioTimePitch, to: audioEngine.outputNode, format: nil)
        
        // Play the audio
        audioPlayer.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        audioPlayer.play()
    }
}
