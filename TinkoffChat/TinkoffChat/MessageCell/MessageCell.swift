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
        
        let currentTheme = ThemesManager.getTheme()
        
        switch message.typeOf {
        case .received:
            messageTextLabel.textColor = currentTheme.getInputMessageTextColor
            messageView.backgroundColor = currentTheme.getInputMessageColor
        case .sent:
            messageTextLabel.textColor = currentTheme.getOutputMessageTextColor
            messageView.backgroundColor = currentTheme.getOutPutMessageColor
            leftConstraint.isActive = false
        }
        backgroundColor = currentTheme.getBackGroundColor
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
