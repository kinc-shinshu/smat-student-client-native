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
                goToNext()
            }
        }
        return true
    }
    
    func goToNext() {
        let storyboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "roomNumber")
        self.present(nextView, animated: true, completion: nil)
    }
    
}
