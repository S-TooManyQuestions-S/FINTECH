//
//  UserIdHandler.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 24.03.2021.
//

import UIKit

struct UserIdHandler {
    static let selectedIdKey = "uniqueIdKey"
    
    private static func loadID() -> String? {
        if let storedID = UserDefaults.standard.value(forKey: selectedIdKey) as? String {
            return storedID
        }
        return nil
    }
    
    private static func saveID(newID: UUID) {
        UserDefaults.standard.setValue(newID.uuidString, forKey: selectedIdKey)
        UserDefaults.standard.synchronize()
    }
    
    public static func getID() -> String {
        let savedID = loadID()
        guard let currentID = savedID else {
            saveID(newID: UUID())
            return UUID().uuidString
        }
        return currentID
    }
    
}
