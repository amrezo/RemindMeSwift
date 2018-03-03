//
//  RemindersTableViewController.swift
//  RemindMe
//
//  Created by Amr Al-Refae on 3/1/18.
//  Copyright © 2018 Amr Al-Refae. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class RemindersTableViewController: UITableViewController {

    // Realm var for easy access
    var realm: Realm!
    
    // Reminder List that will store the reminder items
    var remindersList: Results<ReminderItem> {
        
        get {
            return realm.objects(ReminderItem.self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init realm
        realm = try! Realm()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name: .reload, object: nil)

    }
    
    @objc func reloadTableData(_ notification: Notification) {
        tableView.reloadData()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        // When the reminder list is empty, display the placeholder
        
        if remindersList.count == 0 {
            
            // Placeholder creation, displayed when the tableView is empty
            let placeholderTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
            placeholderTitle.font = UIFont(name: "Avenir Next", size: CGFloat(integerLiteral: 27))
            placeholderTitle.numberOfLines = 2
            placeholderTitle.textColor = .black
            placeholderTitle.center = CGPoint(x: 160, y: 284)
            placeholderTitle.textAlignment = .center
            placeholderTitle.text = "Yay! You don't have any reminders. 😃"
            
            // Remove separation line in tableView and add placeholder to its backgroundView
            tableView.separatorStyle = .none
            tableView.backgroundView = placeholderTitle
            
        } else {
            
            // Reset tableView to original settings and remove separatipn line in empty cells
            tableView.backgroundView = UIView()
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .singleLine
        }
        
        //Number of sections in this reminder list
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return remindersList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath)
        
        let reminderItem = remindersList[indexPath.row]
        
        cell.textLabel?.text! = reminderItem.name
        cell.detailTextLabel?.text! = reminderItem.date
        
        
        //Ternary operator - basically an if-else statement
        cell.accessoryType = reminderItem.complete == true ? .checkmark : .none
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let reminderItem = remindersList[indexPath.row]
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminderItem.name])

        try! realm.write ({
            reminderItem.complete = !reminderItem.complete
        })
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let reminderItem = remindersList[indexPath.row]
            
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminderItem.name])

            try! realm.write({
                
                realm.delete(reminderItem)
            })
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
    }
    
    
    func deleteReminder(withIdentifier id: String) {
        
        realm = try! Realm()
        
        let reminderItem = remindersList.filter("name == %@", id).first!
        
        try! realm.write({
            
            realm.delete(reminderItem)
        })
    }
    
    func doneReminder(withIdentifier id: String) {
        
        realm = try! Realm()
        
        let reminderItem = remindersList.filter("name == %@", id).first!
        
        try! realm.write ({
            reminderItem.complete = !reminderItem.complete
        })
    }
    
    @objc func willEnterForeground() {
        self.tableView.reloadData()
    }
    
}

