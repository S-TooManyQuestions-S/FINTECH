//
//  FireBaseHandler.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 01.04.2021.
//

import UIKit
import Firebase

class FireBaseHandler {
    
    private static let coreDataStack = CoreDataStack()
    
    static var shared: FireBaseHandler = {
        let instance = FireBaseHandler()
        coreDataStack.enableObservers()
        return instance
    }()
    
    func receiveChannels(from documents: [QueryDocumentSnapshot]) -> [ConversationCellDataModel] {
        var receivedConversations = [ConversationCellDataModel]()
        
        for document in documents {
            let data = document.data()
            guard  let name = data["name"] as? String else {
                continue
            }
            
            let lastMessage = data["lastMessage"] as? String ?? ""
            
            var lastActivity: Date?
            if let receivedDate = data["lastActivity"] as? Timestamp {
                lastActivity = receivedDate.dateValue()
            }
            
            receivedConversations.append(.init(id: document.documentID,
                                               name: name,
                                               lastMessage: lastMessage,
                                               lastActivity: lastActivity))
        }
        
        receivedConversations.sort(by: ({$0.lastActivity ?? Date() > $1.lastActivity ?? Date()}))
        saveReceivedChannels(channels: receivedConversations)
        return receivedConversations
    }
    
    func receiveMessages(chat: ConversationCellDataModel,
                         documents: [QueryDocumentSnapshot]) -> [MessageCellDataModel] {
        var messageList = [MessageCellDataModel]()
        for document in documents {
            if  let content = document["content"] as? String,
                let created = document["created"] as? Timestamp,
                let senderId = document["senderId"] as? String,
                let senderName = document["senderName"] as? String {
                messageList.append(MessageCellDataModel(content: content,
                                                        created: created.dateValue(),
                                                        senderId: senderId,
                                                        senderName: senderName,
                                                        messageId: document.documentID))
            }
        }
        messageList.sort(by: ({$0.created < $1.created}))
        saveReceivedMessages(chat: chat, messages: messageList)
        return messageList
    }
    
    func sendMessage(with text: String, through reference: CollectionReference?) {
        let userName = try? FileInteractionHandler().loadText(from: FileInteractionHandler.fullNameDataPath)
            reference?.addDocument(data: [
                "content": text,
                "created": Timestamp(date: Date()),
                "senderId": UserIdHandler.getID(),
                "senderName": userName ?? "Unknown User"
            ])
    }
    
    func showDetailedDataChannels() {
        FireBaseHandler.coreDataStack.printDataBaseStatisticsForChannels()
    }
}

// CoreDataStack interaction logic
extension FireBaseHandler {
    func saveReceivedChannels(channels: [ConversationCellDataModel]) {
        DispatchQueue.global(qos: .utility).async {
            FireBaseHandler.coreDataStack.performSave { context in
                channels.forEach {
                    _ = Channel(with: $0, in: context)
                }
            }
        }
    }
    
    func saveReceivedMessages(chat: ConversationCellDataModel, messages: [MessageCellDataModel]) {
        DispatchQueue.global(qos: .utility).async {
            FireBaseHandler.coreDataStack.performSave { context in
                let chat = Channel(with: chat, in: context)
                messages.forEach {
                    let message = Message(with: $0, in: context)
                    chat.addToMessages(message)
                }
            }
        }
    }
}
