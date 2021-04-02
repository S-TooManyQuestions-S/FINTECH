//
//  MessageCellProtocol.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 03.03.2021.
//

import UIKit

protocol MessageCellConfiguration: class {
    var content: String {get}
    var created: Date {get}
    var senderId: String {get}
    var senderName: String {get}
}
