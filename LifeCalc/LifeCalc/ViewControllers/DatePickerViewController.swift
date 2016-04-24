//
//  DatePickerViewController.swift
//  LifeCalc
//
//  Created by takashi on 2016/04/24.
//  Copyright © 2016年 Takashi Ikeda. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    var initialDate = NSDate()
    var delegate : DatePickerViewControllerDelegate?
    
    @IBAction func valueChangedDatePicker(sender: UIDatePicker) {
        self.delegate?.valueChangedDatePicker(self, datePicker: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.datePicker.date = self.initialDate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol DatePickerViewControllerDelegate {
    func valueChangedDatePicker(viewController : DatePickerViewController, datePicker : UIDatePicker)
}