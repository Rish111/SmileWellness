//
//  ViewController.swift
//  Smile
//
//  Created by Rishul Dodhia on 3/1/20.
//  Copyright © 2020 Rishul Dodhia. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import CoreData
import UserNotifications

let questions = ["Today I'm grateful for", "I'm lucky to have", "Today I'm excited about", "Today I'm grateful for", "Today's goal is" ] //non-spaced or dotted ends

class ViewController: UIViewController {
    

    
    @IBOutlet weak var pastQ1: UILabel!
    @IBOutlet weak var pastQ2: UILabel!
    @IBOutlet weak var pastQ3: UILabel!
    @IBOutlet weak var pastQ4: UILabel!
    @IBOutlet weak var pastQ5: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var topFeature: UIImageView!
    
    var previousDates = [Date]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Check What notifications are active
//        let center = UNUserNotificationCenter.current()
//        center.getPendingNotificationRequests(completionHandler: { requests in
//            for request in requests {
//                print(request)
//            }
//        })
        
        topFeature.backgroundColor = UIColor(named: "blueBackground")
        
        // Round corners for labels
        let labelNames = [pastQ1, pastQ2, pastQ3, pastQ4, pastQ5]
        
        for name in labelNames {
            name?.layer.cornerRadius = 8
            name?.layer.masksToBounds = true
        }
        
      // Welcome Date
       dateLabel.text =  convDateToString(date: Date())

       // Allow notifications
       UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in})
        

        
        // Find past Q1
        fetchAnswers(database: "Question1", label: pastQ1, question: "\(questions[0])")
        // Find past Q2
        fetchAnswers(database: "Question2", label: pastQ2, question: "\(questions[1])")
        // Find past Q3
           fetchAnswers(database: "Question3", label: pastQ3, question: "\(questions[2])")
        // Find past Q4
           fetchAnswers(database: "Question4", label: pastQ4, question: "\(questions[3])")
        // Find past Q5
           fetchAnswers(database: "Question5", label: pastQ5, question: "\(questions[4])")
    
    }
    
    
    // Format dates
    func convDateToString(date: Date) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM"
        let dateString = "\(dateFormatter.string(from: date))"
        return dateString
    }
    
    
    // Find past Q's
       func fetchAnswers(database: String, label: UILabel, question: String) {
           
           let appDelegate = UIApplication.shared.delegate as! AppDelegate
           let context = appDelegate.persistentContainer.viewContext
           let request = NSFetchRequest<NSFetchRequestResult>(entityName: database)
           let sort = NSSortDescriptor(key: "date", ascending: false)
           request.sortDescriptors = [sort]
           
           var previousAnswers = [String]()

           do {
               let result = try context.fetch(request)
               
               for data in result as! [NSManagedObject] {
                   previousAnswers.append(data.value(forKey: "answer") as! String)
                   previousDates.append(data.value(forKey: "date") as! Date)
             }
               
           } catch { print("Failed") }
        
           // Create text for each label
           if previousAnswers.count > 0 {
               label.text = question + " \(previousAnswers[0])"
           }
           else {
               label.text = "\(question)..."
           }
       }
    
    // Create alert
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
            }))
            
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            
            self.present(alert, animated: true, completion: nil)
        }
        
    
    @IBAction func startNewDay(_ sender: Any) {
        
        if previousDates.count > 0 {
            print(convDateToString(date: Date()))
            print(convDateToString(date: previousDates[0]))
            if convDateToString(date: previousDates[0]) != convDateToString(date: Date()) {
                // entry not made today
                self.performSegue(withIdentifier: "0to1", sender: self)
                        }
        else{
           createAlert(title: "Congratulations on completing todays entry!", message: "Come back tommorrow to complete a new entry.")
                print("Entry already made today, make a new entry tommorow")
        }
        }
        else {
            // No previous entries made
            self.performSegue(withIdentifier: "0to1", sender: self)
        }
    }
    
    var showPop = ""
    
    // Show alert on completion of entry
    override func viewDidAppear(_ animated: Bool) {
        if showPop == "yes" {
        createAlert(title: "Congratulations on completing todays entry!", message: "Remember to smile when you receive your reminders.")
        showPop = ""
        }
        
    }
    
}
        
    
