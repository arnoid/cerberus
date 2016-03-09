//
//  LoginViewController.swift
//  Cerberus
//
//  Created by Sergii Arnaut on 05/03/16.
//  Copyright © 2016 Sergii Arnaut. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var txtEmail : UITextField!
    @IBOutlet var txtPassword : UITextField!
    @IBOutlet var txtErrorMessage : UITextView!
    
    var userController: UserController!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userController = AppDelegate.getAppDelegate().userController
    }
    
    @IBAction func loginButtonClick() {
        txtErrorMessage.text = ""
        
        guard (TextFieldStringValidator.isEmailValid(txtEmail.text, errorMessageHandler: showErrorMessage)
                && TextFieldStringValidator.isPasswordValid(txtPassword.text, errorMessageHandler: showErrorMessage)) else {
            return
        }
        
        let user = userController.readUserWith(txtEmail.text, password: txtPassword.text) as CUser?
        
        if(user == nil) {
            showErrorMessage("No user found with given email and password")
        } else {
            AppDelegate.getAppDelegate().loggedInUser = user
            
            mimicLoading()
        }
        
    }
    
    func showErrorMessage(message: String!) -> Void  {
        txtErrorMessage.text = txtErrorMessage.text + "\n\(message)"
    }
    
    func mimicLoading() {
        //To simulate real life delay
        let popupViewController: UIAlertController = LoadingPopup.showPopup("Please wait\n\n", ownerViewController: self)
        
        let delay = 3 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue()) {
            popupViewController.dismissViewControllerAnimated(true, completion: {
                //TODO: I would specify "MainScreen" id in target ViewController
                //But in storyboard it uses generic ViewController
                self.performSegueWithIdentifier("MainScreen", sender: self)
            })
        }
        
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

