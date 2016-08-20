//
//  MainViewController.swift
//  SimpleTodo
//
//  Created by kenjou yutaka on 2016/08/17.
//  Copyright © 2016年 yutaka kenjo. All rights reserved.
//

import UIKit
import CoreData
import AudioToolbox

class MainViewController:  UIViewController , UITableViewDataSource , UITableViewDelegate , NSFetchedResultsControllerDelegate , UIGestureRecognizerDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btmToolBar: UIToolbar!
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let fetchRequest = NSFetchRequest(entityName: "Item")
        let sortDescripter = NSSortDescriptor(key: "displayOrder", ascending: true)
        fetchRequest.sortDescriptors = [sortDescripter]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        
        return frc
    }()

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 44;
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        
        let trashButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: #selector(MainViewController.pushTrashButton))
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(MainViewController.pushAddButton))
        let editButton = editButtonItem()

        btmToolBar.items = [trashButton,spacer,addButton,spacer,editButton]

        // Do any additional setup after loading the view.
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("An error occurred")
        }
        
        let settings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Badge, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        UIApplication.sharedApplication().applicationIconBadgeNumber = setBadgeValue()
        
        /*
        navigationBar.barTintColor = UIColor(red: 28 / 255, green: 67 / 255, blue: 155 / 255, alpha: 1.0)
        navigationBar.tintColor = UIColor.whiteColor()
        
        btmToolBar.barTintColor = UIColor(red: 28 / 255, green: 67 / 255, blue: 155 / 255, alpha: 1.0)
        btmToolBar.tintColor = UIColor.whiteColor()
        */
        
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(MainViewController.cellLongPressed(_:)))
        longPressRecognizer.delegate = self
        tableView.addGestureRecognizer(longPressRecognizer)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController)
    {
        tableView.reloadData()
        UIApplication.sharedApplication().applicationIconBadgeNumber = setBadgeValue()
    }
    
    func setBadgeValue() -> NSInteger{
        let fetchRequest = NSFetchRequest(entityName: "Item")
        let precidate = NSPredicate(format: "checked == %d", 0)
        fetchRequest.predicate = precidate
        
        var items : NSArray?
        
        do {
            items = try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest) as! [Item]
            
        } catch let error as NSError {
            print(error)
        }
        
        return (items?.count)!

    }
    
    @IBAction func settingButton(sender: UIBarButtonItem) {
        
    }
    
    func cellLongPressed(recognizer: UILongPressGestureRecognizer){
        if tableView.editing == false {
            let point = recognizer.locationInView(tableView)
            let indexPath = tableView.indexPathForRowAtPoint(point)
            if recognizer.state == UIGestureRecognizerState.Began{
                let item = self.fetchedResultsController.objectAtIndexPath(indexPath!) as! Item
                self.appDelegate.itemText = item.text
                self.appDelegate.displayOrder = item.displayOrder
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let editViewController = storyboard.instantiateViewControllerWithIdentifier("EditViewController") as! EditViewController
                
                self.presentViewController(editViewController as UIViewController, animated: true, completion: nil)
            }
        }
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if let sections = fetchedResultsController.sections{
            return sections.count
        }
        
        return 0;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = fetchedResultsController.sections {
            
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        
        return 0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        let item = fetchedResultsController.objectAtIndexPath(indexPath) as! Item
        let label : UILabel? = cell.contentView.viewWithTag(1) as? UILabel

        label?.text = item.text
        
        if item.checked == 1 {
            tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
            let attributeString : NSMutableAttributedString = NSMutableAttributedString(string: (label?.text)!)
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
            attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayColor(), range: NSMakeRange(0, attributeString.length))
            label?.attributedText = attributeString
        }
        
        
        return cell
    }

    //セル選択
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        let label : UILabel? = cell!.contentView.viewWithTag(1) as? UILabel
        
        let attributeString : NSMutableAttributedString = NSMutableAttributedString(string: (label?.text)!)
        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
        attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayColor(), range: NSMakeRange(0, attributeString.length))
        label?.attributedText = attributeString
        
        self.setCheckedValue(1, indexPath: indexPath)
        
        AudioServicesPlaySystemSound(1104)
        
    }
    
    //選択解除
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let label : UILabel? = cell!.contentView.viewWithTag(1) as? UILabel
        
        let attributeString : NSMutableAttributedString = NSMutableAttributedString(string: (label?.text)!)
        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 0, range: NSMakeRange(0, attributeString.length))
        attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, attributeString.length))
        label?.attributedText = attributeString
        
        setCheckedValue(0, indexPath: indexPath)
        
        AudioServicesPlaySystemSound(1104)
        
    }
    
    func setCheckedValue(value:NSNumber, indexPath:NSIndexPath){
        //let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let manageObject: NSManagedObject = fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
        manageObject.setValue(value, forKey: "checked")
        
        do{
            try appDelegate.managedObjectContext.save()
        } catch {
            print("do not saved")
        }
        
    }
    
    //スワイプアクション
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .Normal,title: "edit"){(action, indexPath) in
            
            let item = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Item
            self.appDelegate.itemText = item.text
            self.appDelegate.displayOrder = item.displayOrder
                        
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let editViewController = storyboard.instantiateViewControllerWithIdentifier("EditViewController") as! EditViewController
            
            self.presentViewController(editViewController as UIViewController, animated: true, completion: nil)
            
            
            
        }
        editAction.backgroundColor = UIColor.orangeColor()
        
        let copyAction = UITableViewRowAction(style: .Normal,title: "copy"){(action, indexPath) in
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            let label : UILabel? = cell!.contentView.viewWithTag(1) as? UILabel
            
            let board = UIPasteboard.generalPasteboard()
            board.setValue((label?.text)!, forPasteboardType: "public.text")
        }
        copyAction.backgroundColor = UIColor.grayColor()
        
        return [editAction,copyAction]
    }
    
    //追加・削除スタイル制御
    /*
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.None
    }
    */
    
    //並べ替え
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let sourceIndex: NSInteger = sourceIndexPath.row
        let toIndex: NSInteger = destinationIndexPath.row
        //print(sourceIndex)
        //print(toIndex)
        
        if sourceIndex == toIndex {
            return
        }
        
        
        let affectedItem = fetchedResultsController.objectAtIndexPath(sourceIndexPath) as! Item
        //print(affectedItem.text)
        affectedItem.displayOrder = toIndex
        
        let start:NSInteger
        let end:NSInteger
        let delta:NSInteger
        
        if sourceIndex < toIndex {
            delta = -1
            start = sourceIndex + 1
            end = toIndex
        } else {
            delta = 1
            start = toIndex
            end = sourceIndex - 1
        }
        
        for i in start..<end + 1 {
            let fetchIndexPath = NSIndexPath(forRow: i, inSection: 0)
            let item = fetchedResultsController.objectAtIndexPath(fetchIndexPath) as! Item
            item.displayOrder = i + delta
        }
        
        appDelegate.saveContext()
        
        
        
    }

    
    //編集ボタン
    /*
    @IBAction func editButton(sender: UIBarButtonItem) {
        if editing {
            super.setEditing(false, animated: true)
            tableView.setEditing(false, animated: true)
        } else {
            super.setEditing(true, animated: true)
            tableView.setEditing(true, animated: true)
        }
    }
     */
    
    func pushTrashButton(){
        let list = tableView.indexPathsForSelectedRows
        
        if list?.count != nil {
            
            
            //let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let fetchRequest = NSFetchRequest(entityName: "Item")
            let precidate = NSPredicate(format: "checked == %d", 1)
            fetchRequest.predicate = precidate
            
            do {
                let items = try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest) as! [Item]
                for item in items {
                    appDelegate.managedObjectContext.deleteObject(item)
                }
            } catch let error as NSError {
                print(error)
            }
            
            appDelegate.saveContext()
            
            
            //displayOrderの再設定
            let fetchRequestOrder = NSFetchRequest(entityName: "Item")
            let sortDescripter = NSSortDescriptor(key: "displayOrder", ascending: true)
            fetchRequestOrder.sortDescriptors = [sortDescripter]
            
            do {
                let itemsOrder = try appDelegate.managedObjectContext.executeFetchRequest(fetchRequestOrder) as! [Item]
                for i in 0..<itemsOrder.count {
                    itemsOrder[i].displayOrder = i
                }
            } catch let error as NSError {
                print(error)
            }
            
            appDelegate.saveContext()
            
        }

    }
    
    func pushAddButton(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addViewController = storyboard.instantiateViewControllerWithIdentifier("AddViewController") as! AddViewController
        
        self.presentViewController(addViewController as UIViewController, animated: true, completion: nil)
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: true)
        tableView.editing = editing
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
