//
//  CoreDataHandlerProtocol.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 11.04.2021.
//

import Foundation

protocol CoreDataHandlerProtocol {
    func saveChannels(channels: [ConversationCellDataModel])
    func updateChannel(channel: ConversationCellDataModel)
    func deleteChannel(channel: ConversationCellDataModel)
    func saveReceivedMessages(chat: ConversationCellDataModel,
                              messages: [MessageCellDataModel])
}
