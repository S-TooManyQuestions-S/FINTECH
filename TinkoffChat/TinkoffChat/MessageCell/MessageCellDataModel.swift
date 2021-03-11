//
//  MessageCellDataModel.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 03.03.2021.
//

import UIKit

class MessageCellDataModel : MessageCellConfiguration{
    var text: String?
    
    var typeOf: MessageType
    
    enum MessageType{
        case received
        case sent
    }
    
    init(message:String?, typeOf:MessageType){
        self.text = message
        self.typeOf = typeOf
    }
}
