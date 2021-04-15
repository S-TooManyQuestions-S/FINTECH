//
//  ConversationListModelProtocol.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 13.04.2021.
//

import Foundation
import CoreData
import Firebase

protocol ConversationListModelProtocol {
    func receiveChannels(from changedDocuments: [DocumentChange],
                         using fetchedResultsController: NSFetchedResultsController<Channel>)
    func deleteChannel(with channel: ConversationCellDataModel)
    func addNewChannel(with name: String)
}
