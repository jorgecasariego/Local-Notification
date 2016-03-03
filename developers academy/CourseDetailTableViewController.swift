//
//  CourseDetailTableViewController.swift
//  HamburgerMenu
//
//  Created by Duc Tran on 12/24/15.
//  Copyright © 2015 Developers Academy. All rights reserved.
//

// Since in this class, we use a static table view, we don't have to implement data source methods

import UIKit
import SafariServices

class CourseDetailTableViewController: UITableViewController
{
    var course: Course! // data source
    
    @IBOutlet weak var programTextLabel: UILabel!
    @IBOutlet weak var courseImageView: UIImageView!
    @IBOutlet weak var courseTitleTextLabel: UILabel!
    @IBOutlet weak var courseDescriptionTextLabel: UILabel!
    @IBOutlet weak var watchProgramVideoButton: UIButton!
    @IBOutlet weak var enrollInProgramButton: UIButton!
    @IBOutlet weak var enrollBarButtonItem: UIBarButtonItem!
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Course Info"
        
        self.navigationItem.rightBarButtonItem = enrollBarButtonItem
        
        self.updateUI()
    }
    
    private func updateUI()
    {
        self.programTextLabel.text = course.program
        self.courseImageView.image = course.image
        self.courseTitleTextLabel.text = course.title
        self.courseDescriptionTextLabel.text = course.description
        self.watchProgramVideoButton.setTitle("Watch \(course.program) video", forState: .Normal)
        self.enrollInProgramButton.setTitle("Enroll in \(course.program)", forState: .Normal)
    }
    
    // MARK: - Target / Action
    
    @IBAction func enrollDidClick(sender: AnyObject)
    {
        self.showWebsite(course.programURL)
    }
    
    @IBAction func watchVideoDidClick(sender: AnyObject)
    {

    }
    
    @IBAction func shareWithFriends(sender: AnyObject)
    {
        showActivityController()
    }
    
    func showActivityController()
    {
        if let image = course.image {
            let imagesToShare = [image]
            let activityController = UIActivityViewController(activityItems: imagesToShare, applicationActivities: nil)
            
            // optional
            let excludedActivities = [UIActivityTypePostToFlickr, UIActivityTypePostToWeibo, UIActivityTypeMessage, UIActivityTypeMail, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo]
            activityController.excludedActivityTypes = excludedActivities
            
            
            presentViewController(activityController, animated: true, completion: nil)
        }
    }

    
    // MARK: - Show Webpage with SFSafariViewController
    
    func showWebsite(URLString: String)
    {
        let webVC = SFSafariViewController(URL: NSURL(string: URLString)!)
        webVC.delegate = self
        
        self.presentViewController(webVC, animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDatasource
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        var rowHeight = self.tableView.rowHeight
        
        // in the first section and the first row
        if indexPath.section == 0 && indexPath.row == 0 {
            rowHeight = UITableViewAutomaticDimension
        }
        
        return rowHeight
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
    }
    
    // MARK: - Navigation
    
    private struct Storyboard {
        static let showYoutubeSegue = "Show Youtube Player"
    }
    
    private let sampleVideoString = "https://youtu.be/PFIAf8wqCe0"
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Storyboard.showYoutubeSegue {
            let youtubePlayerViewController = segue.destinationViewController as! YoutubePlayerViewController
            youtubePlayerViewController.videoURL = NSURL(string: sampleVideoString)!
        }
    }
}

extension CourseDetailTableViewController : SFSafariViewControllerDelegate
{
    func safariViewControllerDidFinish(controller: SFSafariViewController)
    {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}


















