//
//  APICaller.swift
//  openAiChat
//
//  Created by ethan on 2023/1/31.
//

import Foundation
import OpenAISwift
import Combine

final class APICaller {
    
    static let shared = APICaller()
    
    private init() {}
    
    private var client: OpenAISwift?
            
    public func setupClient(apiKey: String) {
        client = OpenAISwift(authToken: apiKey)
    }
    
    public func fetchResponse(input: String) -> Future<String, Error> {
        return Future { [weak self] promise in
            self?.client?.sendCompletion(with: input, model: .gpt3(.davinci), maxTokens: 1000, completionHandler: { result in
                switch result {
                case .success(let model):
                    let response = model.choices.first?.text ?? ""
                    print(model.choices)
                    promise(.success(response))
                case .failure(let error):
                    promise(.failure(error))
                }
            })
        }
    }
    
//    public func getResponse(input: String, completion: @escaping(Result<String, Error>) -> ()) {
//        client?.sendCompletion(with: input, model: .gpt3(.davinci), maxTokens: 1000, completionHandler: { result in
//            switch result {
//            case .success(let model):
//                let output = model.choices.first?.text ?? ""
//                print(model.choices)
//                completion(.success(output))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        })
//    }
    
}
