//
//  FireBaseHandler.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 01.04.2021.
//

import UIKit
import CoreData
import Firebase

class FireBaseHandler {
    
    private var coreDataHandler: CoreDataHandler?
    
    static var shared: FireBaseHandler = {
        let instance = FireBaseHandler()
        instance.coreDataHandler = CoreDataHandler.shared
        return instance
    }()
    
    func receiveChannels(from changedDocuments: [DocumentChange], fetchedResultController: NSFetchedResultsController<Channel>) {
        
        var channelsToSave = [ConversationCellDataModel]()
        
        for changedDocument in changedDocuments {
            
            guard let parsedChannel = parseReceivedDataChannel(document: changedDocument.document) else {
                continue
            }
            switch changedDocument.type {

            case .added:
                if let objects = fetchedResultController.fetchedObjects,
                   objects.contains(where: {$0.identifier_db == changedDocument.document.documentID}) {
                    coreDataHandler?.updateChannel(channel: parsedChannel)
                } else {
                    channelsToSave.append(parsedChannel)
                }
            case .modified:
                coreDataHandler?.updateChannel(channel: parsedChannel)
            case .removed:
                coreDataHandler?.deleteChannel(channel: parsedChannel)
            default:
                break
            }
        }
        coreDataHandler?.saveChannels(channels: channelsToSave)
    }
    
    func parseReceivedDataChannel(document: QueryDocumentSnapshot) -> ConversationCellDataModel? {
        let data = document.data()
        if let name = data["name"] as? String {
            
            let lastMessage = data["lastMessage"] as? String
            
            var lastActivity: Date?
            if let receivedDate = data["lastActivity"] as? Timestamp {
                lastActivity = receivedDate.dateValue()
            }
            
            return .init(id: document.documentID,
                         name: name,
                         lastMessage: lastMessage,
                         lastActivity: lastActivity)
            
        }
        return nil
    }
    
    func parseReceivedDataMessage(document: QueryDocumentSnapshot) -> MessageCellDataModel? {
        guard
            let content = document["content"] as? String,
            let created = document["created"] as? Timestamp,
            let senderId = document["senderId"] as? String,
            let senderName = document["senderName"] as? String
        else {
            return nil
        }
        return MessageCellDataModel(content: content,
                                    created: created.dateValue(),
                                    senderId: senderId,
                                    senderName: senderName,
                                    messageId: document.documentID)
    }
    
    func receiveMessages(in chat: ConversationCellDataModel, from changedDocuments: [DocumentChange], fetchedResultController: NSFetchedResultsController<Message>) {
        
        var messagesToSave = [MessageCellDataModel]()
        
        for changedDocument in changedDocuments {
            
            guard let parsedMesssage = parseReceivedDataMessage(document: changedDocument.document) else {
                continue
            }
            
            switch changedDocument.type {
            case .added:
                messagesToSave.append(parsedMesssage)
            default:
                break
            }
        }
        coreDataHandler?.saveReceivedMessages(chat: chat,
                                              messages: messagesToSave)
    }

    func receiveMessages(chat: ConversationCellDataModel,
                         documents: [DocumentChange]) {
        var messageList = [MessageCellDataModel]()
        for document in documents {
            if  let content = document.document["content"] as? String,
                let created = document.document["created"] as? Timestamp,
                let senderId = document.document["senderId"] as? String,
                let senderName = document.document["senderName"] as? String {
                messageList.append(MessageCellDataModel(content: content,
                                                        created: created.dateValue(),
                                                        senderId: senderId,
                                                        senderName: senderName,
                                                        messageId: document.document.documentID))
            }
        }
        coreDataHandler?.saveReceivedMessages(chat: chat, messages: messageList)
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
    
    func deleteChannel(with channel: ConversationCellDataModel,
                       through reference: CollectionReference) {
        reference.document(channel.identifier).delete()
        coreDataHandler?.deleteChannel(channel: channel)
        
    }
    
    func showDetailedDataChannels() {
        CoreDataStack.shared.printDataBaseStatisticsForChannels()
    }
}
