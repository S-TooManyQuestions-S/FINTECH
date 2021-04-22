//
//  CoreDataHandler.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 06.04.2021.
//

import UIKit
import CoreData

class CoreDataHandler: CoreDataHandlerProtocol {
        
    func saveChannels(channels: [ConversationCellDataModel]) {
        var transformedChannels = [Channel]()
        
        RootAssembly.coreLayerAssembly.coreDataStackHandler.performSave { context in
            channels.forEach {
                transformedChannels.append(Channel(with: $0, in: context))
            }
            try? context.obtainPermanentIDs(for: transformedChannels)
        }
    }
    
    func updateChannel(channel: ConversationCellDataModel) {
        
        let request: NSFetchRequest<Channel> = Channel.fetchRequest()
        request.predicate = NSPredicate(format: "identifier_db = %@", channel.identifier)
        request.fetchLimit = 1
        
        let sortDescriptor = NSSortDescriptor(key: "lastActivity_db", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        let context = RootAssembly.coreLayerAssembly.coreDataStackHandler.getFetchedResultController(with: request).managedObjectContext
        
        if let innerChannel = try? context.fetch(request) {
            innerChannel.first?.setValue(channel.lastActivity, forKey: "lastActivity_db")
            innerChannel.first?.setValue(channel.lastMessage, forKey: "lastMessage_db")
        }
        
        RootAssembly.coreLayerAssembly.coreDataStackHandler.performSave(in: context)
    }
    
    func deleteChannel(channel: ConversationCellDataModel) {
        
        let request: NSFetchRequest<Channel> = Channel.fetchRequest()
        request.predicate = NSPredicate(format: "identifier_db = %@", channel.identifier)
        request.fetchLimit = 1
        
        let sortDescriptor = NSSortDescriptor(key: "lastActivity_db", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        let context = RootAssembly.coreLayerAssembly.coreDataStackHandler.getFetchedResultController(with: request).managedObjectContext
        
        if let channels = try? context.fetch(request),
           let channelToDelete = channels.first {
            context.delete(channelToDelete)
        }
        RootAssembly.coreLayerAssembly.coreDataStackHandler.performSave(in: context)
    }
    
    func saveReceivedMessages(chat: ConversationCellDataModel, messages: [MessageCellDataModel]) {
        
        RootAssembly.coreLayerAssembly.coreDataStackHandler.performSave { context in
            var messagesToSave = [Message]()
            let chat_ = Channel(with: chat, in: context)
            
            messages.forEach {
                let message = Message(with: $0, in: context)
                messagesToSave.append(message)
                message.channel = chat_
                chat_.addToMessages(message)
            }
            
            try? context.obtainPermanentIDs(for: [chat_])
            try? context.obtainPermanentIDs(for: messagesToSave)
            
        }
    }
}
