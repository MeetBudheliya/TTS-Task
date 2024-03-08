//
//  ViewController.swift
//  TTS-Task
//
//  Created by Meet Budheliya on 07/03/24.
//

import UIKit
import QuickLook
import AVFoundation
import WebKit

class ViewController: UIViewController {

    //MARK: - UI Variables
    let play_pause_button = UIButton()
    let forword_button = UIButton()
    let backword_button = UIButton()
    let stack_controlls = UIStackView()
    var web_view = WKWebView()
    var stack_main = UIStackView()
    var stack_gender = UIStackView()
    let female_button = UIButton()
    let male_button = UIButton()
    
    //MARK: - Variables
    var synthesizer = AVSpeechSynthesizer()
    var utterance = AVSpeechUtterance()
    
    var pdf_url = URL(string: "")
    var readed_content = String()

    var is_forward: Bool = false
    var is_backword: Bool = false
    var is_gender_update: Bool = false

    
    var is_male = false{
        didSet{
//            synthesizer.stopSpeaking(at: .immediate)
           
            is_gender_update = true
            
            if is_male{
                female_button.backgroundColor = .white
                female_button.setTitleColor(.black, for: .normal)
                
                male_button.backgroundColor = .black
                male_button.setTitleColor(.white, for: .normal)
            }else{
                female_button.backgroundColor = .black
                female_button.setTitleColor(.white, for: .normal)
                
                male_button.backgroundColor = .white
                male_button.setTitleColor(.black, for: .normal)
            }
            
//            DispatchQueue.main.async { [self] in
//                textToSpeech(speech: readed_content)
//            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    
        // read text from pdf
        pdf_url = (Bundle.main.url(forResource: file_name, withExtension: file_ext) ?? URL(string: file_path))!
        let pdf = PDFDocument(url: pdf_url!)
        readed_content = pdf?.string ?? "Not found"
        
        // layout create
        createLayout()
        
        // text_view.text = readed_content
        synthesizer.delegate = self
        
        // text to speech by passing string
        textToSpeech(speech: readed_content)
    }
    
    //MARK: - Methods
    func textToSpeech(speech: String) {
        utterance = AVSpeechUtterance(string: speech)
       
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        if is_male{
            utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_male_en-US_compact")
        }else{
            utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Samantha-compact")
        }
        synthesizer.usesApplicationAudioSession = true
        synthesizer.speak(utterance)
        
        // change play button while playing audio
        play_pause_button.tag = 1
        play_pause_button.setTitle("Pause", for: .normal)
    }
    
    
    func createLayout() {
        
        stack_controlls.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack_controlls)
        
        // assign constraints and activate
        NSLayoutConstraint.activate([
            stack_controlls.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            stack_controlls.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 5),
            stack_controlls.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            stack_controlls.heightAnchor.constraint(equalToConstant: 50),
            ])
        
