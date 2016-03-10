//
//  EditProfileViewController.swift
//  Netizmo
//
//  Created by Yoon, Kyle on 2/15/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import UIKit
import CloudKit

protocol EditProfileViewControllerDelegate {
    
    func didSaveProfile(profile: Profile)
    
}

class EditProfileViewController: UIViewController {
    
    let maxRequestBytes = 1000000.0
    
    @IBOutlet var needTextField: UITextField!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var addSkillTextField: UITextField!
    @IBOutlet var skillsCollectionView: UICollectionView!
    
    var delegate: EditProfileViewControllerDelegate?
    var myProfile: Profile?
    var skills = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileImageView.layer.cornerRadius = CGRectGetWidth(self.profileImageView.frame) / 2
        self.profileImageView.clipsToBounds = true
        self.skillsCollectionView.registerNib(UINib(nibName: SkillCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: SkillCell.cellIdentifier)
        
        if let myProfile = self.myProfile {
            self.needTextField.text = myProfile.need
            self.firstNameTextField.text = myProfile.firstName
            self.lastNameTextField.text = myProfile.lastName
            if let image = myProfile.profileImage {
                self.profileImageView.image = image
            }
            
            if let skills = myProfile.skills {
                self.skills = skills
                self.skillsCollectionView.reloadData()
            }
        }
    }
    
    // TODO: Add network indicator
    private func updateProfile(profile: Profile?,
        success: Profile -> Void,
        failure: ErrorType -> Void) {
            var updateRecord: CKRecord
            if let profile = profile {
                updateRecord = profile.record
            } else {
                // new user
                updateRecord = CKRecord(recordType: "profile", recordID: CKRecordID(recordName: "myProfile"))
            }
            updateRecord[RecordKeys.FirstName.rawValue] = self.firstNameTextField.text?.whiteSpaceTrimmed()
            updateRecord[RecordKeys.LastName.rawValue] = self.lastNameTextField.text?.whiteSpaceTrimmed()
            updateRecord[RecordKeys.Need.rawValue] = self.needTextField.text?.whiteSpaceTrimmed()
            
            if let profileImage = self.profileImageView.image {
                var compression = 1.0
                var imageData = UIImageJPEGRepresentation(profileImage, CGFloat(compression))
                
                while Double(imageData!.length) > self.maxRequestBytes && compression > 0.1 {
                    compression -= 0.1
                    imageData = UIImageJPEGRepresentation(profileImage, CGFloat(compression))
                }
                
                updateRecord[RecordKeys.ProfileImage.rawValue] = imageData
            }
            
            if skills.count > 0 {
                updateRecord[RecordKeys.Skills.rawValue] = self.skills
            }
            
            CKContainer.defaultContainer().privateCloudDatabase.saveRecord(updateRecord) {
                record, error in
                if let record = record {
                    if let updatedProfile = Profile(record: record) {
                        success(updatedProfile)
                    } else {
                        // TODO: Profile initialization error
                    }
                } else {
                    if let error = error {
                        failure(error)
                    }
                }
            }
    }
    
    @IBAction func didTapProfileImage(recognizer: UITapGestureRecognizer) {
        self.setDelegateAndPresentImagePickerController()
    }
    
    @IBAction func didTapSave(sender: AnyObject) {
        self.updateProfile(self.myProfile,
            success: {
                [weak self]
                profile in
                if let delegate = self?.delegate {
                    delegate.didSaveProfile(profile)
                }
            },
            failure: {
                error in
                print("\(error)")
        })
    }
    
    @IBAction func didTapCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func didTapAddSkill(sender: AnyObject) {
        if let newSkill = self.addSkillTextField.text {
            let trimmedNewSkill = newSkill.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            self.skills.append(trimmedNewSkill)
            self.skillsCollectionView.reloadData()
            self.addSkillTextField.text = ""
        }
    }
}

extension EditProfileViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.skills.count
    }
    
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath
        indexPath: NSIndexPath) -> UICollectionViewCell {
            guard let skillCell = collectionView.dequeueReusableCellWithReuseIdentifier(SkillCell.cellIdentifier, forIndexPath: indexPath) as? SkillCell else {
                return UICollectionViewCell()
            }
            let skillString = skills[indexPath.row]
            skillCell.configureWithSkill(skillString)
            
            return skillCell
    }
    
}

extension EditProfileViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let selectedCell = collectionView.cellForItemAtIndexPath(indexPath) as? SkillCell {
            // TODO: Work on deleting skill functionality, this is temp solution
            selectedCell.configureSelectedState()
            
            let deleteAlert = UIAlertController(title: "Delete skill",
                message: "Are you sure you want to delete this skill?",
                preferredStyle: .Alert)
            let deleteAction = UIAlertAction(title: "Yes, delete", 
                style: .Destructive, 
                handler: {
                    _ in
                    self.skills.removeAtIndex(indexPath.row)
                    self.updateProfile(self.myProfile,
                        success: {
                            profile in
                            // TODO: Investigate
                            dispatch_async(dispatch_get_main_queue(),
                                {
                                    selectedCell.configureDeselectedState()
                                    self.skillsCollectionView.reloadData()
                            })
                        },
                        failure: {
                            error in
                            // TODO: Deleting error
                    })
            })
            deleteAlert.addAction(deleteAction)
            let cancelAction = UIAlertAction(title: "Cancel",
                style: .Cancel,
                handler: nil)
            deleteAlert.addAction(cancelAction)
            self.presentViewController(deleteAlert,
                animated: true,
                completion: nil)
        }
    }
    
}

extension EditProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            if self.skills.count > 0 {
                return SkillCell.cellSizeForSkill(skills[indexPath.row])
            }
            
            return CGSizeZero
    }
    
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func setDelegateAndPresentImagePickerController() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        self.presentViewController(imagePickerController,
            animated: true,
            completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, 
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.dismissViewControllerAnimated(true, completion: {
                    self.profileImageView.image = image
                })
            }
    }
    
}
