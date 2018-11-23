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
import Foundation
import Material

class AppleViewController: UIViewController {
    
    // MARK: - Views
    // 問題と答えを表示するためのViewを作る
    @IBOutlet weak var questionView: MTMathUILabel!
    @IBOutlet weak var answerView: MTMathUILabel!
    @IBOutlet weak var tfLabel: UILabel!
    
    // 結果表示用のもの
    let trueText = "正解です！"
    let falseText = "残念..."
    
    // 入力された結果を格納するための変数
    var inputText = ""
    var inputTextNumber = 0
    var answerLatex = ""
    var tryNumber = 0
    
    // 答えをパーサーにかけるために
    func ansify(texAnswer: String) -> String {
        let result = texAnswer.pregReplace(pattern: "/[0-9a-w]+/g", with: "\\boxed{\\phantom{0}}")
        return result
    }
    
    // MARK: - Function for Buttons
    // 入力用の選択肢に関与する関数
    // 答えをパーサーにかける
    func makeAnswer(answerLatex: String) -> String {
        return answerLatex.pregReplace(pattern: "[0-9]", with: "\\\\square ")
    }
    
    // 答えを取り出す
    func getAnswer(answerLatex: String) -> String {
        return answerLatex.pregReplace(pattern: "[^0-9]+", with: "")
    }
    
    // 答えを一つずつ代入する関数
    func makeAnswerBetter(nowAnswer: String, inputAnswer: String) {
        let now = nowAnswer
        var newAnswer = ""
        if let range = now.range(of: "?") {
            newAnswer = now.replacingCharacters(in: range, with: inputAnswer)
        } else {
            newAnswer = now
        }
        self.answerView.latex = newAnswer
    }
    
    // ？をつける
    func makeNowInput(nowAnswer: String) {
        let now = nowAnswer
        var newAnswer = ""
        if let range = now.range(of: "\\square ") {
            newAnswer = now.replacingCharacters(in: range, with: "?")
        } else {
            newAnswer = now
        }
        self.answerView.latex = newAnswer
    }
    
    // 答えから選択肢を生成する関数
    func getSelection(parserAnswer: String) -> [[String]] {
        var selections = [[String]]()
        for ans in parserAnswer {
            var selection = [String]()
            selection += [String(ans)]
            for _ in 0..<3 {
                var random = String(arc4random_uniform(10))
                while (selection.index(of:random) != nil) {
                    random = String(arc4random_uniform(10))
                }
                selection += [random]
            }
            selection.sort()
            selections += [selection]
        }
        return selections
    }
    
    // MARK for result api
    func saveResult(j: Int) {
        self.questionResultC![self.questionNumber! - 1] += 1
        self.questionResultJ![self.questionNumber! - 1] = j
    }
    
    // 正解を判別する関数
    func isTF(inputAnswer: String, trueAnswer: String, tryNumber: Int) {
        if (inputAnswer == trueAnswer && tryNumber >= 0) {
            self.saveResult(j: 1)
            self.tfLabel.text = self.trueText
            self.tfLabel.textColor = UIColor(red: 62/255, green: 166/255, blue: 154/255, alpha: 1)
            self.tfLabel.isHidden = false
        } else if (inputAnswer != trueAnswer && tryNumber >= 0) {
            self.saveResult(j: 0)
            self.tfLabel.text = self.falseText
            self.tfLabel.textColor = UIColor(red: 238/255, green: 111/255, blue: 115/255, alpha: 1)
            self.tfLabel.isHidden = false
        }
    }
    
    
    // MARK: - Input Buttons
    // 入力用のボタンをリンクする
    @IBOutlet weak var input1: RaisedButton!
    @IBOutlet weak var input2: RaisedButton!
    @IBOutlet weak var input3: RaisedButton!
    @IBOutlet weak var input4: RaisedButton!
    
