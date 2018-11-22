//
//  FinishViewController.swift
//  smat
//
//  Created by Hiroshi Tamura on 2018/11/23.
//  Copyright © 2018 KINC. All rights reserved.
//

import UIKit

class FinishViewController: UIViewController {
    @IBOutlet weak var scoreLabel: UILabel!
    
    var trueSum: Int?
    var questionsSum: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scoreLabel.textColor = UIColor(red: 52/255, green: 166/255, blue: 154/255, alpha: 1)
        scoreLabel.text = "結果:" + String(trueSum!) + "/" + String(questionsSum!)
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
