//
//  DialogCellProtocol.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 02.03.2021.
//

import UIKit

protocol ConversationCellConfiguration: class{
    var name: String? {get set}
    var message: String? {get set}
    var date: Date? {get set}
    var online: Bool {get set}
    var hasUnreadMessages: Bool {get set}
}
