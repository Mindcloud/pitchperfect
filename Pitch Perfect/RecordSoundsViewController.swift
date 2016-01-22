//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jeff Boschee on 1/17/16.
//  Copyright © 2016 Mindcloud. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var lblRecording: UILabel!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var instructionLabel: UILabel!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        btnStop.hidden = true
        instructionLabel.text = "Tap Mic to Start Recording"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func recordAudio(sender: UIButton) {
        lblRecording.hidden = false
        recordButton.hidden = true
        btnStop.hidden = false
        
        instructionLabel.text = "Tap Stop Button to Stop Recording"
        
        //Record my audio
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let recordingName = "voice_recording.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
            recordedAudio = RecordedAudio(recorderUrl: recorder.url)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else{
            print("Recording was not successful")
            recordButton.enabled = true
            btnStop.hidden = true
            lblRecording.hidden = true
        }
    }

    @IBAction func stopRecording(sender: UIButton) {
        lblRecording.hidden = true
        recordButton.hidden = false
        btnStop.hidden = true
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
        instructionLabel.text = "Tap Mic to Start Recording"
    }
    
}

