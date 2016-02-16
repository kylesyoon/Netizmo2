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
        
        self.profileImageView.layer.cornerRadius = CGRectGetWidth(self.profileImageView.frame) / 2
        self.profileImageView.clipsToBounds = true
        
        self.fetchAndDisplayProfile()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editProfileSegue" {
            if let myProfile = self.myProfile {
                let editProfileNavController = segue.destinationViewController as! UINavigationController
                let editProfileVC = editProfileNavController.viewControllers.first as! EditProfileViewController
                editProfileVC.myProfile = myProfile
                editProfileVC.delegate = self
            }
        }
    }
    
    private func fetchAndDisplayProfile() {
        // Check if user is logged into iCloud
        if self.isICloudAuthenticated() {
            let defaultPrivateDB = CKContainer.defaultContainer().privateCloudDatabase
            let myUserRecordID = CKRecordID(recordName: "myProfile")
            defaultPrivateDB.fetchRecordWithID(myUserRecordID,
                completionHandler: {
                    [weak self]
                    record, error in
                    // Check if user has a profile made
                    if let record = record {
                        if let myProfile = Profile(record: record) {
                            self?.myProfile = myProfile
                            self?.displayProfile(myProfile)
                        }
                    } else {
                        // If not, make a profile
                        self?.performSegueWithIdentifier("editProfileSegue", sender: nil)
                    }
                })
        } else {
            let iCloudError = UIAlertController(title: "Log into iCloud",
                message: "You must be logged into iCloud to use this application.",
                preferredStyle: .Alert)
            let settingsAction = UIAlertAction(title: "Settings", style: .Default, handler: {
                action in
                UIApplication
                    .sharedApplication()
                    .openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
            })
            iCloudError.addAction(settingsAction)
            self.presentViewController(iCloudError,
                animated: true, 
                completion: nil)
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
        dispatch_async(dispatch_get_main_queue(), {
            self.needLabel.text = profile.need
            self.nameLabel.text = profile.firstName + " " + profile.lastName
            if let image = profile.profileImage {
                self.profileImageView.image = image
            }
        })
    }
    
}

extension ProfileViewController: EditProfileViewControllerDelegate {
    
    func didSaveProfile(profile: Profile) {
        self.myProfile = profile
        self.displayProfile(profile)
        dispatch_async(dispatch_get_main_queue(), {
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
}