//
//  Request.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 21.04.2021.
//

import Foundation

class Request: IRequest {
    
    private let apiKey: String
    
    /*Инициализируем API-ключем*/
    init(with apiKey: String) {
        self.apiKey = apiKey
    }
    
    /*Конфиг запроса*/
    private static let baseUrl = "https://pixabay.com/api/"
    private let query = "yellow+flowers"
    private let imageType = "photo"
    private let isPretty = "true"
    private let perPage = "100"
    
    /*Склеивание запроса из конфига*/
    private func getStringRequest() -> String {
        return "\(Request.baseUrl)?key=\(apiKey)"
        + "&q=\(query)&image_type=\(imageType)"
        + "&pretty=\(isPretty)&per_page=\(perPage)"
    }
    
    public var urlRequest: URLRequest? {
        guard let url = URL(string: getStringRequest()) else {return nil}
        return URLRequest(url: url, timeoutInterval: 5)
    }
}
