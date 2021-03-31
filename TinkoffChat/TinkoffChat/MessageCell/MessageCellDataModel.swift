//
//  MessageCellDataModel.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 03.03.2021.
//

import UIKit

class MessageCellDataModel: MessageCellConfiguration {
    var content: String
    var created: Date
    var senderId: String
    var senderName: String
    
    init(content: String, created: Date, senderId: String, senderName: String) {
        self.content = content
        self.created = created
        self.senderId = senderId
        self.senderName = senderName
    }
}
