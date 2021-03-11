//
//  ConversationCellDataModell.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 02.03.2021.
//

import UIKit

class ConversationCellDataModel : ConversationCellConfiguration{    
    var name: String?
    var message: String?
    var date: Date?
    var online: Bool
    var hasUnreadMessages: Bool

    init(name: String?, message: String?, date: Date?, online: Bool, hasUnreadMessages:Bool){
        self.name = name
        self.hasUnreadMessages = hasUnreadMessages
        self.message = message
        self.date = date
        self.online = online
    }
}
