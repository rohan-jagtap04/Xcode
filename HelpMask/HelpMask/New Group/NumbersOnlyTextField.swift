//
//  NumbersOnlyTextField.swift
//  HelpMask
//
//  Created by Rohan Jagtap on 2020-03-29.
//  Copyright © 2020 Rohan Jagtap. All rights reserved.
//

import UIKit

class NumbersOnlyTextField: UITextField {
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
      let allowedCharacters = CharacterSet.decimalDigits
      let characterSet = CharacterSet(charactersIn: string)
      return allowedCharacters.isSuperset(of: characterSet)
    }

    
}
