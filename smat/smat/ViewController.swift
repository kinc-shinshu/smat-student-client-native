//
//  ViewController.swift
//  smat
//
//  Created by Hiroshi Tamura on 2018/11/09.
//  Copyright © 2018 KINC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITextFieldDelegate  {

    @IBOutlet weak var testFile: UILabel!
    @IBOutlet weak var roomNumber: UITextField!
    @IBOutlet weak var questionLabel: UILabel!
    
    //  Alamofire.request(method: Method, URLString: URL)
    func getArticles() {
        Alamofire.request("https://smat-api.herokuapp.com/rooms/168/questions").responseJSON {response in
            guard let object = response.result.value else {
                return
            }
            var articles: [[String: String?]] = []
            let json = JSON(object)
            json.forEach { (_, json) in
                let article: [String: String?] = [
                    "questionText": json["text"].string,
                    "questionAnswer": json["answer"].string,
                    "questionId": json["id"].string
                ]
                articles.append(article)
                self.questionLabel.text = article["questionText"] as? String
            }
            print(articles)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        roomNumber.becomeFirstResponder()
        roomNumber.delegate = self
        roomNumber.keyboardType = UIKeyboardType.numberPad
        getArticles()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            if updatedText.count == 3 {
                print("s")
                self.performSegue(withIdentifier: "roomNumber", sender: nil)
            }
        }
        return true
    }
    
}
