//
//  ConversationModel.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 14.04.2021.
//

import Foundation
import CoreData
import Firebase

class ConversationModel: ConversationModelProtocol {
    
    private lazy var dataBase = Firestore.firestore()
    private lazy var reference: CollectionReference? = nil
    
    init(with chat: ConversationCellDataModel?, updateTable: @escaping () -> Void) {
       
        guard let chat = chat else {
            return
        }
        
        self.reference = dataBase.collection("channels/\(chat.identifier)/messages")
        
        reference?.addSnapshotListener {[weak self] snapshot, _ in
            if let snapshot = snapshot {
                self?.receiveMessages(from: snapshot.documentChanges,
                                      in: chat)
                updateTable()
            }
        }
    }
    
    private func parseReceivedDataMessage(document: QueryDocumentSnapshot) -> MessageCellDataModel? {
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
    
    func receiveMessages(from changedDocuments: [DocumentChange],
                         in chat: ConversationCellDataModel) {
        
        var messagesToSave = [MessageCellDataModel]()
        
        for changedDocument in changedDocuments {
            
            guard let parsedMesssage = parseReceivedDataMessage(document: changedDocument.document)
            else { continue }
            
            switch changedDocument.type {
            case .added:
                messagesToSave.append(parsedMesssage)
            default:
                break
            }
        }
        RootAssembly.serviceAssembly.coreDataHandler.saveReceivedMessages(chat: chat,
                                                             messages: messagesToSave)
    }
    
    func sendMessage(with text: String) {
        let userName = try? RootAssembly.coreLayerAssembly.fileInteractionHandler.loadText(from: FileInteractionHandler.fullNameDataPath)
        self.reference?.addDocument(data: [
            "content": text,
            "created": Timestamp(date: Date()),
            "senderId": RootAssembly.serviceAssembly.userIDHandler.getID(),
            "senderName": userName ?? "Unknown User"
        ])
    }
}
