//
//  ViewController.swift
//  smat
//
//  Created by Hiroshi Tamura on 2018/11/09.
//  Copyright © 2018 KINC. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITextFieldDelegate  {

    @IBOutlet weak var roomNumber: UITextField!
    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        roomNumber.becomeFirstResponder()
        roomNumber.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.count == 3 {
            print("s")
            return true
        } else {
            print("ss")
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        testLabel.text = textField.text
    }
    @IBAction func roomButton(_ sender: UIButton) {
        testLabel.text = "textField.text"
    }
    
}
