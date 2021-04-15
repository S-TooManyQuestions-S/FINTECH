//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 03.03.2021.
//

import UIKit
import CoreData
import Firebase

class ConversationViewController: UIViewController {
    
    @IBOutlet weak var dialogTableView: UITableView!
    @IBOutlet weak var textToSendTextField: UITextField!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var noMessagesLabel: UILabel!
    @IBOutlet weak var sendMessageView: UIView!
    
    private var currentChat: ConversationCellDataModel?
    private var conversationModel: ConversationModelProtocol?
    
    private let cellIdentifier = String(describing: MessageCell.self)
    
    lazy var fetchedResultController: NSFetchedResultsController<Message> = {
        
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "created_db", ascending: true)
        
        var predicate: NSPredicate?
        if let id = currentChat?.identifier {
            predicate = NSPredicate(format: "channel.identifier_db == %@", id)
        }
        
        request.sortDescriptors = [sortDescriptor]
        request.predicate = predicate
        
        let fetchedResultsController = RootAssembly.coreLayerAssembly.coreDataStackHandler
            .getFetchedResultController(with: request)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    @IBAction func sendMessageButtonPressed(_ sender: Any) {
        
        if let text = self.textToSendTextField.text {
            DispatchQueue.global(qos: .utility).async { [weak self] in
                self?.conversationModel?.sendMessage(with: text)
            }
        }
        textToSendTextField.text = ""
        sendMessageButton.isEnabled = false
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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dialogTableView.delegate = self
        dialogTableView.dataSource = self
        
        navigationItem.backBarButtonItem?.title = "Tinkoff Chat"
        
        dialogTableView.register(UINib(nibName: String(describing: MessageCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        conversationModel = ConversationModel(with: currentChat, updateTable: { [weak self] in
            if let count = self?.fetchedResultController.fetchedObjects?.count,
               count > 0 {
                let index = IndexPath(row: count - 1, section: 0)
                self?.dialogTableView.scrollToRow(at: index, at: .bottom, animated: true)
            }
            
            if let count = self?.fetchedResultController.fetchedObjects?.count,
               count == 0 {
                self?.noMessagesLabel.isHidden = false
            } else {
                self?.noMessagesLabel.isHidden = true
            }
        })
        
        sendMessageButton.isEnabled = false
        textToSendTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
        try? fetchedResultController.performFetch()
        setTheme()
    }
    
    func setTheme() {
        let theme = RootAssembly.serviceAssembly.themeHandler.getTheme()
        
        view.backgroundColor = theme.getBackGroundColor
        dialogTableView.backgroundColor = theme.getBackGroundColor
        
        sendMessageView.backgroundColor = theme.getNavigationBarColor
        textToSendTextField.backgroundColor = theme.getBackGroundColor
        
        noMessagesLabel.textColor = theme.getTextColor
        textToSendTextField.textColor = theme.getTextColor
    }
}

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let objs = fetchedResultController.fetchedObjects else {
            return 0
        }
        return objs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MessageCell,
            let message = getItem(by: indexPath)
        else {
            return UITableViewCell()
        }
        
        cell.configure(with: message)
        return cell
    }
    
    func getItem(by index: IndexPath) -> MessageCellDataModel? {
        let message = self.fetchedResultController.object(at: index)
        
        guard
            let messageId = message.messageId_db,
            let messageContent = message.content_db,
            let created = message.created_db,
            let senderId = message.senderId_db,
            let senderName = message.senderName_db
        else {
            return nil
        }
        return .init(content: messageContent,
                     created: created,
                     senderId: senderId,
                     senderName: senderName,
                     messageId: messageId)
    }
}

extension ConversationViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        
        case .insert:
            if let newIndexPath = newIndexPath {
                dialogTableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath,
               let newIndexPath = newIndexPath {
                dialogTableView.deleteRows(at: [indexPath], with: .automatic)
                dialogTableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                dialogTableView.reloadRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                dialogTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        default:
            break
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.dialogTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.dialogTableView.endUpdates()
    }
}