    // 入力用のボタンのテキストを変更する関数
    func setInputButtons(nowInputTextNumber: Int){
        let forSetInputText = self.getSelection(parserAnswer: self.answerLatex)
        if (forSetInputText.count == self.inputTextNumber) {
            self.isTF(inputAnswer: self.inputText, trueAnswer: self.answerLatex, tryNumber: self.tryNumber)
            self.goToNextBackFunc()
        } else {
            self.input1.setTitle(forSetInputText[nowInputTextNumber][0], for: .normal)
            self.input2.setTitle(forSetInputText[nowInputTextNumber][1], for: .normal)
            self.input3.setTitle(forSetInputText[nowInputTextNumber][2], for: .normal)
            self.input4.setTitle(forSetInputText[nowInputTextNumber][3], for: .normal)
        }
    }
    
    // 入力を記録する関数
    func saveInput(input: String) {
        return self.inputText += input
    }
    
    // 入力用のボタンのアクションを定義する
    @IBAction func inputButton1(_ sender: Any) {
        saveInput(input: self.input1.currentTitle!)
        self.makeNowInput(nowAnswer: self.answerView.latex!)
        self.makeAnswerBetter(nowAnswer: self.answerView.latex!, inputAnswer: self.input1.currentTitle!)
        self.inputTextNumber += 1
        self.setInputButtons(nowInputTextNumber: self.inputTextNumber)
    }
    @IBAction func inputButton2(_ sender: Any) {
        saveInput(input: self.input2.currentTitle!)
        self.makeNowInput(nowAnswer: self.answerView.latex!)
        self.makeAnswerBetter(nowAnswer: self.answerView.latex!, inputAnswer: self.input2.currentTitle!)
        self.inputTextNumber += 1
        self.setInputButtons(nowInputTextNumber: self.inputTextNumber)
    }
    @IBAction func inputButton3(_ sender: Any) {
        saveInput(input: self.input3.currentTitle!)
        self.makeNowInput(nowAnswer: self.answerView.latex!)
        self.makeAnswerBetter(nowAnswer: self.answerView.latex!, inputAnswer: self.input3.currentTitle!)
        self.inputTextNumber += 1
        self.setInputButtons(nowInputTextNumber: self.inputTextNumber)
    }
    @IBAction func inputButton4(_ sender: Any) {
        saveInput(input: self.input4.currentTitle!)
        self.makeNowInput(nowAnswer: self.answerView.latex!)
        self.makeAnswerBetter(nowAnswer: self.answerView.latex!, inputAnswer: self.input4.currentTitle!)
        self.inputTextNumber += 1
        self.setInputButtons(nowInputTextNumber: self.inputTextNumber)
    }
    
    // MARK: - next back question buttons
    // 前後の問題に移動するボタン
    @IBOutlet weak var nextButton: RaisedButton!
    @IBOutlet weak var backButton: RaisedButton!
    
    // 前後の問題に移動する関数
    @IBAction func nextButtonAction(_ sender: Any) {
    }
    @IBAction func backButtonAction(_ sender: Any) {
    }
    
    // 前後の問題に移動するボタンを表示するかどうかを決める関数
    func goToNextBackFunc() {
        self.input1.isHidden = true
        self.input2.isHidden = true
        self.input3.isHidden = true
        self.input4.isHidden = true
        if (self.questionNumber! > 1 && self.questionSumNumber != questionNumber){
            self.nextButton.isHidden = false
            self.backButton.isHidden = false
        } else if (self.questionNumber! > 1 && self.questionSumNumber == questionNumber){
            self.backButton.isHidden = false
        } else if (self.questionNumber! == 1){
            self.nextButton.isHidden = false
        }
    }
    
    
    // MARK: - for get question from api
    // 部屋番号（問題一覧に戻るため）
    var examNumber: String?
    var questionNumber: Int?
    var questionSumNumber: Int?
    var questionResultC: [Int]?
    var questionResultJ: [Int]?
    var questionResultQid: [Int]?
    var questions:[Question]? = []
    
    // 問題を取得する関数(Api)
    func loadQuestion(questionId: Int){
        Alamofire.request("https://smat-api-dev.herokuapp.com/v1/rooms/" + examNumber! + "/questions/" + String(questionId)).responseJSON {response in
            guard let object = response.result.value else {
                return
            }
            let json = JSON(object)
            self.questionView.latex = json["latex"].string
            self.questionView.textAlignment = .center
            self.questionView.sizeToFit()
            let ansLatex = json["ans_latex"].string
            self.answerView.latex = self.makeAnswer(answerLatex: ansLatex!)
            self.answerView.textAlignment = .center
            self.answerView.sizeToFit()
            self.answerLatex = self.getAnswer(answerLatex: ansLatex!)
            self.setInputButtons(nowInputTextNumber: self.inputTextNumber)
            self.makeNowInput(nowAnswer: self.answerView.latex!)
        }
    }
    
