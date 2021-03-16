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
    
    private func setUserFullName(with rawName: String?){
        if rawName == nil || rawName == ""{
            userFullNameLabel.text = "Unknown User"
        }else{
            userFullNameLabel.text = rawName
        }
        userFullNameLabel.textColor = ThemesManager.currentTheme().getTextColor
    }
    
    private func setLastMessage(with rawMessage: String?, isUnread:Bool){
        let fontSize = self.lastMessageLabel.font.pointSize;
        if rawMessage == nil || rawMessage == ""{
            lastMessageLabel.font = UIFont(name: "AvenirNext-UltraLight", size: fontSize)
            lastMessageLabel.text = "No messages yet"
        }else{
            lastMessageLabel.font = isUnread ? .boldSystemFont(ofSize: fontSize) : .systemFont(ofSize: fontSize)
            lastMessageLabel.text = rawMessage
        }
        lastMessageLabel.textColor = ThemesManager.currentTheme().getMessageTextColor
    }
    
    private func setLastMessageDate(with rawDate:Date?){
        guard let date:Date = rawDate else{
            lastMessageDateLabel.text = ""
            return
        }
        
        let dateFormatter = DateFormatter()
        if Calendar.current.compare(Date(), to: date, toGranularity: .day) == .orderedDescending{
            dateFormatter.dateFormat = "dd-MMM"
        }else{
            dateFormatter.dateFormat = "HH:mm"
        }
        
        lastMessageDateLabel.text =  dateFormatter.string(from: date)
        lastMessageDateLabel.textColor = ThemesManager.currentTheme().getMessageTextColor
    }
    
    private func setCellBackground(isOnline: Bool){
        if isOnline{
            backgroundColor = UIColor(red: 254/255.0, green: 248/255.0, blue: 130/255.0, alpha: 1)
        }else{
            backgroundColor = ThemesManager.currentTheme().getBackGroundColor
        }
    }
    
    
    func configure(with model: ConversationCellDataModel){
        setUserFullName(with: model.name)
        setLastMessageDate(with: model.date)
        setLastMessage(with: model.message, isUnread: model.hasUnreadMessages)
        setCellBackground(isOnline: model.online)
    }
}
    
   
