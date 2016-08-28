//
//  EditViewController.swift
//  SimpleTodo
//
//  Created by kenjou yutaka on 2016/08/20.
//  Copyright © 2016年 yutaka kenjo. All rights reserved.
//

import UIKit
import CoreData

class EditViewController: UIViewController {

    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        kbToolBar.barStyle = UIBarStyle.Default
        //kbToolBar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: #selector(AddViewController.pushCancelButton))
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        let saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: #selector(AddViewController.pushSaveButton))
        
        kbToolBar.items = [cancelButton,spacer,saveButton]
        
        textView.inputAccessoryView = kbToolBar
        
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 3
        textView.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        textView.becomeFirstResponder()
        
        textView.text = self.appDelegate.itemText as! String

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pushCancelButton(){
        if self.appDelegate.itemText != textView.text {
            let actionSheet : UIAlertController = UIAlertController(title: "変更破棄", message: "変更したテキストを破棄してもいいですか?", preferredStyle: UIAlertControllerStyle.ActionSheet)
            
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
            let fetchRequest = NSFetchRequest(entityName: "Item")
            let precidate = NSPredicate(format: "displayOrder == %d", appDelegate.displayOrder! as NSInteger)
            fetchRequest.predicate = precidate
            
            do {
                let items = try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest) as! [Item]
                items[0].text = textViewString
            } catch {
                print("error")
            }
        
            appDelegate.saveContext()
            
            self.textView.resignFirstResponder()
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
