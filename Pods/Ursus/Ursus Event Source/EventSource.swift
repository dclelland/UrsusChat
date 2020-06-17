//
//  EventSource.swift
//  EventSource
//
//  Created by Andres on 2/13/15.
//  Copyright (c) 2015 Inaka. All rights reserved.
//

import Foundation

public protocol EventSourceDelegate: class {
    
    func eventSource(_ eventSource: EventSource, didReceiveMessage message: EventSourceMessage)
    
    func eventSource(_ eventSource: EventSource, didCompleteWithError error: EventSourceError)
    
}

public class EventSource: NSObject {
    
    private var session: URLSession?
    private var parser = EventSourceParser()

    public let url: URL
    public weak var delegate: EventSourceDelegate?

    public init(url: URL, delegate: EventSourceDelegate? = nil) {
        self.url = url
        self.delegate = delegate
        super.init()
    }

    public func connect(lastEventID: String? = nil) {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        
        session = URLSession(configuration: .eventSource(lastEventID: lastEventID), delegate: self, delegateQueue: operationQueue)
        session?.dataTask(with: url).resume()
    }

    public func disconnect() {
        session?.invalidateAndCancel()
    }
    
}

extension EventSource: URLSessionDataDelegate {
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        for message in parser.append(data: data) {
            DispatchQueue.main.async { [weak self] in
                if let `self` = self {
                    self.delegate?.eventSource(self, didReceiveMessage: message)
                }
            }
        }
    }

    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        DispatchQueue.main.async { [weak self] in
            if let `self` = self {
                switch (error, task.response as? HTTPURLResponse) {
                case (.some(let error), .none):
                    self.delegate?.eventSource(self, didCompleteWithError: .requestFailed(error))
                case (.none, .some(let response)):
                    self.delegate?.eventSource(self, didCompleteWithError: .requestFinished(response))
                default:
                    break
                }
            }
        }
    }
    
}
