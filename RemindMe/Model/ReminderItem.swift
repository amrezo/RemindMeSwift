//
//  ReminderItem.swift
//  RemindMe
//
//  Created by Amr Al-Refae on 3/2/18.
//  Copyright © 2018 Amr Al-Refae. All rights reserved.
//

import Foundation
import RealmSwift

class ReminderItem: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var date = ""
    @objc dynamic var complete = false
    
}
