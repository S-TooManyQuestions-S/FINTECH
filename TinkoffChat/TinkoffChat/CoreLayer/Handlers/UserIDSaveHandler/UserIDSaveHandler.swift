//
//  UserIDSaveHandler.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 15.04.2021.
//

import Foundation

class UserIDSaveHandler: UserIDSaveHandlerProtocol {
    
    var selectedKey: String = "uniqueIdKey"
    
    func loadID() -> String? {
        if let storedID = UserDefaults.standard.value(forKey: selectedKey) as? String {
            return storedID
        }
        return nil
    }
    
   func saveID(newID: UUID) {
        UserDefaults.standard.setValue(newID.uuidString, forKey: selectedKey)
        UserDefaults.standard.synchronize()
    }
}
