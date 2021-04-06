//
//  ObjectsExtensions.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 31.03.2021.
//

import UIKit
import CoreData

extension Channel {
    
    func about() -> String {
        return "Channel Id: \(identifier_db ?? "no id")\n\t"
            + "Name: \(name_db ?? "Unnamed channel")\n\t"
            + "Last message: \(lastMessage_db ?? "No last message")\t\n"
            + "Last activity: \(lastActivity_db ?? Date())\n\n"
            + "Messages of the chanel: \(messages?.count ?? 0)\n"
    }
    
    convenience init(with channelDataModel: ConversationCellDataModel,
                     in context: NSManagedObjectContext) {
        self.init(context: context)
        self.identifier_db = channelDataModel.identifier
        self.name_db = channelDataModel.name
        self.lastMessage_db = channelDataModel.lastMessage
        self.lastActivity_db = channelDataModel.lastActivity
    }
}

extension Message {
    
    func about() -> String {
        return
            "MessageId: \(messageId_db ?? "unknown id")\n\t"
            + "Content: \(content_db ?? "no content")\n\t"
            + "Created: \(created_db ?? Date())\n\t"
            + "SenderId: \(senderId_db ?? "no sender ID")\n\t"
            + "SenderName: \(senderName_db ?? "unknownuser")\n"
    }
    
    convenience init(with messageDataModel: MessageCellDataModel,
                     in context: NSManagedObjectContext) {
        self.init(context: context)
        self.messageId_db = messageDataModel.messageId
        self.created_db = messageDataModel.created
        self.content_db = messageDataModel.content
        self.senderName_db = messageDataModel.senderName
        self.senderId_db = messageDataModel.senderId
    }
}
