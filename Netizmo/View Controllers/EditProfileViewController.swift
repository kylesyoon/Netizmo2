//
//  EditProfileViewController.swift
//  Netizmo
//
//  Created by Yoon, Kyle on 2/15/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import UIKit
import CloudKit

class EditProfileViewController: UIViewController {
    
    @IBOutlet var needTextField: UITextField!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    var skills = [String]()
    
    @IBAction func didTapSave(sender: AnyObject) {
        let defaultPrivateDB = CKContainer.defaultContainer().privateCloudDatabase
        let myProfileRecordID = CKRecordID(recordName: "myProfile")
        let myProfileRecord = CKRecord(recordType: "profile", recordID: myProfileRecordID)
        myProfileRecord[RecordKeys.FirstName.rawValue] = self.firstNameTextField.text
        myProfileRecord[RecordKeys.LastName.rawValue] = self.lastNameTextField.text
        myProfileRecord[RecordKeys.Need.rawValue] = self.needTextField.text
        if self.skills.count > 0 {
            myProfileRecord["skills"] = self.skills
        }

        defaultPrivateDB.saveRecord(myProfileRecord, completionHandler: {
            [weak self]
            record, error in
            if error == nil {
                self?.dismissViewControllerAnimated(true, completion: nil)
            } else {
                print("\(error)")
            }
        })
    }
    
    @IBAction func didTapCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
