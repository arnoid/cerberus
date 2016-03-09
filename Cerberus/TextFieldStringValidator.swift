//
//  TextFieldStringValidator
//  Cerberus
//
//  Created by Sergii Arnaut on 06/03/16.
//  Copyright © 2016 Sergii Arnaut. All rights reserved.
//

import Foundation

class TextFieldStringValidator {
    
    static var emailPredicate = NSPredicate(format:"SELF MATCHES %@", "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$")
    static var passwdPredicate = NSPredicate(format:"SELF MATCHES %@", "^[0-9a-zA-Z\\s]+$") //TODO: add special characters
    static var namePredicate = NSPredicate(format:"SELF MATCHES %@", "^[0-9a-zA-Z\\s]+$")

    
    struct ValidationResult {
        
        var errorMessage : String
        var isValid : Bool
        var isNotValid : Bool
        
        init(errorMessage : String, isValid: Bool) {
            self.errorMessage = errorMessage
            self.isValid = isValid
            self.isNotValid = !isValid
        }

    }
    
    static func isEmailValid(email: String!, errorMessageHandler: String! -> Void) -> Bool {
        guard email != nil && !email!.isEmpty else {
            errorMessageHandler("Email is empty")
            return false
        }
        
        guard TextFieldStringValidator.emailPredicate.evaluateWithObject(email) else {
            errorMessageHandler("Email is invalid")
            return false
        }
        
        return true
    }
    
    static func isPasswordValid(passwd: String!, errorMessageHandler: String! -> Void) -> Bool {
        //next two guard blocks are identical to isEmailValid function
        //But, because we show error message in same TextView, we need to distinguish
        //which TextFiled has error
        //Even more - field emptyness can be checked with regexp
        guard passwd != nil && !passwd!.isEmpty else {
            errorMessageHandler("Password is empty")
            return false
        }
        
        guard TextFieldStringValidator.passwdPredicate.evaluateWithObject(passwd) else {
            errorMessageHandler("Password should constain a-z A-Z 0-9 characters")
            return false
        }
        
        return true
    }
    
    static func isUserNameValid(name: String!, errorMessageHandler: String! -> Void) -> Bool {
        guard name != nil && !name!.isEmpty else {
            errorMessageHandler("Name is empty")
            return false
        }
        
        guard TextFieldStringValidator.namePredicate.evaluateWithObject(name) else {
            errorMessageHandler("Name should constain a-z A-Z 0-9 characters")
            return false
        }
        
        return true
    }
}