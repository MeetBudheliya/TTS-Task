//
//  UIViewController+Extension.swift
//  TTS-Task
//
//  Created by Meet Budheliya on 07/03/24.
//

import UIKit

extension String{
    
    func removeFirst10Words() -> String {
        let words = self.components(separatedBy: " ")
        let remainingWords = (words.count >= 0) ? Array(words.dropFirst(10)) : Array(words.dropFirst(words.count))
        let result = remainingWords.joined(separator: " ")
        return result
    }
}
