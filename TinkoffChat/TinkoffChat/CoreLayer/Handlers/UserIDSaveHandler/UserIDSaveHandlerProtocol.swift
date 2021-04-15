//
//  UserIDSaveHandlerProtocol.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 15.04.2021.
//

import Foundation

protocol UserIDSaveHandlerProtocol {
    var selectedKey: String {get}
    func loadID() -> String?
    func saveID(newID: UUID)
}
