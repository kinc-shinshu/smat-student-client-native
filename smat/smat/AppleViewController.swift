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
    
    // MARK: - Views
    // 問題と答えを表示するためのViewを作る
    @IBOutlet weak var questionView: MTMathUILabel!
    @IBOutlet weak var answerView: MTMathUILabel!
    
    // MARK: - Function for Buttons
    // 入力用の選択肢に関与する関数
    
    // MARK: - Buttons
    // 入力用のボタンをリンクする
    @IBOutlet weak var input1: UIButton!
    @IBOutlet weak var input2: UIButton!
    @IBOutlet weak var input3: UIButton!
    @IBOutlet weak var input4: UIButton!
    
    // 入力用のボタンのアクションを定義する
    @IBAction func inputButton1(_ sender: Any) {
        self.questionView.latex = "x1"
        self.answerView.latex = "xX1"
        self.input1.setTitle("ボタン１", for: .normal)
    }
    @IBAction func inputButton2(_ sender: Any) {
        self.questionView.latex = "x2"
        self.answerView.latex = "xX2"
        self.input2.setTitle("ボタン2", for: .normal)
    }
    @IBAction func inputButton3(_ sender: Any) {
        self.questionView.latex = "x3"
        self.answerView.latex = "xX3"
        self.input3.setTitle("ボタン3", for: .normal)
    }
    @IBAction func inputButton4(_ sender: Any) {
        self.questionView.latex = "x4"
        self.answerView.latex = "xX4"
        self.input4.setTitle("ボタン4", for: .normal)
    }
    
    // 答えをパーサーにかける
    func answerParser(answerLatex: String) -> String {
        return "x"
    }
    
    // MARK: - for get question from api
    // 部屋番号（問題一覧に戻るため）
    var examNumber: String?
    var questionNumber: Int?
    
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
    
    // 画面を表示
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the vie
        // loadQuestion(questionId: questionNumber!)
    }
    
    // 画面変移の際に部屋番号を渡している
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
