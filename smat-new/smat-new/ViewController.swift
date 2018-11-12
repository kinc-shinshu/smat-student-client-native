//
//  ViewController.swift
//  smat-new
//
//  Created by Hiroshi Tamura on 2018/11/12.
//  Copyright © 2018 弘田村. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var roomNumber: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        roomNumber.becomeFirstResponder()
        roomNumber.delegate = self
        roomNumber.keyboardType = UIKeyboardType.numberPad
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            if updatedText.count == 3 {
                print("s")
                //self.performSegue(withIdentifier: "roomNumber", sender: nil)
            }
        }
        return true
    }

}

