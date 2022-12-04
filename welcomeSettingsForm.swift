//
//  welcomeSettingsForm.swift
//  Smile
//
//  Created by Rishul Dodhia on 7/1/20.
//  Copyright © 2020 Rishul Dodhia. All rights reserved.
//

import Foundation
import UIKit


class welcomeSettingsForm: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var toggleReminder: UISwitch!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var topFeature: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        topFeature.backgroundColor = UIColor(named: "blueBackground")
        
    }
    
    @IBAction func toggleForTime(_ sender: Any) {
         if toggleReminder.isOn {
            timePicker.isUserInteractionEnabled = true
            timePicker.alpha = CGFloat(1.0)
        }
         else{
            timePicker.isUserInteractionEnabled = false
            timePicker.alpha = CGFloat(0.3)
        }
    }
    
    // Empty error
    func errorHighlightTextField(input: UITextField) {
        input.layer.borderColor = UIColor.red.cgColor
        input.layer.borderWidth = 1
        input.layer.cornerRadius = 5
    }

    @IBAction func onBoard(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "walkThroughSeen")
        
         if toggleReminder.isOn {
            UserDefaults.standard.set(true, forKey: "reminder")
            
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyReminder"])
            
            // Get hours & mins from date picker
            let date = timePicker.date
            let components = Calendar.current.dateComponents([.hour, .minute], from: date)
            let hour = components.hour!
            let minute = components.minute!
            
            // Send reminder notification
            if UserDefaults.standard.bool(forKey: "reminder") == true {
                let contentRem = UNMutableNotificationContent()
                contentRem.title = "Smile"
                contentRem.subtitle = "Remember to enter what you are grateful for today!"
                contentRem.body = ""
                contentRem.badge = 1
                
                UserDefaults.standard.set(hour, forKey: "reminderHour")
                UserDefaults.standard.set(minute, forKey: "reminderMin")
                    
                var dateComponents = DateComponents()
                dateComponents.hour = UserDefaults.standard.integer(forKey: "reminderHour")
                dateComponents.minute = UserDefaults.standard.integer(forKey: "reminderMin")
                    let triggerRem = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                    
                    let request = UNNotificationRequest(identifier: "dailyReminder", content: contentRem, trigger: triggerRem)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                    
                    print("remider set")
                    }
                    else
                    {
                        print("no reminders")
                    }

               }
        else
           {
            UserDefaults.standard.set(false, forKey: "reminder")
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyReminder"])
               }

           self.performSegue(withIdentifier: "settingsTo0", sender: self)
        }
    }
