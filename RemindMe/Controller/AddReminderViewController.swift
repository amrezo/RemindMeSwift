//
//  AddReminderViewController.swift
//  RemindMe
//
//  Created by Amr Al-Refae on 3/1/18.
//  Copyright © 2018 Amr Al-Refae. All rights reserved.
//

import UIKit
import RealmSwift


class AddReminderViewController: UIViewController, UITextFieldDelegate {
    
    // Realm var for easy access
    var realm: Realm!
    

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var reminderName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init realm
        realm = try! Realm()
        
        self.reminderName.delegate = self
        
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")

    }

    @IBAction func didPressCancel(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func didPressAdd(_ sender: UIButton) {
        
        // Formatting the date to be presented as needed - E.g. Saturday, Mar 03, 2018 - 3:11 AM
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM dd, yyyy - h:mm a"
        let dateString = dateFormatter.string(from: datePicker.date)
        
        let newReminder = ReminderItem()
        newReminder.name = reminderName.text!
        newReminder.date = dateString
        newReminder.complete = false
        
        try! self.realm.write({
            
            self.realm.add(newReminder)
        })
        
        NotificationCenter.default.post(name: .reload, object: nil)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    // Hide keyboard when user taps outsides keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Hide keyboard when user presses on return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        reminderName.resignFirstResponder()
        return true
    }
    
    
}

extension Notification.Name {
    static let reload = Notification.Name("reload")
}
