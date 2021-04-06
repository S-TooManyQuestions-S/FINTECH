//
//  MessageCell.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 03.03.2021.
//

import UIKit

class MessageCell: UITableViewCell {
    var cellFrame: CGRect = CGRect()
    
    private func setTextLabel(with message: String?) {
        guard let message: String = message, !message.isEmpty else {
            messageTextLabel.text = ""
            return
        }
        messageTextLabel.text = message
    }
    
    func configure(with message: MessageCellDataModel) {
        cellFrame = messageView.frame
        
        setTextLabel(with: message.content)
        
        messageView.layer.cornerRadius = messageView.frame.height * 14 / 40
        
        let currentTheme = ThemesManager.getTheme()
        
        if message.senderId != UserIdHandler.getID() {
            messageTextLabel.textColor = currentTheme.getInputMessageTextColor
            messageView.backgroundColor = currentTheme.getInputMessageColor
            senderNameLabel.text = message.senderName
        } else {
            messageTextLabel.textColor = currentTheme.getOutputMessageTextColor
            messageView.backgroundColor = currentTheme.getOutPutMessageColor
            leftConstraint.isActive = false
            senderNameLabel.text = ""
            
        }
        
        senderNameLabel.textColor = currentTheme.getTextColor
        backgroundColor = currentTheme.getBackGroundColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageView.frame = cellFrame
        messageView.layer.cornerRadius = 0
        leftConstraint.isActive = true
        senderNameLabel.isHidden = false
        
    }

    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet var rightConstraint: NSLayoutConstraint!
    @IBOutlet var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var messageView: UIView!
}
