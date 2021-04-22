//
//  IParser.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 21.04.2021.
//

import Foundation

protocol IParser {
    associatedtype Response
    func parse(data: Data) -> Response?
}
