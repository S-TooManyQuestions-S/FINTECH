//
//  DialogCell.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 02.03.2021.
//

import UIKit

class ConversationCell: UITableViewCell {
    
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var lastMessageDateLabel: UILabel!
    
    private func setUserFullName(with rawName: String?) {
        if rawName == nil || rawName == ""{
            userFullNameLabel.text = "Unknown User"
        } else {
            userFullNameLabel.text = rawName
        }
        userFullNameLabel.textColor = ThemesManager.getTheme().getTextColor
    }
    
    private func setLastMessage(with rawMessage: String?) {
        let fontSize = self.lastMessageLabel.font.pointSize
        if rawMessage == nil || rawMessage == ""{
            lastMessageLabel.font = UIFont(name: "AvenirNext-UltraLight", size: fontSize)
            lastMessageLabel.text = "No messages yet"
        } else {
            lastMessageLabel.font = /*isUnread ? .boldSystemFont(ofSize: fontSize) :*/
                .systemFont(ofSize: fontSize)
            lastMessageLabel.text = rawMessage
        }
        lastMessageLabel.textColor = ThemesManager.getTheme().getMessageTextColor
    }
    
    private func setLastMessageDate(with rawDate: Date?) {
        guard let date: Date = rawDate else {
            lastMessageDateLabel.text = ""
            return
        }
        
        let dateFormatter = DateFormatter()
        if Calendar.current.compare(Date(), to: date, toGranularity: .day) == .orderedDescending {
            dateFormatter.dateFormat = "dd-MMM"
        } else {
            dateFormatter.dateFormat = "HH:mm"
        }
        
        lastMessageDateLabel.text = dateFormatter.string(from: date)
        lastMessageDateLabel.textColor = ThemesManager.getTheme().getMessageTextColor
    }
    
    private func setCellBackground() {
        backgroundColor = ThemesManager.getTheme().getBackGroundColor
    }
    
    func configure(with model: ConversationCellDataModel) {
        setUserFullName(with: model.name)
        setLastMessageDate(with: model.lastActivity)
        setLastMessage(with: model.lastMessage)
        setCellBackground()
    }
}
   
