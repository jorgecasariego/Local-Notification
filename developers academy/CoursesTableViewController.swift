//
//  CoursesTableViewController.swift
//  Developers Academy
//
//  Created by Duc Tran on 11/27/15.
//  Copyright © 2015 Developers Academy. All rights reserved.
//

import UIKit
import SafariServices       // for SFSafariViewController
import LocalAuthentication  // for touch id authentication
import Social               // for facebook and twitter sharing

class CoursesTableViewController: UITableViewController
{
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var programs: [Program] = [Program.TotalIOSBlueprint(), Program.SocializeYourApps()]
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make the row height dynamic
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    
        displayWalkthroughs()
        
        // burger side bar menu
    }
    
    func displayWalkthroughs()
    {
        // Create the walkthrough screens
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let displayedWalkthrough = userDefaults.boolForKey("DisplayedWalkthrough")
        if !displayedWalkthrough {
            if let pageViewController = storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as? PageViewController {
                self.presentViewController(pageViewController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return programs.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return programs[section].courses.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Course Cell", forIndexPath: indexPath) as! CourseTableViewCell
        
        let program = programs[indexPath.section]
        let courses = program.courses
        cell.course = courses[indexPath.row]
        
        return cell
    }
    
    // MARK: - Social Sharing
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
        let course = self.programs[indexPath.section].courses[indexPath.row]
        
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Share") { (rowAction, indexPath) -> Void in
            
            let shareActionSheet = UIAlertController(title: nil, message: "Share with", preferredStyle: .ActionSheet)
            
            let twitterShareAction = UIAlertAction(title: "Twitter", style: .Default, handler: { (action) -> Void in
                // display the twitter composer
                if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
                    let tweetComposer = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                    tweetComposer.setInitialText(course.description)
                    tweetComposer.addImage(course.image)
                    
                    self.presentViewController(tweetComposer, animated: true, completion: nil)
                } else {
                    self.alert("Twitter Unavailable", msg: "Be sure to go to Settings > Twitter to set up your Twitter account")
                }
            })
            
            let facebookShareAction = UIAlertAction(title: "Facebook", style: .Default, handler: { (action) -> Void in
                // display the twitter composer
                if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
                    let facebookComposer = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                    facebookComposer.setInitialText(course.program)
                    facebookComposer.addImage(course.image)
                    facebookComposer.addURL(NSURL(string: course.programURL)!)
                    
                    self.presentViewController(facebookComposer, animated: true, completion: nil)
                } else {
                    self.alert("Facebook Unavailable", msg: "Be sure to go to Settings > Facebook to set up your Facebook account")
                }
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            
             shareActionSheet.addAction(twitterShareAction)
            shareActionSheet.addAction(facebookShareAction)
            shareActionSheet.addAction(cancelAction)
            
            self.presentViewController(shareActionSheet, animated: true, completion: nil)
        }
        
        shareAction.backgroundColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        
        return [shareAction]
    }
    
    func alert(title: String, msg: String)
    {
        let alertVC = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))

        self.presentViewController(alertVC, animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let program = programs[indexPath.section]
        let courses = program.courses
        let selectedCourse = courses[indexPath.row]
        
        self.performSegueWithIdentifier("Show Course Detail", sender: selectedCourse)
    }
    
    // MARK: - Show Webpage with SFSafariViewController
    
    func showWebsite(url: String)
    {
        let webVC = SFSafariViewController(URL: NSURL(string: url)!)
        webVC.delegate = self
        
        self.presentViewController(webVC, animated: true, completion: nil)
    }
    
    // MARK: - Target / Action
    
    @IBAction func signupClicked(sender: AnyObject)
    {
        self.tabBarController?.selectedIndex = 2
    }
    
    @IBAction func loginClicked(sender: AnyObject)
    {
        authenticateUsingTouchID()
    }
    
    // MARK: - Touch ID authentication
    
    func authenticateUsingTouchID()
    {
        let authContext = LAContext()
        let authReason = "Please use Touch ID to sign in Developers Academy"
        var authError: NSError?
        
        if authContext.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &authError) {
            authContext.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: authReason, reply: { (success, error) -> Void in
                if success {
                    print("successfully authenticated")
                    // this is on a private queue off the main queue (asynchronously), if we want to do UI code, we must get back to the main queue
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tabBarController?.selectedIndex = 2    // go to the programs tab or sign in in your app
                    })
                } else {
                    if let error = error {
                        // again, this is off the main queue. need to back to the main queue to do ui code
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.reportTouchIDError(error)
                            // it's best to show other method to login (enter user name and password)
                        })
                    }
                }
            })
        } else {
            // device doesn't support touch id 
            print(authError?.localizedDescription)
            
            // show other methods to login
        }
    }
    
    func reportTouchIDError(error: NSError)
    {
        switch error.code {
        case LAError.AuthenticationFailed.rawValue:
            print("Authentication failed")
        case LAError.PasscodeNotSet.rawValue:
            print("passcode not set")
        case LAError.SystemCancel.rawValue:
            print("authentication was canceled by the system")
        case LAError.UserCancel.rawValue:
            print("user cancel auth")
        case LAError.TouchIDNotEnrolled.rawValue:
            print("user hasn't enrolled any finger with touch id")
        case LAError.TouchIDNotAvailable.rawValue:
            print("touch id is not available")
        case LAError.UserFallback.rawValue:
            print("user tapped enter password")
        default:
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Show Course Detail" {
            let courseDetailTVC = segue.destinationViewController as! CourseDetailTableViewController
            courseDetailTVC.course = sender as! Course
        }
    }
}

extension CoursesTableViewController : SFSafariViewControllerDelegate
{
    func safariViewControllerDidFinish(controller: SFSafariViewController)
    {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}












