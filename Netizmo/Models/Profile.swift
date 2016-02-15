//
//  User.swift
//  Netizmo
//
//  Created by Yoon, Kyle on 2/15/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import UIKit
import CloudKit

enum RecordKeys: String {
    case FirstName
    case LastName
    case Need
}

struct Profile {
    
    let firstName: String
    let lastName: String
//    let profileImage: UIImage
    let need: String
//    let skills: [String]
    
    init(firstName: String, lastName: String, need: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.need = need
    }
    
    init?(record: CKRecord) {
        
        let firstName = record[RecordKeys.FirstName.rawValue]
        print("FIRSTNAME: \(firstName)")
        if let firstName = record[RecordKeys.FirstName.rawValue] as? String,
            lastName = record[RecordKeys.LastName.rawValue] as? String,
            need = record[RecordKeys.Need.rawValue] as? String {
                self.init(firstName: firstName,
                    lastName: lastName,
                    need: need)
        }
        
        return nil
    }
    
}