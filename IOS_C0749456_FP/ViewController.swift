//
//  ViewController.swift
//  SampleAudioRecorderApp
//
//  Created by Dharmendra on 21/05/18.
//  Copyright © 2018 dharmendra. All rights reserved.
//

import UIKit
import AVFoundation
import MessageUI

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    @IBOutlet var playBtn: UIButton!
    @IBOutlet var recordBtn: UIButton!
    
    weak var audioDelegate: NotesViewController?
    var audioTitle: String?
    var voiceRecorder : AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    var recordingSession: AVAudioSession!
    var isPlaying = false
    var fileName = "audio_file.m4a"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.startAudioSession()
    }
    
//    func startAudioSession(){
//        recordingSession = AVAudioSession.sharedInstance()
//
//        do {
//            try recordingSession.setCategory(AVAudioSession.Category.playAndRecord)
//            try recordingSession.setActive(true)
//            recordingSession.requestRecordPermission() { [unowned self] allowed in
//                DispatchQueue.main.async {
//                    if allowed {
//                        self.setupRecorder()
//                    } else {
//                        // failed to record!
//                    }
//                }
//            }
//        } catch {
//            // failed to record!
//        }
//    }
    
    func setupRecorder(){
        
        let audioFilename = getCacheDirectory().appendingPathComponent("\(audioTitle).m4a")
        let recordSetting = [ AVFormatIDKey : kAudioFormatAppleLossless ,
                              AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
                              AVEncoderBitRateKey : 320000,
                              AVNumberOfChannelsKey : 2,
                              AVSampleRateKey : 44100.2 ] as [String : Any]
        do {
            voiceRecorder = try AVAudioRecorder(url: audioFilename, settings: recordSetting)
            voiceRecorder.delegate = self
            voiceRecorder.prepareToRecord()
        } catch {
            print(error)
        }
        
    }
    
    func getCacheDirectory() -> URL {
        let fm = FileManager.default
        let docsurl = fm.urls(for:.documentDirectory, in: .userDomainMask)
        let documentDirectory = docsurl[0]
        return documentDirectory
    }
    
    func setupPlayer() {
        let audioFilename = getCacheDirectory().appendingPathComponent("\(audioTitle).m4a")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 1.0
        } catch {
            print(error)
        }

    }
    
//    func getFileURL() -> URL{
//        let path  = getCacheDirectory()
//        fileName = "audio.m4a"
//        let filePath = path.appendingPathComponent("\(fileName)")
//        return filePath
//    }
    
    @IBAction func Record(sender: UIButton) {
        if sender.titleLabel?.text == "Record"{
            setupRecorder()
            voiceRecorder.record()
            sender.setTitle("Stop", for: .normal)
            playBtn.isEnabled = false
        }
        else{
            voiceRecorder.stop()
            sender.setTitle("Record", for: .normal)
            playBtn.isEnabled = false
        }
    }
    
    @IBAction func PlayRecordedAudio(sender: UIButton) {
        if sender.titleLabel?.text == "Play" {
            recordBtn.isEnabled = false
            sender.setTitle("Stop", for: .normal)
            setupPlayer()
            audioPlayer.play()
        }
        else{
            audioPlayer.stop()
            sender.setTitle("Play", for: .normal)
            recordBtn.isEnabled = false
        }
        
    }
   
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        playBtn.isEnabled = true
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordBtn.isEnabled = true
        playBtn.setTitle("Play", for: .normal)
    }
    
    @IBAction func sendEmail(_ sender: Any) {
        if( MFMailComposeViewController.canSendMail() ) {
            print("Can send email.")
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            //Set the subject and message of the email
            mailComposer.setSubject("Voice Note")
            mailComposer.setMessageBody("my sound", isHTML: false)
//            //mailComposer.setToRecipients([""])
//            
//            do {
//              //  let fileData = try Data(contentsOf: self.getFileURL())
//                    print("File data loaded.")
//                    mailComposer.addAttachmentData(fileData as Data, mimeType: "audio/m4a", fileName: fileName)
//            }
//            catch {
//                print("File not loaded")
//            }
            //mailComposer.addAttachmentData(filecontent!, mimeType: "audio/m4a", fileName: fileName)
            
            self.present(mailComposer, animated: true, completion: nil)
        }
    }
}

extension ViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}


