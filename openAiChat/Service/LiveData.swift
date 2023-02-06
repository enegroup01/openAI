//
//  LiveData.swift
//  openAiChat
//
//  Created by ethan on 2023/1/31.
//

import Foundation

class LiveData<T> {
    
    typealias CompletionHandler = ((T?) -> Void)
    private(set) var value: T? {
        didSet {
            self.notify()
        }
    }

    private var observers = [String: CompletionHandler]()

    init(_ value: T?) {
        self.value = value
    }

    func just(_ value: T) {
        self.value = value
    }

    func addObserver(_ observer: AnyObject, completionHandler: @escaping CompletionHandler) {
        observers[observer.description] = completionHandler
    }

    func addAndNotify(observer: NSObject, completionHandler: @escaping CompletionHandler) {
        addObserver(observer, completionHandler: completionHandler)
        observers[observer.description]?(value)
    }

    func removeObserver(_ observer: AnyObject) {
        observers.removeValue(forKey: observer.description)
    }

    func notify() {
        observers.forEach({ $0.value(value) })
    }

    deinit {
        observers.removeAll()
    }
}
