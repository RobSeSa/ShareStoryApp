//
//  SignUpViewController.swift
//  StoryShareApp
//
//  Created by Robert Sato on 4/16/20.
//  Copyright © 2020 Robert Sato. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var occupationTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements() {
        // Hide error label
        errorLabel.alpha = 0
        
        // Style the elements
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleTextField(occupationTextField)
        Utilities.styleFilledButton(signUpButton)
        
    }
    
    //Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Else, it returns the error message
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            occupationTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
                return "Please fill in all fields."
        }
        else if Utilities.isPasswordValid(passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)) == false {
            // Password isn't secure enough
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        
        
        // future = add isemailvalid conditional
        
        return nil
    }
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            // There was an error with the fields
            showError(error!)
        }
        else {
            
            // Create cleaned versions of the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let occupation = occupationTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                // Check for errors
                if err != nil {
                    // There was an error creating the user
                    self.showError("Error creating user")
                    print("err = ", err!)
                }
                else {
                    // User was created successfuly, store the first and last name
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstname":firstName, "lastname":lastName, "occupation":occupation, "uid":result!.user.uid]) { (error) in
                        if error != nil {
                            // Show error message
                            self.showError("Error saving user data")
                        }
                    }
                    // Transition to the home screen
                    self.transitionToHome()
                }
            }
        }
        
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome() {
        let homeViewController =
            storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
}
