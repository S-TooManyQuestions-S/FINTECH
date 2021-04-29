//
//  RequestFactory.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 21.04.2021.
//

import Foundation

struct RequestFactory {
    struct AppleRSSRequests {
        static func newImageDownloadConfig() -> RequestConfig<ImageDataParser> {
            return RequestConfig<ImageDataParser>(request: Request(with: "21269857-9477edce33fa7929331f69fa2"), parser: ImageDataParser())
        }
    }
}
