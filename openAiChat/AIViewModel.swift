//
//  AIViewModel.swift
//  openAiChat
//
//  Created by ethan on 2023/1/31.
//

import Foundation

final class AIViewModel {
    
    var responseText: LiveData<NSAttributedString> = .init(nil)
    var isLoading: LiveData<Bool> = .init(false)
    
    let conversation = Conversation()
    
    func getResponse(input: String) {
        isLoading.just(true)
        conversation.addToPrompt(text: input, type: Conversation.CompletionType.question)
        print(conversation.prompts.value?.string ?? "")
        APICaller.shared.getResponse(input: conversation.prompts.value?.string ?? "") { [weak self] result in
            self?.isLoading.just(false)
            switch result {
            case .success(let result):
                self?.conversation.addToPrompt(text: result, type: Conversation.CompletionType.answer)
                self?.responseText.just(self?.conversation.prompts.value ?? NSAttributedString(string: ""))
            case .failure(let error): self?.responseText.just(NSAttributedString(string: error.localizedDescription))
            }
        }
    }
    
    func clearQuestions() {
        conversation.prompts.just(NSMutableAttributedString(""))
    }
}
