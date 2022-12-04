//
//  FifthEntry.swift
//  Smile
//
//  Created by Rishul Dodhia on 3/1/20.
//  Copyright © 2020 Rishul Dodhia. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import UserNotifications


var currentAnswer5 = ""


// Init context, entity & newAnswer

let appDelegate5 = UIApplication.shared.delegate as! AppDelegate
let context5 = appDelegate5.persistentContainer.viewContext
let entity5 = NSEntityDescription.entity(forEntityName: "Question5", in: context5)
let newAnswer5 = NSManagedObject(entity: entity5!, insertInto: context5)


class FifthEntry: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var gratefulInput: UITextField!
    @IBOutlet weak var mostRecent1: UIButton!
    @IBOutlet weak var mostRecent2: UIButton!
    @IBOutlet weak var mostRecent3: UIButton!
    @IBOutlet weak var autoRecent1: UIButton!
    @IBOutlet weak var autoRecent2: UIButton!
    @IBOutlet weak var autoRecent3: UIButton!
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var topFeature: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        topFeature.backgroundColor = UIColor(named: "blueBackground")
        
        self.gratefulInput.delegate = self

        //Load Question
        pageTitle.text = "\(questions[4])..."
        
        // Setup auto past answers
        autoRecent1.setTitle("get to the gym", for: .normal) // to be updated for each page
        autoRecent2.setTitle("call my family", for: .normal) // to be updated for each page
        autoRecent3.setTitle("to relax", for: .normal) // to be updated for each page
        
        // Fetch past answers
            fetchSort()
        
          }
                    
        // fetch past 3 answers and sort display them
        func fetchSort() {
            
            // Init context, entity & newAnswer
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
        
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Question5")
            let sort = NSSortDescriptor(key: "date", ascending: false)
            request.sortDescriptors = [sort]
            
            var previousAnswers = [String]()
            
            do {
                let result = try context.fetch(request)
                for data in result as! [NSManagedObject] {
                    //print(data.value(forKey: "answer") as! String)
                    previousAnswers.append(data.value(forKey: "answer") as! String)
                    //print(data.value(forKey: "date") as! NSDate)
              }
            } catch { print("Failed") }
            
            // Show last three selected answers options
            
            let labels = [mostRecent1, mostRecent2, mostRecent3]
            
            var counter = 0
            for label in labels {
                if (counter < previousAnswers.count) {
                    label?.setTitle(previousAnswers[counter], for: .normal)
                }
                    else {
                        label?.setTitle(nil, for: .normal)
                        print("Not enough previous answers")
                    }
                counter += 1
                }
        }

    // Send data through segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "5to0" {
            if let destinationVC = segue.destination as? ViewController  {
                destinationVC.showPop = "yes"
            }
        }
    }

    
    //Send notifications
    func sendNotification(contentTag: UNMutableNotificationContent, body: String, time: Int, identifier: String) {
        
    contentTag.title = "Remember to smile!"
    contentTag.subtitle = ""
    contentTag.body = body
    contentTag.badge = 1
    contentTag.sound = UNNotificationSound.default
     
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(time), repeats: false)
    
    let request = UNNotificationRequest(identifier: identifier, content: contentTag, trigger: trigger)
     
    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    // Run notifications
    func runNotifications() {
        let content1 = UNMutableNotificationContent()
        let content2 = UNMutableNotificationContent()
        let content3 = UNMutableNotificationContent()
        let content4 = UNMutableNotificationContent()
        let content5 = UNMutableNotificationContent()
        
        sendNotification(contentTag: content1, body: currentAnswer1, time: Int(arc4random_uniform(90*60)+1), identifier: "one")
        sendNotification(contentTag: content2, body: currentAnswer2, time: Int(arc4random_uniform(60*60)+1), identifier: "two")
        sendNotification(contentTag: content3, body: currentAnswer3, time: Int(arc4random_uniform(6*60*60)+1), identifier: "three")
        sendNotification(contentTag: content4, body: currentAnswer4, time: Int(arc4random_uniform(12*60*60)+1), identifier: "four")
        sendNotification(contentTag: content5, body: currentAnswer5, time: Int(arc4random_uniform(5*60*60)+1), identifier: "five")
    }
    
    // Presses return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return(true)
    }
    
    // Formatting answer function
       func formatAnswer(question: String, input: String) -> String {
           return (question + " \(input)!")
    }
    
    // Empty error
    func errorHighlightTextField(gratefulInput: UITextField) {
        gratefulInput.layer.borderColor = UIColor.red.cgColor
        gratefulInput.layer.borderWidth = 1
        gratefulInput.layer.cornerRadius = 5
    }
    
     // Write answer to database
    func saveUp(button: UIButton) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Question5", in: context)
        let newAnswer = NSManagedObject(entity: entity!, insertInto: context)
        
        let input: String? = button.title(for: .normal)
        newAnswer.setValue(input, forKey: "answer")
        newAnswer.setValue(NSDate(), forKey: "date")
        
        // Ensure answer is sent out
        currentAnswer5 = formatAnswer(question: questions[4], input: input!)
        do {
           try context.save()
          } catch {
           print("Failed saving")
        }
    }
    
    @IBAction func mrbutton1(_ sender: Any) {
        // Write to database
        saveUp(button: mostRecent1)
        self.performSegue(withIdentifier: "5to0", sender: self)
        runNotifications()
    }
    @IBAction func mrbutton2(_ sender: Any) {
        saveUp(button: mostRecent2)
        self.performSegue(withIdentifier: "5to0", sender: self)
        runNotifications()
    }
    @IBAction func mrbutton3(_ sender: Any) {
        saveUp(button: mostRecent3)
        self.performSegue(withIdentifier: "5to0", sender: self)
        runNotifications()
    }
    @IBAction func mrbutton4(_ sender: Any) {
        saveUp(button: autoRecent1)
        self.performSegue(withIdentifier: "5to0", sender: self)
    }
    @IBAction func mrbutton5(_ sender: Any) {
        saveUp(button: autoRecent2)
        self.performSegue(withIdentifier: "5to0", sender: self)
        runNotifications()
    }
    @IBAction func mrbutton6(_ sender: Any) {
           saveUp(button: autoRecent3)
        self.performSegue(withIdentifier: "5to0", sender: self)
        runNotifications()
    }
    
    @IBAction func save(_ sender: Any) {
        // If empty
        if let text = gratefulInput.text, text.isEmpty {
            errorHighlightTextField(gratefulInput: gratefulInput)
         } else {
            
            // Write answer to database
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Question5", in: context)
            let newAnswer = NSManagedObject(entity: entity!, insertInto: context)
            
            newAnswer.setValue(gratefulInput.text, forKey: "answer")
            newAnswer.setValue(NSDate(), forKey: "date")
            
            do {
               try context.save()
                // Ensure answer is sent out
                currentAnswer5 = formatAnswer(question: questions[4], input: gratefulInput.text!)
                
              } catch {
               print("Failed saving")
            }
            self.performSegue(withIdentifier: "5to0", sender: self)
            runNotifications()
        }
    }
}

