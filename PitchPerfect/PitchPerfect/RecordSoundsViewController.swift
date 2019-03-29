//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Bushra AlSunaidi on 3/26/19.
//  Copyright © 2019 Bushra. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIButtonsState(isValid: false)
    }
    
    func setUIButtonsState (isValid: Bool) {
        recordButton.isEnabled = !isValid
        stopRecordingButton.isEnabled = isValid
        
        recordingLabel.text = (isValid) ? ("Recording in Progress") : ("Tab to Record")
    }
    
    override func viewWillAppear(_ animated: Bool) {
         print("viewWillAppear called")
    }

    @IBAction func recordAudio(_ sender: Any) {
       setUIButtonsState(isValid: true)
        
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
                
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        setUIButtonsState(isValid: false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    // MARK: - Audio Recorder Delegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else {
            print("Recording was not successful.")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "stopRecording" {
                let playSoundsVC = segue.destination as! PlaySoundsViewController
                let recordedAudioURL = sender as! URL
                playSoundsVC.recordedAudioURL = recordedAudioURL
            }
    }
    
}

