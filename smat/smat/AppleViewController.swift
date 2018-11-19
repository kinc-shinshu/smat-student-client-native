//
//  AppleViewController.swift
//  smat
//
//  Created by Hiroshi Tamura on 2018/11/13.
//  Copyright © 2018 KINC. All rights reserved.
//

import UIKit
import iosMath

class AppleViewController: UIViewController {
    
    //  問題と答えを表示するためのViewを作る
    @IBOutlet weak var questionView: MTMathUILabel!
    @IBOutlet weak var AnswerView: MTMathUILabel!
    
    // 部屋番号（問題一覧に戻るため）
    var examNumber: String?
    var questionNumber: Int?
    
    // 問題を取得する関数が必要
    // let QuestionText = "x"
    // let QuestionAnswer = "x"
    
    
    //  画面を表示
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        questionView.latex = "x = \\frac{-b \\pm \\sqrt{b^2-4ac}}{2a}"
        AnswerView.latex = "x = \\frac{-b \\pm \\sqrt{b^2-4ac}}{2a}"
        print(examNumber)
        print(questionNumber)
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
