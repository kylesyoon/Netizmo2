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
    case ProfileImage
}

struct Profile {
    let record: CKRecord
    let firstName: String
    let lastName: String
    let profileImage: UIImage?
    let need: String
//    let skills: [String]
    
    init(firstName: String, lastName: String, need: String, image: UIImage?, record: CKRecord) {
        self.firstName = firstName
        self.lastName = lastName
        self.need = need
        self.profileImage = image
        self.record = record
    }
    
    init?(record: CKRecord) {
        if let firstName = record[RecordKeys.FirstName.rawValue] as? String,
            lastName = record[RecordKeys.LastName.rawValue] as? String,
            need = record[RecordKeys.Need.rawValue] as? String {
                var image: UIImage?
                if let imageData = record[RecordKeys.ProfileImage.rawValue] as? NSData {
                    image = UIImage(data: imageData)
                }
                self.init(firstName: firstName,
                    lastName: lastName,
                    need: need,
                    image: image,
                    record: record)
        } else {
            return nil
        }
    }
    
}