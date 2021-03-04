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
    }
    
    private func setLasMessage(with rawMessage: String?, isUnread:Bool){
        let fontSize = self.lastMessageLabel.font.pointSize;
        if rawMessage == nil || rawMessage == ""{
            lastMessageLabel.font = UIFont(name: "AvenirNext-UltraLight", size: fontSize)
            lastMessageLabel.text = "No messages yet"
        }else{
            lastMessageLabel.font = isUnread ? .boldSystemFont(ofSize: fontSize) : .systemFont(ofSize: fontSize)
            lastMessageLabel.text = rawMessage
        }
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
    }
    
    private func setCellBackground(isOnline: Bool){
        if isOnline{
            backgroundColor = UIColor(red: 250/255.0, green: 223/255.0, blue: 75/255.0, alpha: 1)
        }else{
            backgroundColor = .white
        }
    }
    
    
    func configure(with model: ConversationCellDataModel){
        setUserFullName(with: model.name)
        setLastMessageDate(with: model.date)
        setLasMessage(with: model.message, isUnread: model.hasUnreadMessages)
        setCellBackground(isOnline: model.online)
    }
}
    
   
