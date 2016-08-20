//
//  AddViewController.swift
//  SimpleTodo
//
//  Created by kenjou yutaka on 2016/08/17.
//  Copyright © 2016年 yutaka kenjo. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var returnSwitch: UISwitch!
    
    var swtichBool :Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        kbToolBar.barStyle = UIBarStyle.Default
        kbToolBar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: #selector(AddViewController.pushCancelButton))
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        let saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: #selector(AddViewController.pushSaveButton))
        
        kbToolBar.items = [cancelButton,spacer,saveButton]
 
        textView.inputAccessoryView = kbToolBar
        
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 3
        textView.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        textView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setItemData(text:String){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let fetchRequest = NSFetchRequest(entityName: "Item")
        var error: NSError? = nil
        let count = appDelegate.managedObjectContext.countForFetchRequest(fetchRequest, error: &error)
        
        
        
        if text.containsString("\n") && swtichBool == true {
            let textArray = text.componentsSeparatedByString("\n")
            //print(textArray[0])
            //print(textArray[1])
            //print(textArray[2])
            
            for i in 0..<textArray.count {
                let item = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: appDelegate.managedObjectContext) as! Item
                item.text = textArray[i]
                item.displayOrder = count + i
                item.checked = 0
            }
        } else {
            let item = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: appDelegate.managedObjectContext) as! Item
            item.text = text
            item.displayOrder = count
            item.checked = 0
        }
        
        appDelegate.saveContext()
    }

    @IBAction func switchChange(sender: UISwitch) {
        if sender.on {
            swtichBool = true
        } else {
            swtichBool = false
        }
    }
    
    func pushCancelButton(){
        if textView.text != "" {
            let actionSheet : UIAlertController = UIAlertController(title: "テキスト破棄", message: "入力済みのテキストを破棄してもいいですか?", preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            let okAction : UIAlertAction = UIAlertAction(title: "破棄する", style: UIAlertActionStyle.Default, handler:{
                (action: UIAlertAction!) -> Void in
                self.textView.resignFirstResponder()
                self.dismissViewControllerAnimated(true, completion: nil)
                }
            )
            
            let cancelAction : UIAlertAction = UIAlertAction(title: "破棄しない", style: UIAlertActionStyle.Cancel, handler:{
                (action: UIAlertAction!) -> Void in
                
                }
            )
            
            actionSheet.addAction(okAction)
            actionSheet.addAction(cancelAction)
            
            presentViewController(actionSheet, animated: true, completion: nil)
        } else {
            self.textView.resignFirstResponder()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    func pushSaveButton(){
        let textViewString = textView.text.stringByTrimmingCharactersInSet(NSCharacterSet.newlineCharacterSet())
        if textViewString != "" {
            setItemData(textViewString)
            textView.resignFirstResponder()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
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
