//
//  Question.swift
//  smat-new
//
//  Created by Hiroshi Tamura on 2018/11/12.
//  Copyright © 2018 弘田村. All rights reserved.
//

import UIKit

class Question {
    //MARK: Properties
    var questionLatex: String
    var questionAnsLatex: String
    
    init?( questionLatex: String, questionAnsLatex: String) {
        
        guard !questionLatex.isEmpty else {
            return nil
        }
        
        guard !questionAnsLatex.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.questionLatex = questionLatex
        self.questionAnsLatex = questionAnsLatex
    }
}
