//
//  ob6.swift
//  Smile
//
//  Created by Rishul Dodhia on 12/1/20.
//  Copyright © 2020 Rishul Dodhia. All rights reserved.
//

import Foundation
import UIKit

class ob6: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Allow notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in})
    }


@IBAction func onBoard(_ sender: Any) {
    UserDefaults.standard.set(true, forKey: "walkThroughSeen")
    
    UserDefaults.standard.set(true, forKey: "reminder")
    
    UserDefaults.standard.set(9, forKey: "reminderHour")
    UserDefaults.standard.set(00, forKey: "reminderMin")
    
    // Send reminder notification
    if UserDefaults.standard.bool(forKey: "reminder") == true {
        let contentRem = UNMutableNotificationContent()
        contentRem.title = "Smile"
        contentRem.subtitle = "Remember to enter what you are grateful for today!"
        contentRem.body = ""
        contentRem.badge = 1
            
        var dateComponents = DateComponents()
        dateComponents.hour = UserDefaults.standard.integer(forKey: "reminderHour")
        dateComponents.minute = UserDefaults.standard.integer(forKey: "reminderMin")
            let triggerRem = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let request = UNNotificationRequest(identifier: "dailyReminder", content: contentRem, trigger: triggerRem)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
            print("remider set")
            print(triggerRem)
            }
            else
            {
                print("no reminders")
            }
    
    self.performSegue(withIdentifier: "onboardingTo1", sender: self)
           }
    }
