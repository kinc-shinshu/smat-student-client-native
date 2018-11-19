//
//  AppleViewController.swift
//  smat
//
//  Created by Hiroshi Tamura on 2018/11/13.
//  Copyright © 2018 KINC. All rights reserved.
//

import UIKit
import iosMath
import Alamofire
import SwiftyJSON

class AppleViewController: UIViewController {
    
    //  問題と答えを表示するためのViewを作る
    @IBOutlet weak var questionView: MTMathUILabel!
    @IBOutlet weak var answerView: MTMathUILabel!
    
    // 部屋番号（問題一覧に戻るため）
    var examNumber: String?
    var questionNumber: Int?
    
    // 答えをパーサーにかける
    func answerParser(answerLatex: String) -> String {
        return "x"
    }
    
    // 問題を取得する関数
    func loadQuestion(questionId: Int) {
        Alamofire.request("https://smat-api.herokuapp.com/rooms/" + examNumber! + "/questions/" + String(questionId)).responseJSON {response in
            guard let object = response.result.value else {
                return
            }
            
            let json = JSON(object)
            json.forEach { (_, json) in
                self.questionView.latex = json["latex"].string
                self.answerView.latex = json["ans_latex"].string
                
            }
        }
    }
            
    // let QuestionText = "x"
    // let QuestionAnswer = "x"
    
    
    //  画面を表示
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the vie
        loadQuestion(questionId: questionNumber!)
    }
    
    //  画面変移の際に部屋番号を渡している
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailToList") {
            let nav = segue.destination as! UINavigationController
            let questionList = nav.topViewController as! QuestionTableViewController
            questionList.examNumber = self.examNumber
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
