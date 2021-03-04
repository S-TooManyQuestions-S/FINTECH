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
        messageTextLabel.textColor = .black
        
        switch message.typeOf {
        case .received:
            messageView.backgroundColor = UIColor(red: 232/255.0, green: 232/255.0, blue: 234/255.0, alpha:1)
        case .sent:
            messageView.backgroundColor = UIColor(red: 250/255.0, green: 223/255.0, blue: 75/255.0, alpha: 1)
            leftConstraint.isActive = false
        }
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
