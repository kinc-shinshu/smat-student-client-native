//
//  ViewController.swift
//  smat
//
//  Created by Hiroshi Tamura on 2018/11/09.
//  Copyright © 2018 KINC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate  {

    @IBOutlet weak var testFile: UILabel!
    @IBOutlet weak var roomNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        roomNumber.becomeFirstResponder()
        roomNumber.delegate = self
        roomNumber.keyboardType = UIKeyboardType.numberPad
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "roomNumber") {
            let nav = segue.destination as! UINavigationController
            let questionList = nav.topViewController as! QuestionTableViewController
            // ViewControllerのtextVC2にメッセージを設定
            questionList.examNumber = sender as? String
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,with: string)
            if updatedText.count == 3 {
                self.performSegue(withIdentifier: "roomNumber", sender: String(updatedText))
            }
        }
        return true
    }
    
}
