//
//  APICaller.swift
//  openAiChat
//
//  Created by ethan on 2023/1/31.
//

import Foundation
import OpenAISwift

final class APICaller {
    
    static let shared = APICaller()
    
    private init() {}
    
    private var client: OpenAISwift?
    
    @frozen enum Constants {
        static let apiKey = "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"
    }
    
    public func setupClient() {
        client = OpenAISwift(authToken: Constants.apiKey)
    }
    
    public func getResponse(input: String, completion: @escaping(Result<String, Error>) -> ()) {
        client?.sendCompletion(with: input, model: .gpt3(.davinci), maxTokens: 1000, completionHandler: { result in
            switch result {
            case .success(let model):
                let output = model.choices.first?.text ?? ""
                print(model.choices)
                completion(.success(output))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
}
