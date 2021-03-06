//
//  ListViewController.swift
//  nexttime
//
//  Created by Dev Chakraborty on 2015-11-07.
//  Copyright © 2015 NextTime. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {

    var reminders:[Reminder] = []
    
    override func viewDidLoad() {
        reminders = ReminderClient.sharedClient().getAllReminders()
        self.title = "All Reminders"
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didResume:", name: UIApplicationWillEnterForegroundNotification, object: nil)
        
        self.tableView.allowsMultipleSelectionDuringEditing = false
    }
    
    func didResume(notif:NSNotification) {
        reminders = ReminderClient.sharedClient().getAllReminders()
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reminders = ReminderClient.sharedClient().getAllReminders()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ListViewCell = tableView.dequeueReusableCellWithIdentifier("ListCell", forIndexPath: indexPath) as! ListViewCell
        
        let reminder:Reminder = reminders[indexPath.row]
        
        cell.contextLabel?.text = reminder.type + " " + reminder.specifier
        
        cell.reminderLabel?.text = reminder.reminderBody
        
        cell.tag = indexPath.row

        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let reminder = reminders[indexPath.row]
            ReminderClient.sharedClient().completeReminder(reminder.id)
            reminders = ReminderClient.sharedClient().getAllReminders()
            self.tableView.reloadData()
        }
    }

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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != nil && segue.identifier! == "toSingleUpdate" {
            let cell = sender as? UITableViewCell
            if cell != nil {
                print("UPDATE")
                let controller = segue.destinationViewController as! SingleViewController
                let reminder = reminders[cell!.tag]
                controller.updateId = reminder.id
                controller.defaultSegment = reminder.type
                controller.defaultSpecifierText = reminder.specifier
                controller.defaultReminderBodyText = reminder.reminderBody
                if reminder.type == "near" {
                    controller.selectedPlace = Place(placeName: reminder.specifier, placeId: reminder.reminderBody)
                }
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    @IBAction func doLogout(sender:AnyObject) {
        //TODO: Logout
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