    // 問題を取得する関数(ローカル)
    func loadLocalQuestion(questionId: Int){
        self.questionSumNumber = self.questions?.count
        let question = self.questions![questionId - 1]
        self.questionView.latex = question.questionLatex
        self.questionView.textAlignment = .center
        self.questionView.sizeToFit()
        let ansLatex = question.questionAnsLatex
        self.answerView.latex = self.makeAnswer(answerLatex: ansLatex)
        self.answerView.textAlignment = .center
        self.answerView.sizeToFit()
        self.answerLatex = self.getAnswer(answerLatex: ansLatex)
        self.setInputButtons(nowInputTextNumber: self.inputTextNumber)
        self.makeNowInput(nowAnswer: self.answerView.latex!)
    }
    
    
    // 画面を表示
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the vie
        // loadQuestion(questionId: questionNumber!)
        self.navigationItem.title = "問題" + String(self.questionNumber!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadLocalQuestion(questionId: self.questionNumber!)
    }
    
    // 画面変移の際に部屋番号と諸々を渡している
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailToList") {
            let nav = segue.destination as! UINavigationController
            let questionList = nav.topViewController as! QuestionTableViewController
            questionList.examNumber = self.examNumber
            questionList.questionGetDone = 1
            questionList.resultJ = self.questionResultJ!
            questionList.resultC = self.questionResultC!
            questionList.resultQid = self.questionResultQid!
            questionList.questions = self.questions!
        }
        
        if (segue.identifier == "nextQuestion") {
            let nav = segue.destination as! UINavigationController
            let questionList = nav.topViewController as! AppleViewController
            questionList.examNumber = self.examNumber
            questionList.questionNumber = self.questionNumber! + 1
            questionList.questionResultJ = self.questionResultJ
            questionList.questionResultC = self.questionResultC
            questionList.questionResultQid = self.questionResultQid
            questionList.questions = self.questions
        }
        
        if (segue.identifier == "backQuestion") {
            let nav = segue.destination as! UINavigationController
            let questionList = nav.topViewController as! AppleViewController
            questionList.examNumber = self.examNumber
            if (self.questionNumber! > 1) {
                questionList.questionNumber = self.questionNumber! - 1
            } else {
                questionList.questionNumber = 1
            }
            questionList.questionResultJ = self.questionResultJ
            questionList.questionResultC = self.questionResultC
            questionList.questionResultQid = self.questionResultQid
            questionList.questions = self.questions
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

// 正規表現用に拡張
// https://qiita.com/KikurageChan/items/807e84e3fa68bb9c4de6
extension String {
    //絵文字など(2文字分)も含めた文字数を返します
    var length: Int {
        let string_NS = self as NSString
        return string_NS.length
    }
    
    //正規表現の検索をします
    func pregMatche(pattern: String, options: NSRegularExpression.Options = []) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
            return false
        }
        let matches = regex.matches(in: self, options: [], range: NSMakeRange(0, self.length))
        return matches.count > 0
    }
    
    //正規表現の検索結果を利用できます
    func pregMatche(pattern: String, options: NSRegularExpression.Options = [], matches: inout [String]) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
            return false
        }
        let targetStringRange = NSRange(location: 0, length: self.length)
        let results = regex.matches(in: self, options: [], range: targetStringRange)
        for i in 0 ..< results.count {
            for j in 0 ..< results[i].numberOfRanges {
                let range = results[i].range(at: j)
                matches.append((self as NSString).substring(with: range))
            }
        }
        return results.count > 0
    }
    
    //正規表現の置換をします
    func pregReplace(pattern: String, with: String, options: NSRegularExpression.Options = []) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self, options: [], range: NSMakeRange(0, self.length), withTemplate: with)
    }
}
