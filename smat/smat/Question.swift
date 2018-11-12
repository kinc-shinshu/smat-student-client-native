//
//  Question.swift
//  smat
//
//  Created by Hiroshi Tamura on 2018/11/12.
//  Copyright © 2018 KINC. All rights reserved.
//

import UIKit


class Question{
    
    //MARK: Properties
    
    var questionText: String
    
    //MARK: Initialization
    
    init?(questionText: String) {
        
        // The name must not be empty
        guard !questionText.isEmpty else {
            return nil
        }
        
        self.questionText = questionText
        
    }
}
