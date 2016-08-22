//
//  FontSizeViewController.swift
//  SimpleTodo
//
//  Created by kenjou yutaka on 2016/08/22.
//  Copyright © 2016年 yutaka kenjo. All rights reserved.
//

import UIKit

class FontSizeViewController: UIViewController , UIPickerViewDataSource , UIPickerViewDelegate {

    @IBOutlet weak var fontPickerView: UIPickerView!
    
    let sizeArray : NSArray = [18,19,20,21,22,23,24]
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let selectRow :NSInteger = userDefaults.integerForKey("fontSize") - 18
        
        fontPickerView.selectRow(selectRow, inComponent: 0, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sizeArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(sizeArray[row])
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        userDefaults.setFloat(Float(sizeArray[row] as! NSNumber), forKey: "fontSize")
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
