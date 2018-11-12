//
//  QuestionTableViewCell.swift
//  smat-new
//
//  Created by Hiroshi Tamura on 2018/11/12.
//  Copyright © 2018 弘田村. All rights reserved.
//

import UIKit
import iosMath

class QuestionTableViewCell: UITableViewCell {
    @IBOutlet weak var texLabel: MTMathUILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
