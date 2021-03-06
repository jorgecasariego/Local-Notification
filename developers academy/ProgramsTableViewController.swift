//
//  ProgramsTableViewController.swift
//  Developers Academy
//
//  Created by Duc Tran on 11/27/15.
//  Copyright © 2015 Developers Academy. All rights reserved.
//

import UIKit
import SafariServices

class ProgramsTableViewController: UITableViewController
{

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var programs: [Program] = [Program.TotalIOSBlueprint(), Program.SocializeYourApps()]
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make the row height dynamic
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // burger side bar menu
        
    }
    
    // MARK: - UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return programs.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Course Cell", forIndexPath: indexPath) as! CourseTableViewCell
        
        let program = programs[indexPath.row]
        let mockCourse = Course(title: program.title, description: program.description, image: program.image!, programURL: program.url, program: program.title)
        cell.course = mockCourse
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let program = programs[indexPath.row]
        self.performSegueWithIdentifier("Show Program Courses", sender: program)
    }
    
    // MARK: - Show Webpage with SFSafariViewController
    
    func showWebsite(url: String)
    {
        let webVC = SFSafariViewController(URL: NSURL(string: url)!)
        webVC.delegate = self
        
        self.presentViewController(webVC, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Show Program Courses" {
            let coursesTVC = segue.destinationViewController as! CoursesTableViewController
            coursesTVC.programs = [sender as! Program]
        }
    }
}

extension ProgramsTableViewController : SFSafariViewControllerDelegate
{
    func safariViewControllerDidFinish(controller: SFSafariViewController)
    {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
