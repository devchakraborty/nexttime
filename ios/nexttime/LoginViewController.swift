//
//  LoginViewController.swift
//  nexttime
//
//  Created by Dev Chakraborty on 2015-11-07.
//  Copyright © 2015 NextTime. All rights reserved.
//

import UIKit

import FBSDKShareKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = UIButton()
        loginButton.backgroundColor = UIColor.darkGrayColor()
        loginButton.frame = CGRectMake(0, 0, 180, 40)
        loginButton.center = self.view.center
        loginButton.setTitle("Login with Facebook", forState: UIControlState.Normal)
        loginButton.addTarget(self, action: "loginButtonClicked", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(loginButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButtonClicked() {
        let login: FBSDKLoginManager = FBSDKLoginManager()
        login.logInWithReadPermissions(["user_friends"], fromViewController: self,
            handler: {(result: FBSDKLoginManagerLoginResult!, error:NSError!)-> Void in
                if (error != nil) {
                    print(error)
                }else if (result.isCancelled) {
                    print("Couldn't log in")
                } else {
                    //TODO: Post to login
                    let request = FBSDKGraphRequest.init(graphPath: "me/friends",
                        parameters: nil,
                        HTTPMethod: "GET")
                    
                    request.startWithCompletionHandler({ (connection:FBSDKGraphRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
                        if(error != nil){
                            print(error)
                        }else{
                            print(result)
                        }
                    })
                }
        })
        
        self.performSegueWithIdentifier("enterApp", sender: self)
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
