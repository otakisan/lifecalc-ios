//
//  LifeExperienceListTableViewController.swift
//  LifeCalc
//
//  Created by takashi on 2016/04/24.
//  Copyright © 2016年 Takashi Ikeda. All rights reserved.
//

import UIKit
import RealmSwift

class LifeExperienceListTableViewController: UITableViewController {
    
    var lifeExperiences : [LifeExperience] = []

    private func reloadData() {
        if let realm = try? Realm() {
            self.lifeExperiences = realm.objects(LifeExperience).sorted("startsAt", ascending: false).map{$0}
        }
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.reloadData()
        super.viewWillAppear(animated)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.lifeExperiences.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LifeExperienceListTableViewCell", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = self.lifeExperiences[indexPath.row].action
        cell.detailTextLabel?.text = "\(self.lifeExperiences[indexPath.row].startsAt.localDateString()) \(self.lifeExperiences[indexPath.row].startsAt.localTimeString()) - \(self.lifeExperiences[indexPath.row].endsAt.localDateString()) \(self.lifeExperiences[indexPath.row].endsAt.localTimeString())"

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let removing = self.lifeExperiences.removeAtIndex(indexPath.row)
            let _ = try? removing.realm?.write({
                removing.realm?.delete(removing)
            })
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let vc = segue.destinationViewController as? LifeExperienceSimpleEditorViewController {
            if segue.identifier == "showPlainEditorForEditingSegue", let indexPath = self.tableView.indexPathForSelectedRow {
                vc.lifeExperience = self.lifeExperiences[indexPath.row]
            }
        }
    }
    

}
