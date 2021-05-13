//
//  Parser.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 21.04.2021.
//

import Foundation

struct Response: Codable, Equatable {
    let hits: [ResponseData]
}

struct ResponseData: Codable, Equatable {
    
    let id: Int
    let webformatUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case webformatUrl = "webformatURL"
    }
}

class ImageDataParser: IParser {
    func parse(data: Data) -> Response? {
        do {
            return  try JSONDecoder().decode(Response.self, from: data)
        } catch {
            return nil
        }
    }
}
