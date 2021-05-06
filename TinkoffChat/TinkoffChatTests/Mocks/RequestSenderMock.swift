//
//  RequestSenderMock.swift
//  TinkoffChatTests
//
//  Created by Андрей Самаренко on 06.05.2021.
//

@testable import TinkoffChat
import Foundation

class RequestSenderMock: IRequestSender {
    
    var receivedURL: String = ""
    var callsCount: Int = 0
    var isSuccessFull: Bool = false
    var errorMessage: String = "response error: bad code 401"
    
    init(isSuccessFull: Bool) {
        self.isSuccessFull = isSuccessFull
    }
    
    // simulating server response
    
    func send<Parser>(config: RequestConfig<Parser>,
                      completonHandler: @escaping (Result<Parser.Response, NetworkError>) -> Void)
    where Parser: IParser {
        
        self.callsCount += 1
        self.receivedURL = config.request.urlRequest?.url?.absoluteString ?? "NONE"
        
        guard let response = Response(hits:
                                        [.init(id: 13, webformatUrl: "someString1.com"),
                                         .init(id: 14, webformatUrl: "someString2.com")]) as? Parser.Response,
              isSuccessFull else {
            completonHandler(.failure(.badSession(message: errorMessage)))
            return
        }
        completonHandler(.success(response))
    }
}
