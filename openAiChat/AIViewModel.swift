//
//  AIViewModel.swift
//  openAiChat
//
//  Created by ethan on 2023/1/31.
//

import Foundation
import Combine

final class AIViewModel {
    enum Input {
        case sendRequest(input: String)
    }
    
    enum Output {
        case isLoading(_ bool: Bool)
        case didSucceeded(response: NSAttributedString)
        case didFailed(error: String)
    }
    
//    var responseText: LiveData<NSAttributedString> = .init(nil)
//    var isLoading: LiveData<Bool> = .init(false)
    
    let conversation = Conversation()
    
    let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        output.send(.isLoading(true))
        
        input.sink { [weak self] event in
            guard let self = self else { return }
            if case .sendRequest(let inputText) = event {
                self.conversation.updatePrompt(text: inputText, type: .question)
                APICaller.shared.fetchResponse(input: self.conversation.prompt.string).sink { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.output.send(.didFailed(error: error.localizedDescription))
                    }
                } receiveValue: { [weak self] response in
                    self?.conversation.updatePrompt(text: response, type: .answer)
                    self?.output.send(.didSucceeded(response: self?.conversation.prompt ?? NSAttributedString(string:"")))
                }.store(in: &self.cancellables)
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    
    
//    func getResponse(input: String) {
//        isLoading.just(true)
//        conversation.addToPrompt(text: input, type: Conversation.CompletionType.question)
//        print(conversation.prompts.value?.string ?? "")
//        APICaller.shared.getResponse(input: conversation.prompts.value?.string ?? "") { [weak self] result in
//            self?.isLoading.just(false)
//            switch result {
//            case .success(let result):
//                self?.conversation.addToPrompt(text: result, type: Conversation.CompletionType.answer)
//                self?.responseText.just(self?.conversation.prompts.value ?? NSAttributedString(string: ""))
//            case .failure(let error): self?.responseText.just(NSAttributedString(string: error.localizedDescription))
//            }
//        }
//    }
    
    func clearQuestions() {
//        conversation.prompts.just(NSMutableAttributedString(""))
        conversation.prompt = NSMutableAttributedString(string: "")
    }
}
