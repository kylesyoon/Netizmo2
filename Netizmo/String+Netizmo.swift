//
//  String+Netizmo.swift
//  Netizmo
//
//  Created by Yoon, Kyle on 3/10/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import Foundation

extension String {
    
    func whiteSpaceTrimmed() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
}