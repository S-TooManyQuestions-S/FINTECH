//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 03.03.2021.
//

import UIKit

class ConversationViewController: ViewController {
    @IBOutlet weak var dialogTable: UITableView!
    
    private let cellIdentifier = String(describing: MessageCell.self)
    private static let testMessages = [
        MessageCellDataModel(message: nil, typeOf: .received),
        MessageCellDataModel(message: "Dm me as soon as possible, I have some business to discuss :0", typeOf: .received),
        MessageCellDataModel(message: "Hi, bro, everything's fine, holding up, what's up?", typeOf: .sent),
        MessageCellDataModel(message: "Bro, where have you been, the work is almost done, I need you here rn!", typeOf: .received),
        MessageCellDataModel(message: "Ok, coming!", typeOf: .sent),
        MessageCellDataModel(message: "terminating app due to uncaught exception 'nsinternalinconsistencyexception', reason: 'invalid nib registered for identifier (messagecell) - nib must contain exactly one top level object which must be a uitableviewcell instanceterminating app due to uncaught exception 'nsinternalinconsistencyexception', reason: 'invalid nib registered for identifier (messagecell) - nib must contain exactly one top level object which must be a uitableviewcell instanceterminating app due to uncaught exception 'nsinternalinconsistencyexception', reason: 'invalid nib registered for identifier (messagecell) - nib must contain exactly one top level object which must be a uitableviewcell instance", typeOf: .sent),
        MessageCellDataModel(message: "Dm me as soon as possible, I have some business to discuss :0", typeOf: .received),
        MessageCellDataModel(message: "Hi, bro, everything's fine, holding up, what's up?", typeOf: .sent),
        MessageCellDataModel(message: "Bro, where have you been, the work is almost done, I need you here rn!",typeOf: .received),
        MessageCellDataModel(message: "Ok, coming!", typeOf: .sent),
        MessageCellDataModel(message: "Dm me as soon as possible, I have some business to discuss :0", typeOf: .received),
        MessageCellDataModel(message: "terminating app due to uncaught exception 'nsinternalinconsistencyexception', reason: 'invalid nib registered for identifier (messagecell) - nib must contain exactly one top level object which must be a uitableviewcell instanceterminating app due to uncaught exception 'nsinternalinconsistencyexception', reason: 'invalid nib registered for identifier (messagecell) - nib must contain exactly one top level object which must be a uitableviewcell instanceterminating app due to uncaught exception 'nsinternalinconsistencyexception', reason: 'invalid nib registered for identifier (messagecell) - nib must contain exactly one top level object which must be a uitableviewcell instance", typeOf: .sent),
        MessageCellDataModel(message: "Bro, where have you been, the work is almost done, I need you here rn!", typeOf: .received),
        MessageCellDataModel(message: "Ok, coming!", typeOf: .sent),
        MessageCellDataModel(message: "Dm me as soon as possible, I have some business to discuss :0", typeOf: .received),
        MessageCellDataModel(message: "Hi, bro, everything's fine, holding up, what's up?", typeOf: .sent),
        MessageCellDataModel(message: "Bro, where have you been, the work is almost done, I need you here rn!", typeOf: .received),
        MessageCellDataModel(message: "Ok, coming!", typeOf: .sent),
        MessageCellDataModel(message: "Dm me as soon as possible, I have some business to discuss :0", typeOf: .received),
        MessageCellDataModel(message: "Hi, bro, everything's fine, holding up, what's up?", typeOf: .sent),
        MessageCellDataModel(message: "Bro, where have you been, the work is almost done, I need you here rn!", typeOf: .received),
        MessageCellDataModel(message: "terminating app due to uncaught exception 'nsinternalinconsistencyexception', reason: 'invalid nib registered for identifier (messagecell) - nib must contain exactly one top level object which must be a uitableviewcell instanceterminating app due to uncaught exception 'nsinternalinconsistencyexception', reason: 'invalid nib registered for identifier (messagecell) - nib must contain exactly one top level object which must be a uitableviewcell instanceterminating app due to uncaught exception 'nsinternalinconsistencyexception', reason: 'invalid nib registered for identifier (messagecell) - nib must contain exactly one top level object which must be a uitableviewcell instance", typeOf: .sent),
        MessageCellDataModel(message: "Dm me as soon as possible, I have some business to discuss :0", typeOf: .received),
        MessageCellDataModel(message: "Hi, bro, everything's fine, holding up, what's up?", typeOf: .sent),
        MessageCellDataModel(message: "Bro, where have you been, the work is almost done, I need you here rn!", typeOf: .received),
        MessageCellDataModel(message: "Ok, coming!", typeOf: .sent),
        MessageCellDataModel(message: "Dm me as soon as possible, I have some business to discuss :0", typeOf: .received),
        MessageCellDataModel(message: "Hi, bro, everything's fine, holding up, what's up?", typeOf: .sent),
        MessageCellDataModel(message: "Bro, where have you been, the work is almost done, I need you here rn!", typeOf: .received),
        MessageCellDataModel(message: "Ok, coming!", typeOf: .sent)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dialogTable.delegate = self
        dialogTable.dataSource = self
        
        dialogTable.register(UINib(nibName: String(describing: MessageCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
    }

    func prepareView(with inputCell: ConversationCellDataModel){
        title = inputCell.name == nil ? "Unknown User" : inputCell.name
    }
}


extension ConversationViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ConversationViewController.testMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageData = ConversationViewController.testMessages[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MessageCell
        else{
            return UITableViewCell()
        }
        cell.configure(with: messageData)
        return cell
    }
}