        // make controlls of player
        play_pause_button.setImage(UIImage(named: "ic_pause"), for: .normal)
        play_pause_button.imageView?.contentMode = .scaleAspectFit
        play_pause_button.backgroundColor = UIColor.clear
        play_pause_button.translatesAutoresizingMaskIntoConstraints = false
        play_pause_button.addTarget(self, action: #selector(playAction), for: .touchUpInside)
        
        forword_button.setImage(UIImage(named: "ic_forward"), for: .normal)
        forword_button.backgroundColor = UIColor.clear
        forword_button.frame.size = CGSize(width: 50, height: 50)
        forword_button.translatesAutoresizingMaskIntoConstraints = false
        forword_button.addTarget(self, action: #selector(forwordAction), for: .touchUpInside)

        
        backword_button.setImage(UIImage(named: "ic_backward"), for: .normal)
        backword_button.backgroundColor = UIColor.clear
        backword_button.frame.size = CGSize(width: 50, height: 50)
        backword_button.translatesAutoresizingMaskIntoConstraints = false
        backword_button.addTarget(self, action: #selector(backwordAction), for: .touchUpInside)

        stack_controlls.alignment = .fill
        stack_controlls.distribution = .fillEqually
        stack_controlls.spacing = 8.0

        // adding controlls in one horizontal stack
        stack_controlls.addArrangedSubview(backword_button)
        stack_controlls.addArrangedSubview(play_pause_button)
        stack_controlls.addArrangedSubview(forword_button)
        

        //show radio button of voice gender
        stack_gender.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack_gender)
        
        
        NSLayoutConstraint.activate([
            stack_gender.topAnchor.constraint(equalTo: view.topAnchor, constant: 45),
            stack_gender.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            stack_gender.widthAnchor.constraint(equalToConstant: 200),
            stack_gender.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        female_button.setTitle("Female", for: .normal)
        female_button.backgroundColor = .black
        female_button.setTitleColor(.white, for: .normal)
        female_button.tag = 0
        female_button.addTarget(self, action: #selector(genderAction), for: .touchUpInside)
        
        male_button.setTitle("Male", for: .normal)
        male_button.setTitleColor(.black, for: .normal)
        male_button.backgroundColor = .white
        male_button.tag = 1
        male_button.addTarget(self, action: #selector(genderAction), for: .touchUpInside)
        
        stack_gender.alignment = .fill
        stack_gender.distribution = .fillEqually
        stack_gender.layer.borderWidth = 1
        stack_gender.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        stack_gender.addArrangedSubview(male_button)
        stack_gender.addArrangedSubview(female_button)
        
        // add text view for show output text
        stack_main.axis = .vertical
        stack_main.alignment = .fill
        stack_main.spacing = 10
        
        //print(fileURL)
        web_view.loadFileURL(pdf_url!, allowingReadAccessTo: pdf_url!)
        
        stack_main.addArrangedSubview(stack_gender)
        stack_main.addArrangedSubview(web_view)
        stack_main.addArrangedSubview(stack_controlls)
        
        stack_main.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack_main)
        
           
        NSLayoutConstraint.activate([
            stack_main.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            stack_main.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            stack_main.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            stack_main.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            ])
    }
    
    //MARK: - Actions
    @objc func playAction(sender: UIButton) {
        // TAGS : play = 1, pause = 0
        
        if sender.tag == 0 {
            sender.setImage(UIImage(named: "ic_pause"), for: .normal)
            sender.tag = 1
            synthesizer.continueSpeaking()
        }else{
            sender.setImage(UIImage(named: "ic_play"), for: .normal)
            sender.tag = 0
            synthesizer.pauseSpeaking(at: .word)
        }
    }
    
    @objc func forwordAction(sender: UIButton) {
        is_forward = true
    }
    
    @objc func backwordAction(sender: UIButton) {
        is_backword = true
    }
    
    @objc func genderAction(sender: UIButton) {
        is_male = sender.tag == 1
    }
}

//MARK: - SpeechSynthesizer delegate methods
extension ViewController : AVSpeechSynthesizerDelegate{
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
//        currentPosition = synthesizer.speaking ? synthesizer.currentTime : self.utterance.preUtteranceDelay
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        synthesizer.stopSpeaking(at: .immediate)
        textToSpeech(speech: readed_content)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        
        let spokenText = (utterance.speechString as NSString).substring(with: characterRange)

        print(spokenText)
        
        if is_forward {
            // Stop current speech synthesis
            synthesizer.stopSpeaking(at: .immediate)
            
            // Create a new utterance starting from the current character
            let start_index = characterRange.location
            print("Starting Index : \(start_index)")
            let forward_utterance_text = (utterance.speechString as NSString).substring(from: start_index).removeFirst10Words()
            self.utterance = AVSpeechUtterance(string: forward_utterance_text)
            
            if is_male{
                self.utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_male_en-US_compact")
            }else{
                self.utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Samantha-compact")
            }
            
            synthesizer.speak(self.utterance)
            
            // Reset forward flag and text
            is_forward = false
        }
        
        if is_backword {
            // Stop current speech synthesis
            synthesizer.stopSpeaking(at: .immediate)

            // Create a new utterance starting from the current character
            let start_index = (characterRange.location - 10) >= 0 ? (characterRange.location - 10) : 0
            print("Starting Index : \(start_index)")
            let backword_utterance_text = (utterance.speechString as NSString).substring(from: start_index)
            self.utterance = AVSpeechUtterance(string: backword_utterance_text)
            
            if is_male{
                self.utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_male_en-US_compact")
            }else{
                self.utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Samantha-compact")
            }
            
            synthesizer.speak(self.utterance)
            
            // Reset forward flag and text
            is_backword = false
        }
        
        if is_gender_update {
            // Stop current speech synthesis
            synthesizer.stopSpeaking(at: .immediate)

            // Create a new utterance starting from the current character
            let start_index = characterRange.location
            print("Starting Index : \(start_index)")
            let backword_utterance_text = (utterance.speechString as NSString).substring(from: start_index)
            self.utterance = AVSpeechUtterance(string: backword_utterance_text)
            
            if is_male{
                self.utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_male_en-US_compact")
            }else{
                self.utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Samantha-compact")
            }
            
            synthesizer.speak(self.utterance)
            
            // Reset forward flag and text
            is_gender_update = false
        }
        
//        var output: AVAudioFile?
//
//        synthesizer.write(utterance) { (buffer: AVAudioBuffer) in
//           guard let pcmBuffer = buffer as? AVAudioPCMBuffer else {
//              fatalError("unknown buffer type: \(buffer)")
//           }
//           if pcmBuffer.frameLength == 0 {
//             // done
//           } else {
//             // append buffer to file
//             if output == nil {
//               output = try? AVAudioFile(
//                 forWriting: URL(fileURLWithPath: "test.caf"),
//                 settings: pcmBuffer.format.settings,
//                 commonFormat: .pcmFormatInt16,
//                 interleaved: false)
//             }
//             output?.write(from: pcmBuffer)
//           }
//        }
        

//        // Create an instance of AVSpeechSynthesizer
//        let synthesizer = AVSpeechSynthesizer()
//
//        // Set the delegate to track speech progress
//        let delegate = MySpeechSynthesizerDelegate()
//        synthesizer.delegate = delegate
//
//        // Create an AVSpeechUtterance
//        let utterance = AVSpeechUtterance(string: "Hello, how are you? I'm fine, thank you.")
//        synthesizer.speak(utterance)
//
//        // Set forward flag and text
//        delegate.forwardSpeech = true
//        delegate.forwardText = "fine"
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        print(utterance)
    }
}
