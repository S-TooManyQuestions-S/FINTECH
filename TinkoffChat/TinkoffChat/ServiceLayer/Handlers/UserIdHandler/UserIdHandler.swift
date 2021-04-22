//
//  UserIdHandler.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 24.03.2021.
//

import UIKit

class UserIdHandler: UserIdHandlerProtocol {
    func getID() -> String {
        let savedID = RootAssembly.coreLayerAssembly.userIdSaveHandler.loadID()
        guard let currentID = savedID else {
            RootAssembly.coreLayerAssembly.userIdSaveHandler.saveID(newID: UUID())
            return UUID().uuidString
        }
        return currentID
    }
}
