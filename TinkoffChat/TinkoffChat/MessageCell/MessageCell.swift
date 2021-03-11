//
//  MessageCell.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 03.03.2021.
//

import UIKit

class MessageCell: UITableViewCell {
    var cellFrame: CGRect = CGRect()
    
    
    private func setTextLabel(with message: String?){
        guard let message:String = message, !message.isEmpty else {
            messageTextLabel.text = "&UNDEFINED TEXT MESSAGE&"
            return
        }
        messageTextLabel.text = message
    }
    
    func configure(with message: MessageCellDataModel){
        cellFrame = messageView.frame
        
        setTextLabel(with: message.text)
        
        messageView.layer.cornerRadius = messageView.frame.height * 14/40
        
        switch message.typeOf {
        case .received:
            messageTextLabel.textColor = ThemesManager.currentTheme().getInputMessageTextColor
            messageView.backgroundColor = ThemesManager.currentTheme().getInputMessageColor
        case .sent:
            messageTextLabel.textColor = ThemesManager.currentTheme().getOutputMessageTextColor
            messageView.backgroundColor = ThemesManager.currentTheme().getOutPutMessageColor
            leftConstraint.isActive = false
        }
        backgroundColor = ThemesManager.currentTheme().getBackGroundColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageView.frame = cellFrame
        messageView.layer.cornerRadius = 0
        leftConstraint.isActive = true
        
    }

    @IBOutlet var rightConstraint: NSLayoutConstraint!
    @IBOutlet var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var messageView: UIView!
}
