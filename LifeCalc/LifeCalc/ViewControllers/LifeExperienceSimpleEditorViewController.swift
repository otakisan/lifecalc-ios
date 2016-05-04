//
//  LifeExperienceSimpleEditorViewController.swift
//  LifeCalc
//
//  Created by takashi on 2016/04/24.
//  Copyright © 2016年 Takashi Ikeda. All rights reserved.
//

import UIKit
import RealmSwift

class LifeExperienceSimpleEditorViewController: UIViewController {
    
    var lifeExperience : LifeExperience?

    @IBOutlet weak var startsAtButton: UIButton!
    @IBOutlet weak var endsAtButton: UIButton!
    @IBOutlet weak var actionTextField: UITextField!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    
    @IBAction func touchUpInsideStartsAtButton(sender: UIButton) {
        self.popoverDatePickerViewController(sourceView: sender, initialValue: self.lifeExperience?.startsAt ?? NSDate())
    }
    
    @IBAction func touchUpInsideEndsAtButton(sender: UIButton) {
        self.popoverDatePickerViewController(sourceView: sender, initialValue: self.lifeExperience?.endsAt ?? NSDate())
    }
    
    @IBAction func editingChangedActionTextField(sender: UITextField) {
        if let realm = self.lifeExperience?.realm {
            let _ = try? realm.write({
                self.lifeExperience?.action = self.actionTextField.text ?? ""
            })
        } else {
            self.lifeExperience?.action = self.actionTextField.text ?? ""
        }
    }

    @IBAction func editingChangedPlaceTextField(sender: UITextField) {
        if let realm = self.lifeExperience?.realm {
            let _ = try? realm.write({
                self.lifeExperience?.place = self.placeTextField.text ?? ""
            })
        } else {
            self.lifeExperience?.place = self.placeTextField.text ?? ""
        }
    }
    
    @IBAction func editingChangedNoteTextField(sender: UITextField) {
        if let realm = self.lifeExperience?.realm {
            let _ = try? realm.write({
                self.lifeExperience?.note = self.noteTextField.text ?? ""
            })
        } else {
            self.lifeExperience?.note = self.noteTextField.text ?? ""
        }
    }
    
    func onTapSaveButton(barButtonItem : UIBarButtonItem) {
        guard let lifeExperience = self.lifeExperience else {
            return
        }
        
        if let realm = try? Realm() {
            let _ = try? realm.write({ 
                realm.add(lifeExperience)
            })
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func onTapKeywordsBarButtonItem(barButtonItem : UIBarButtonItem) {
        self.showAlertMessage("TitleForCategoryKeywords".localized(), message: "\("MessageForCategoryKeywords".localized())\n\(self.keywordsExamples())", okHandler: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.initAnalysisTracker("体験編集（LifeExperienceSimpleEditor）")
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
   }

    private func popoverDatePickerViewController(sourceView sourceView : UIView, initialValue : NSDate) {
        let datePickerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DatePickerViewController") as! DatePickerViewController
        datePickerVC.delegate = self
        datePickerVC.initialDate = initialValue
        
        self.popoverViewController(datePickerVC, sourcView: sourceView, delegate: self, preferredContentSize: CGSize(width: 300, height: 200))
    }
    
    private func initialize() {
        self.attachSaveButtonIfCreateNew()
        
        if self.lifeExperience == nil {
            self.lifeExperience = LifeExperience()
        }
        
        self.startsAtButton.setTitle(self.localDatetimeAndDayOfTheWeekString(self.lifeExperience?.startsAt), forState: .Normal)
        self.endsAtButton.setTitle(self.localDatetimeAndDayOfTheWeekString(self.lifeExperience?.endsAt), forState: .Normal)
        self.actionTextField.text = self.lifeExperience?.action
        self.placeTextField.text = self.lifeExperience?.place
        self.noteTextField.text = self.lifeExperience?.note
        
        self.actionTextField.delegate = self
        self.placeTextField.delegate = self
        self.noteTextField.delegate = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "keywordsBarButtonItemLabel".localized(), style: .Plain, target: self, action: #selector(self.onTapKeywordsBarButtonItem(_:)))
    }
    
    private func localDatetimeAndDayOfTheWeekString(date : NSDate?) -> String {
        return "\(date?.localDateString() ?? "") \(date?.localTimeString() ?? "") (\(date?.localDayOfTheWeekString() ?? ""))"
    }
    
    private func attachSaveButtonIfCreateNew() {
        if self.lifeExperience?.realm == nil {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(self.onTapSaveButton))
        }
    }
    
    private func keywordsExamples() -> String {
        let job = "\("Working".localized()) : \(LifeCalculator.defaultCalculator.filterWordsForJob().joinWithSeparator(", "))"
        let leisure = "\("Leisure".localized()) : \(LifeCalculator.defaultCalculator.filterWordsForLeisure().joinWithSeparator(", "))"
        let learning = "\("Learning".localized()) : \(LifeCalculator.defaultCalculator.filterWordsForLearning().joinWithSeparator(", "))"
        
        return "\(job)\n\(leisure)\n\(learning)"
    }
}

extension LifeExperienceSimpleEditorViewController : UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
}

extension LifeExperienceSimpleEditorViewController : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

extension LifeExperienceSimpleEditorViewController : DatePickerViewControllerDelegate {
    func valueChangedDatePicker(viewController: DatePickerViewController, datePicker: UIDatePicker) {
        let dateString = "\(DateUtility.localDateString(datePicker.date)) \(DateUtility.localTimeString(datePicker.date)) (\(DateUtility.localDayOfTheWeekString(datePicker.date)))"
        (viewController.popoverPresentationController?.sourceView as? UIButton)?.setTitle(dateString, forState: .Normal)
        
        if viewController.popoverPresentationController?.sourceView == self.startsAtButton {
            if let realm = self.lifeExperience?.realm {
                let _ = try? realm.write({
                    self.lifeExperience?.startsAt = datePicker.date
                })
            } else {
                self.lifeExperience?.startsAt = datePicker.date
            }
        } else if viewController.popoverPresentationController?.sourceView == self.endsAtButton {
            if let realm = self.lifeExperience?.realm {
                let _ = try? realm.write({
                    self.lifeExperience?.endsAt = datePicker.date
                })
            } else {
                self.lifeExperience?.endsAt = datePicker.date
            }
        }
    }
}

