//
//  Conversation.swift
//  openAiChat
//
//  Created by ethan on 2023/2/5.
//

import Foundation
import UIKit


class Conversation {
    enum CompletionType {
        case question
        case answer
        
        var fontColor: UIColor {
            switch self {
            case .question: return .systemYellow
            case .answer: return .white
            }
        }
        var font: UIFont {
            switch self {
            case .question: return UIFont.boldSystemFont(ofSize: 15)
            case .answer: return UIFont.systemFont(ofSize: 15)
            }
        }
    }
    
    var prompt = NSMutableAttributedString(string: "")
    let attributedSpacing = NSAttributedString(string:"\n")
    
    func updatePrompt(text: String, type: CompletionType) {
        let stringToAppend = NSAttributedString(string: text, attributes: [.foregroundColor: type.fontColor, .font: type.font])
        prompt.append(attributedSpacing)
        prompt.append(stringToAppend)
        prompt.append(attributedSpacing)
    }
}
