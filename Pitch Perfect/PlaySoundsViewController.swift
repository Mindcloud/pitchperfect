//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jeff Boschee on 1/21/16.
//  Copyright © 2016 Mindcloud. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
   
    var audioPlayer:AVAudioPlayer!
    var audioEngine:AVAudioEngine!
    var receivedAudio:RecordedAudio!
    var audioFile: AVAudioFile!
    var audioSession:AVAudioSession = AVAudioSession.sharedInstance()
   
    @IBOutlet weak var wetDrySlider: UISlider!

    func playSound(playSpeed: Float) {
        stopAndResetAudio()
        audioPlayer.currentTime = 0.0
        audioPlayer.enableRate = true
        audioPlayer.rate = playSpeed
        audioPlayer.play()
    }
    
    func stopAndResetAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer = try? AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
        
        // Play via speaker
        try! audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: AVAudioSessionCategoryOptions.DefaultToSpeaker)
    }

    @IBAction func playSoundSlow(sender: UIButton) {
        playSound(0.5)
    }
    
    @IBAction func playSoundFast(sender: UIButton) {
        playSound(2.0)
    }
    
    @IBAction func playStop(sender: UIButton) {
        stopAndResetAudio()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePith(1000)
    }
    
    @IBAction func playMonsterAudio(sender: UIButton) {
        playAudioWithVariablePith(-1000)
    }
    
    @IBAction func PlayLargeChamberSound(sender: UIButton) {
        playAudioWithReverb(wetDrySlider.value)
    }
    
    func playAudioWithVariablePith(pitch: Float){
        stopAndResetAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    func playAudioWithReverb(wetDry: Float) {
        stopAndResetAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let addReverb = AVAudioUnitReverb()
        addReverb.loadFactoryPreset(AVAudioUnitReverbPreset.LargeHall2)
        addReverb.wetDryMix = wetDry
        audioEngine.attachNode(addReverb)
        
        audioEngine.connect(audioPlayerNode, to: addReverb, format: nil)
        audioEngine.connect(addReverb, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
}