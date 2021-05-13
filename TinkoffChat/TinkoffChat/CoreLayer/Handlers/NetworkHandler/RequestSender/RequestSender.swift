//
//  RequestSender.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 21.04.2021.
//

import Foundation

struct RequestConfig<Parser> where Parser: IParser {
    let request: IRequest
    let parser: Parser
}

enum NetworkError: Error {
    case badUrl(message: String)
    case badSession(message: String)
    case badDataWhileParsing(message: String)
    var message: String {
        switch self {
        case .badUrl(let message),
             .badSession(let message),
             .badDataWhileParsing(let message):
            return message
        }
    }
}

class RequestSender: IRequestSender {
    
    let session: URLSession
    init(with session: URLSession) {
        self.session = session
    }
    
    func send<Parser>(config: RequestConfig<Parser>,
                      completonHandler: @escaping (Result<Parser.Response, NetworkError>) -> Void)
    where Parser: IParser {
        
        guard let urlRequest = config.request.urlRequest else {
            completonHandler(.failure(.badUrl(message: "Bad URL error!")))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { (data: Data?, _: URLResponse?, error) in
            if let error = error {
                completonHandler(.failure(.badSession(message: error.localizedDescription)))
                return
            }
            
            guard
                let data = data,
                let parsedModel: Parser.Response = config.parser.parse(data: data) else {
                if let error = error {
                    completonHandler(.failure(.badDataWhileParsing(message: error.localizedDescription)))
                }
                return
            }
            
            completonHandler(.success(parsedModel))
        }
        task.resume()
    }
}
