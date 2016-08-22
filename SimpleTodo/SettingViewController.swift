//
//  SettingViewController.swift
//  SimpleTodo
//
//  Created by kenjou yutaka on 2016/08/21.
//  Copyright © 2016年 yutaka kenjo. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {
    
    @IBOutlet weak var soundSwitch: UISwitch!
    
    @IBOutlet weak var badgeSwitch: UISwitch!
    
    @IBOutlet weak var adSwitch: UISwitch!
    
    @IBOutlet weak var fontSizeSubLabel: UILabel!
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    var settingStoryboard :UIStoryboard? = nil
    var mainViewController :UIViewController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        
        // self.clearsSelectionOnViewWillAppear = false

        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.tableFooterView = UIView()
        tableView.sectionHeaderHeight = 40
        
        settingStoryboard = UIStoryboard(name: "Main", bundle: nil)
        mainViewController = settingStoryboard!.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if userDefaults.boolForKey("sound") {
            soundSwitch.on = true
        } else {
            soundSwitch.on = false
        }
        
        if userDefaults.boolForKey("badge") {
            badgeSwitch.on = true
        } else {
            badgeSwitch.on = false
        }
        
        if userDefaults.boolForKey("showAd") {
            adSwitch.on = true
        } else {
            adSwitch.on = false
        }
        
        let fontSizeSubText = String(userDefaults.integerForKey("fontSize")) + "pt"
        fontSizeSubLabel.text = fontSizeSubText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func adChange(sender: UISwitch) {
        if sender.on {
            userDefaults.setBool(true, forKey: "showAd")
            loadView()
            viewDidLoad()
            mainViewController!.loadView()
            mainViewController!.viewWillAppear(false)
        } else {
            userDefaults.setBool(false, forKey: "showAd")
            loadView()
            viewDidLoad()
            mainViewController!.loadView()
            mainViewController!.viewWillAppear(false)
        }
    }
    
    @IBAction func soundChange(sender: UISwitch) {
        if sender.on {
            userDefaults.setBool(true, forKey: "sound")
        } else {
            userDefaults.setBool(false, forKey: "sound")
        }
    }
    
    @IBAction func badgeChange(sender: UISwitch) {
        if sender.on {
            userDefaults.setBool(true, forKey: "badge")
            let mainviewController = MainViewController()
            UIApplication.sharedApplication().applicationIconBadgeNumber = mainviewController.setBadgeValue()
        } else {
            userDefaults.setBool(false, forKey: "badge")
            UIApplication.sharedApplication().applicationIconBadgeNumber = -1
        }
    }

    // MARK: - Table view data source

    /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    */

    /*
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    */

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)

        // Configure the cell...
        cell.selectionStyle = UITableViewCellSelectionStyle.None

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let feedbackCell = NSIndexPath(forRow: 0, inSection: 3)
        if indexPath == feedbackCell {
            UIApplication.sharedApplication().openURL(NSURL(string: "mailto:kenjou@k-develop.com")!)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
