//
//  MainViewController.swift
//  SimpleTodo
//
//  Created by kenjou yutaka on 2016/08/17.
//  Copyright © 2016年 yutaka kenjo. All rights reserved.
//

import UIKit
import CoreData

class MainViewController:  UIViewController , UITableViewDataSource , UITableViewDelegate , NSFetchedResultsControllerDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let fetchRequest = NSFetchRequest(entityName: "Item")
        let sortDescripter = NSSortDescriptor(key: "displayOrder", ascending: true)
        fetchRequest.sortDescriptors = [sortDescripter]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: "text", cacheName: nil)
        frc.delegate = self
        
        return frc
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 30;
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()

        // Do any additional setup after loading the view.
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("An error occurred")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        let row = NSIndexPath(forRow: 0, inSection: 0)
        tableView.selectRowAtIndexPath(row, animated: false, scrollPosition: .None)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController)
    {
        //tableView.reloadData()
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
    
    //並べ替え
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        //let sourceIndex: NSInteger = sourceIndexPath.row
        //let toIndex: NSInteger = destinationIndexPath.row
        print("move")
    }

    @IBAction func trashButton(sender: UIBarButtonItem) {
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
        
        tableView.reloadData()
    }
    
    
    @IBAction func addButton(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addViewController = storyboard.instantiateViewControllerWithIdentifier("AddViewController") as! AddViewController
        
        self.presentViewController(addViewController as UIViewController, animated: true, completion: nil)
    }
    
    @IBAction func editButton(sender: UIBarButtonItem) {
        if editing {
            super.setEditing(false, animated: true)
            tableView.setEditing(false, animated: true)
        } else {
            super.setEditing(true, animated: true)
            tableView.setEditing(true, animated: true)
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
