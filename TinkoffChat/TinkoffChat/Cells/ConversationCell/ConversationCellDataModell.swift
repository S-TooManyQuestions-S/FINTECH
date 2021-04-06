//
//  ConversationCellDataModell.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 02.03.2021.
//

import UIKit

class ConversationCellDataModel: ConversationCellConfiguration {
    var identifier: String
    var name: String
    var lastMessage: String?
    var lastActivity: Date?
    
    init(id: String, name: String, lastMessage: String?, lastActivity: Date?) {
        self.identifier = id
        self.name = name
        self.lastMessage = lastMessage
        self.lastActivity = lastActivity
    }
}
