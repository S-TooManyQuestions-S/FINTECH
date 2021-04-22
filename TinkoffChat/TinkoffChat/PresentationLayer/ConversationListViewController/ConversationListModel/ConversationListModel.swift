//
//  ConversationListModel.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 13.04.2021.
//

import Foundation
import Firebase
import CoreData
class ConversationListModel: ConversationListModelProtocol {
    // FireBase connections:
    lazy var dataBase = Firestore.firestore()
    lazy var reference = dataBase.collection("channels")
    
    init(fetchedResultsController: NSFetchedResultsController<Channel>) {
        reference.addSnapshotListener {[weak self]snapshot, _ in
            if let documents = snapshot?.documentChanges {
                self?.receiveChannels(from: documents, using: fetchedResultsController)
            }
        }
    }
    
    func receiveChannels(from changedDocuments: [DocumentChange],
                         using fetchedResultController: NSFetchedResultsController<Channel>) {
        
        var channelsToSave = [ConversationCellDataModel]()
        
        for changedDocument in changedDocuments {
            guard let parsedChannel = parseReceivedDataChannel(document: changedDocument.document) else {
                continue
            }
            
            switch changedDocument.type {
            case .added:
                if let objects = fetchedResultController.fetchedObjects,
                   objects.contains(where: {$0.identifier_db == changedDocument.document.documentID}) {
                    RootAssembly.serviceAssembly.coreDataHandler.updateChannel(channel: parsedChannel)
                } else {
                    channelsToSave.append(parsedChannel)
                }
            case .modified:
                RootAssembly.serviceAssembly.coreDataHandler.updateChannel(channel: parsedChannel)
            case .removed:
                RootAssembly.serviceAssembly.coreDataHandler.deleteChannel(channel: parsedChannel)
            default:
                break
            }
        }
        RootAssembly.serviceAssembly.coreDataHandler.saveChannels(channels: channelsToSave)
    }
    
    private func parseReceivedDataChannel(document: QueryDocumentSnapshot)
    -> ConversationCellDataModel? {
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
    
    func deleteChannel(with channel: ConversationCellDataModel) {
        reference.document(channel.identifier).delete()
        RootAssembly.serviceAssembly.coreDataHandler.deleteChannel(channel: channel)
    }
    
    func addNewChannel(with name: String) {
        reference.addDocument(data: ["name": name])
    }
}
