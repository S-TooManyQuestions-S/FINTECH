//
//  IRequestSender.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 21.04.2021.
//

import Foundation

protocol IRequestSender {
    func send<Parser>(config: RequestConfig<Parser>, completonHandler: @escaping (Result<Parser.Response, NetworkError>) -> Void) where Parser: IParser
}
