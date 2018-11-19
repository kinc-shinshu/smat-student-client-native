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
    var questionText: String
    
    //  other
    /*var questionAnswer: String
     var questionResult: Int
     var questionResultNumber: Int*/
    
    init?(questionText: String) {
        // The name must not be empty
        guard !questionText.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.questionText = questionText
    }
}
