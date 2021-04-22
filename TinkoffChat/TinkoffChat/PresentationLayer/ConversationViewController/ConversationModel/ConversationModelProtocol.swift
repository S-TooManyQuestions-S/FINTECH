//
//  ConversationModelProtocol.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 14.04.2021.
//

import Foundation
import CoreData
import Firebase

protocol ConversationModelProtocol {
    func receiveMessages(from changedDocuments: [DocumentChange],
                         in chat: ConversationCellDataModel)
    func sendMessage(with text: String)
}
