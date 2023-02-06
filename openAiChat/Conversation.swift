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
//    var prompts: LiveData<NSMutableAttributedString> = .init(NSMutableAttributedString(string: ""))
    let attributedSpacing = NSAttributedString(string:"\n")
    
    func updatePrompt(text: String, type: CompletionType) {
        let stringToAppend = NSAttributedString(string: text, attributes: [.foregroundColor: type.fontColor, .font: type.font])
        prompt.append(attributedSpacing)
        prompt.append(stringToAppend)
        prompt.append(attributedSpacing)
    }
    
//    func addToPrompt(text: String, type: CompletionType) {
//        guard let content = prompts.value else { return }
//        let stringToAppend = NSAttributedString(string: text, attributes: [.foregroundColor: type.fontColor, .font: type.font])
//        content.append(attributedSpacing)
//        content.append(stringToAppend)
//        content.append(attributedSpacing)
//        prompts.just(content)
//    }
}

/*
 var content = AttributedString()
 
 var name = AttributedString("anwei20 ")
 name.font = .boldSystemFont(ofSize: 30)
 name.foregroundColor = .black
 content += name
 
 var message = AttributedString("戴佩妮創作的天花版的星星\n")
 message.font = .systemFont(ofSize: 18)
 message.foregroundColor = .gray
 content += message
 
 var lyrics = AttributedString("看你從没看過的風景 躲没躲過的大雨 創造一個天晴 避開你最討厭的擁擠 你最害怕的猜疑 好好喘口氣")
 lyrics.font = .systemFont(ofSize: 14)
 lyrics.foregroundColor = .systemPink
 lyrics.backgroundColor = .cyan
 let paragraphStyle = NSMutableParagraphStyle()
 paragraphStyle.lineSpacing = 5
 lyrics.paragraphStyle = paragraphStyle
 content += lyrics
 
 label.attributedText = NSAttributedString(content)
 */
