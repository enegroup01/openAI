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
        case startToConnect(_ bool: Bool)
        case sendRequest(input: String)
    }
    
    enum Output {
        case isLoading(_ bool: Bool)
        case didSucceeded(response: NSAttributedString)
        case didFailed(error: String)
    }
    
    let conversation = Conversation()
    
    let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .sendRequest(let inputText):
                self.output.send(.isLoading(true))
                self.conversation.updatePrompt(text: inputText, type: .question)
                APICaller.shared.fetchResponse(input: self.conversation.prompt.string).sink { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.output.send(.isLoading(false))
                        self?.output.send(.didFailed(error: error.localizedDescription))
                    }
                } receiveValue: { [weak self] response in
                    self?.output.send(.isLoading(false))
                    self?.conversation.updatePrompt(text: response, type: .answer)
                    self?.output.send(.didSucceeded(response: self?.conversation.prompt ?? NSAttributedString(string:"")))
                }.store(in: &self.cancellables)
            case .startToConnect(let connecting):
                connecting ? self.output.send(.isLoading(true)) : self.output.send(.isLoading(false))
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }

    
    func clearQuestions() {
        conversation.prompt = NSMutableAttributedString(string: "")
    }
}
