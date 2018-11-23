//
//  QuestionTableViewController.swift
//  
//
//  Created by Hiroshi Tamura on 2018/11/12.
//

import UIKit
import iosMath
import Alamofire
import SwiftyJSON
import Material
import FontAwesome_swift

class QuestionTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // 問題一覧を定義（独自クラスQuestion）
    var questions = [Question]()
    var questionsSumNumber = 0
    var questionGetDone = 0
    
    // 結果を作る
    var resultQid = [Int]()
    var resultC = [Int]()
    var resultJ = [Int]()
    
    // 試験番号（Api叩くに必要）
    @IBOutlet var tableView: UITableView!
    
    // 結果をAPIサーバーに投げる関数
    func postResult() {
        // ここで結果をサーバーに投げる
        var strResultQid = [String]()
        var strResultC = [String]()
        var strResultJ = [String]()
        for i in self.resultQid {
            strResultQid.append(String(i))
        }
        for i in self.resultC {
            strResultC.append(String(i))
        }
        for i in self.resultJ {
            strResultJ.append(String(i))
        }
        let URL = "https://smat-api-dev.herokuapp.com/v1/results"
        let paramData = [
            "q_id": strResultQid.joined(separator: ","),
            "j": strResultJ.joined(separator: ","),
            "c": strResultC.joined(separator: ","),
        ]
        Alamofire.request(URL, method: .post, parameters: paramData, encoding: JSONEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 完成ボタンを追加
    @IBOutlet weak var finishButton: RaisedButton!
    @IBAction func postFinish(_ sender: UIButton) {
        postResult()
    }
    
    var examNumber:String?
    var questionNumber:Int?
    
    //  Apiを叩いて問題一覧を取得する
    func loadQuestions() {
        if (self.questionGetDone == 0) {
            Alamofire.request("https://smat-api-dev.herokuapp.com/v1/rooms/" + examNumber! + "/questions").responseJSON {response in
                guard let object = response.result.value else {
                    return
                }
                
                let json = JSON(object)
                json.forEach { (_, json) in
                    let questionT = json["latex"].string
                    let questionAnsT = json["ans_latex"].string
                    let questionI = json["id"].int
                    guard let question = Question(questionLatex: questionT!, questionAnsLatex: questionAnsT!) else {
                        fatalError("Unable to instantiate questionT")
                    }
                    self.questions += [question]
                    self.resultQid.append(questionI!)
                    self.resultC.append(0)
                    self.resultJ.append(-1)
                }
                self.tableView.reloadData()
                self.finishButton.isHidden = false
            }
            self.questionGetDone = 1
        } else {
            self.finishButton.isHidden = false
        }
    }
    
    //  問題詳細に移動する際に部屋番号と諸々を渡している
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "forTest") {
            let nav = segue.destination as! UINavigationController
            let questionList = nav.topViewController as! AppleViewController
            questionList.examNumber = self.examNumber
            questionList.questionNumber = sender as? Int
            questionList.questionResultQid = self.resultQid
            questionList.questionResultJ = self.resultJ
            questionList.questionResultC = self.resultC
            questionList.questions = self.questions
        }
        
        if (segue.identifier == "finished") {
            let nav = segue.destination as! UINavigationController
            let questionList = nav.topViewController as! FinishViewController
            questionList.questionsSum = self.resultQid.count
            let filterBiggerThan0 = {
                (a: Int) -> Bool in a >= 0
            }
            let plus = { (a: Int, b: Int) -> Int in a + b }
            let biggerThan0resultJ = self.resultJ.filter(filterBiggerThan0)
            questionList.trueSum = biggerThan0resultJ.reduce(0, plus) + 0
        }
        
    }
    
    //  画面を表示している
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        loadQuestions()
        
    }

    // MARK: - Table view data source
    // TableView利用する際の決まり文句
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    // セルごとを定義している、これも決まり文句
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "QuestionsTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? QuestionsTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let question = questions[indexPath.row]
        
        //cell.texLabel.latex = question.questionText
        cell.texLabel?.latex = question.questionLatex
        cell.tfView.font = UIFont.fontAwesome(ofSize: 34, style: .brands)
        cell.tfView.text = String.fontAwesomeIcon(name: .github)
        
        return cell
    }
    
    func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
        self.questionNumber = indexPath.row
        self.performSegue(withIdentifier: "forTest", sender: indexPath.row + 1)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
