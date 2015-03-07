//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Brian Saunders on 3/5/15.
//  Copyright (c) 2015 Brian Saunders. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    var reverbEffect:AVAudioUnitReverb!
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        reverbEffect = AVAudioUnitReverb()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Play Recording
    
    @IBAction func playSoundSlowly(sender: UIButton) {
        playSoundAtRate(0.5)
    }

    @IBAction func playSoundQuickly(sender: UIButton) {
        playSoundAtRate(1.5)
    }
    
    func playSoundAtRate(rate: Float) {
        audioPlayer.stop()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    @IBAction func stopPlayingAudio(sender: UIButton) {
        audioPlayer.stop()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        audioPlayer.stop()
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        audioPlayer.stop()
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        var reverbEffect = AVAudioUnitReverb()
        reverbEffect.wetDryMix = 80
        audioEngine.attachNode(reverbEffect)
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)

        audioEngine.connect(audioPlayerNode, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayer.play()
    }
}













