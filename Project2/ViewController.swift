//
//  ViewController.swift
//  Project2
//
//  Created by Maksim Grischenko on 09.12.2021.
//

import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var highScore = 0
    var bestScore = 0
    var correctAnswer = 0
    var questions = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerLocal()
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia",  "spain", "uk", "us"]
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        let defaults = UserDefaults.standard
        highScore = defaults.object(forKey: "highScore") as? Int ?? 0
        askQuestion(action: nil)
    }
    func askQuestion(action: UIAlertAction!) {
        countries.shuffle()
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        correctAnswer = Int.random(in: 0...2)
        title = "\(countries[correctAnswer].uppercased()). Score: \(score)"
        
        if score > highScore {
            let ac = UIAlertController(title: "highscore", message: "You beat your highscore", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "ok", style: .cancel))
        }
        
        }
    func restart(action: UIAlertAction!) {
    if questions == 10 {
                score = 0
                correctAnswer = 0
                questions = 0
        title = "\(countries[correctAnswer].uppercased()). Score: \(score)"
    }
    }
    @objc func shareTapped() {
        let showScore = "Your score is \(score)"
        let vc = UIActivityViewController(activityItems: [showScore], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        questions += 1
        
        
        if questions == 10 {
            title = "Game complete!!"
            let ac2 = UIAlertController(title: title, message: "Your final score is \(score).", preferredStyle: .alert)
            ac2.addAction(UIAlertAction(title: "Restart", style: .default, handler:restart))
            present(ac2, animated: true)
        }
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
            let ac = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
            
        } else if sender.tag == 0{
            title = "Wrong"
            score -= 1
            let ac = UIAlertController(title: title, message: "It's a flag of \(countries[0]).", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
            
        } else if sender.tag == 1{
            title = "Wrong"
            score -= 1
            let ac = UIAlertController(title: title, message: "It's a flag of \(countries[1]).", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
            
        } else if sender.tag == 2{
            title = "Wrong"
            score -= 1
            let ac = UIAlertController(title: title, message: "It's a flag of \(countries[2]).", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
            
        }
        if highScore < score {
            highScore += 1
            save()
            print(highScore)
        }
        
        
        
//        let ac = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
//        present(ac, animated: true)
    }
    func save() {
            let defaults = UserDefaults.standard
            defaults.set(highScore, forKey: "highScore")
        
    }
    
   func registerLocal() {
        let center = UNUserNotificationCenter.current()

            center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                if granted {
                    self.scheduleLocal()
                } else {
                    print("D'oh")
                }
            }
        }
    func scheduleLocal() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
            let content = UNMutableNotificationContent()
            content.title = "Flags game"
            content.body = "Please return and play"
            content.categoryIdentifier = "alarm"
            content.userInfo = ["customData": "fizzbuzz"]
            content.sound = UNNotificationSound.default

            var dateComponents = DateComponents()
            dateComponents.hour = 10
            dateComponents.minute = 30
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
    }
    
}

