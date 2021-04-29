//
//  NetworkHandler.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 22.04.2021.
//

import Foundation

class NetworkHandler: NetworkHandlerProtocol {
    let requestSender: IRequestSender
    
    init(with requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    
    func getImagesArray(resultHandler: @escaping (Response?, String?) -> Void) {
        let requestConfig = RequestFactory.AppleRSSRequests.newImageDownloadConfig()
        
        requestSender.send(config: requestConfig) { (result: Result<Response, NetworkError>) in
            switch result {
            case .success(let response):
                resultHandler(response, nil)
            case .failure(let error):
                resultHandler(nil, error.localizedDescription)
            }
        }
    }
}
