# Local-Notification

```swift
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let tintColor = UIColor(red: 252/255, green: 72/255, blue: 49/255, alpha: 1)
        window!.tintColor = tintColor
        
        // 1. Register to use a local notification
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Badge, .Alert, .Sound], categories: nil)
        
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        
        // 2. Ask user for permission to use notification or not
        self.createLocalNotification()
        
        return true
    }
    
     // 3. Create / schedule local notification
    func createLocalNotification()
    {
        let localNotitication = UILocalNotification()
        
        // this means 10 seconds after now
        localNotitication.fireDate = NSDate(timeIntervalSinceNow: 10)
        
        // Here we can create a counter of the amount of notitications
        localNotitication.applicationIconBadgeNumber = 1

        localNotitication.soundName = UILocalNotificationDefaultSoundName
        
        localNotitication.userInfo = [
            "message" : "check out our new courses!"
        ]
        
        localNotitication.alertBody = "Check out our new iOS tutorials!"
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotitication)
    }
    
    // 5
    // when the user clicks on the noti, this method gets called
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {

        if application.applicationState == .Active {
            //This means we are inside the app so we can do something here
        }
        
        //Otherwhise the user is outside the app and our app is in background
        self.takeActionWithNotification(notification)
    }
    
    // 6
    func takeActionWithNotification(localNotification: UILocalNotification)
    {
        let notificationMessage = localNotification.userInfo!["message"] as! String

        // This is a static userName but we can do it dinamic in a real app
        let username = "Jorge"
        
        let alertController = UIAlertController(title: "Hey \(username)", message: notificationMessage, preferredStyle: .Alert)
        
        //Actions for our alert
        let remindMeLaterAction = UIAlertAction(title: "Remind me later", style: .Default, handler: nil)
        let sureAction = UIAlertAction(title: "Sure", style: .Default) { (action) -> Void in
            let tabBarController = self.window?.rootViewController as! UITabBarController
            
            //We select the first button of our tabBar to show to the user when click the action
            tabBarController.selectedIndex = 0
        }
        
        alertController.addAction(remindMeLaterAction)
        alertController.addAction(sureAction)
        
        self.window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
        
        
    }

```
