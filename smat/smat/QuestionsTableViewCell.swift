//
//  QuestionsTableViewCell.swift
//  smat
//
//  Created by Hiroshi Tamura on 2018/11/12.
//  Copyright © 2018 KINC. All rights reserved.
//

import UIKit
import iosMath

class QuestionsTableViewCell: UITableViewCell{
    
    // セルごとにテフ文のスペースを作る
    @IBOutlet weak var texLabel: MTMathUILabel!
    @IBOutlet weak var tfView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
