//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 03.03.2021.
//

import UIKit
import Firebase

class ConversationViewController: ViewController {
    
    @IBOutlet weak var dialogTable: UITableView!
    @IBOutlet weak var textToSend: UITextField!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var noMessagesLabel: UILabel!
    @IBOutlet weak var sendMessageView: UIView!
    
    @IBAction func sendMessageButtonPressed(_ sender: Any) {
        
        if let text = self.textToSend.text {
            DispatchQueue.global().async {
                self.fireBaseHandler.sendMessage(with: text,
                                                  through: self.reference)
            }
            
            textToSend.text = ""
            sendMessageButton.isEnabled = false
        }
    }
    
    private lazy var dataBase = Firestore.firestore()
    private lazy var reference: CollectionReference? = nil
    
    private var messageList: [MessageCellDataModel] = []
    private var fireBaseHandler = FireBaseHandler.shared
    private var currentChat: ConversationCellDataModel?
    
    private let cellIdentifier = String(describing: MessageCell.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dialogTable.delegate = self
        dialogTable.dataSource = self
        
        navigationItem.backBarButtonItem?.title = "Tinkoff Chat"
        
        dialogTable.register(UINib(nibName: String(describing: MessageCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        reference?.addSnapshotListener {[weak self] snapshot, _ in
            if let snapshot = snapshot {
                guard let currentChat = self?.currentChat,
                      let messageList = self?.fireBaseHandler.receiveMessages(chat: currentChat,
                                                                              documents: snapshot.documents) else {
                    return
                }
                self?.messageList = messageList
                
                self?.dialogTable.reloadData()
                
                if let messageList = self?.messageList, messageList.count > 0 {
                    let index = IndexPath(row: messageList.count - 1, section: 0)
                    self?.dialogTable.scrollToRow(at: index, at: .bottom, animated: true)
                }
                
                if self?.messageList.count == 0 {
                    self?.noMessagesLabel.isHidden = false
                } else {
                    self?.noMessagesLabel.isHidden = true
                }
            }
        }
        
        sendMessageButton.isEnabled = false
        textToSend.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
        setTheme()
    }
    
    func setTheme() {
        let theme = ThemesManager.getTheme()
        
        view.backgroundColor = theme.getBackGroundColor
        dialogTable.backgroundColor = theme.getBackGroundColor
        
        sendMessageView.backgroundColor = theme.getNavigationBarColor
        textToSend.backgroundColor = theme.getBackGroundColor
        
        noMessagesLabel.textColor = theme.getTextColor
        textToSend.textColor = theme.getTextColor
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        guard let text = textField.text,
              !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            sendMessageButton.isEnabled = false
            return
        }
        sendMessageButton.isEnabled = true
    }

    func prepareView(with inputCell: ConversationCellDataModel) {
        title = inputCell.name
        currentChat = inputCell
        reference = dataBase.collection("channels/\(inputCell.identifier)/messages")
    }
}

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageData = messageList[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MessageCell
        else {
            return UITableViewCell()
        }
        cell.configure(with: messageData)
        return cell
    }
}
