//
//  DialogCellProtocol.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 02.03.2021.
//

import UIKit

protocol ConversationCellConfiguration: AnyObject {
    var identifier: String {get}
    var name: String {get}
    var lastMessage: String? {get}
    var lastActivity: Date? {get}
}
