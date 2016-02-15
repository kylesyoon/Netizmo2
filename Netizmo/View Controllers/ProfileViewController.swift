//
//  ViewController.swift
//  Netizmo
//
//  Created by Yoon, Kyle on 2/11/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import UIKit
import CloudKit

class ProfileViewController: UIViewController {

    @IBOutlet var needLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var skillsCollectionView: UICollectionView!
    
    var myProfile: Profile?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isICloudAuthenticated() {
            let defaultPrivateDB = CKContainer.defaultContainer().privateCloudDatabase
            let myUserRecordID = CKRecordID(recordName: "myProfile")
            defaultPrivateDB.fetchRecordWithID(myUserRecordID,
                completionHandler: {
                    [weak self]
                    record, error in
                    if let record = record {
                        if let myProfile = Profile(record: record) {
                            self?.myProfile = myProfile
                            self?.displayProfile(myProfile)
                        }
                    } else {
                        self?.performSegueWithIdentifier("editProfileSegue", sender: nil)
                    }
                })
        } else {
            let iCloudError = UIAlertController(title: "Log into iCloud",
                message: "You must be logged into iCloud to use this application.",
                preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            iCloudError.addAction(okAction)
            self.presentViewController(iCloudError, animated: true, completion: nil)
        }
    }
    
    private func isICloudAuthenticated() -> Bool {
        if NSFileManager.defaultManager().ubiquityIdentityToken == nil {
            return false
        } else {
            return true
        }
    }
    
    private func displayProfile(profile: Profile) {
        self.needLabel.text = profile.need
        self.nameLabel.text = profile.firstName + " " + profile.lastName
    }
    
}

