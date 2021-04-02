//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 02.03.2021.
//

import UIKit
import Firebase

class ConversationsListViewController: UIViewController, ThemesPickerDelegate {
    @IBOutlet weak var addNewChanelButton: UIButton!
    
    @IBAction func addNewChanelButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Add New Channel:", message: "", preferredStyle: .alert)
            alertController.addTextField { (textField: UITextField!) -> Void in
                textField.placeholder = "Enter Channel Name"
            }
        
            let saveAction = UIAlertAction(title: "Save", style: .default, handler: { _ -> Void in
                if let textField = alertController.textFields?[0],
                   let textOfField = textField.text,
                   !textOfField.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    self.reference.addDocument(data: ["name": textField.text ?? ""])
                } else {
                    self.errorByCreatingNewChannel()
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (_: UIAlertAction!) -> Void in })

            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
    }
    
    func errorByCreatingNewChannel() {
        let alert = UIAlertController(title: "Error by creating new channel",
                                      message: "Remember, that channel name can not be whitespace!", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var messageTable: UITableView!
    
    lazy var dataBase = Firestore.firestore()
    lazy var reference = dataBase.collection("channels")
    
    private let cellIdentifier = String(describing: ConversationCell.self)
    private var listOfChannels: [ConversationCellDataModel] = []
    
    private var fireBaseConnectionHandler = FireBaseHandler.shared
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "Settings", sender: nil)
    }
    @IBAction func profileButtonPressed(_ sender: Any) {
         performSegue(withIdentifier: "ProfileID", sender: nil)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        messageTable.delegate = self
        messageTable.dataSource = self
        messageTable.register(UINib(nibName: String(describing: ConversationCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        useCurrentTheme()
        
        reference.addSnapshotListener {[weak self] snapshot, _ in
            if let documents = snapshot?.documents {
                guard let receivedChannels = self?.fireBaseConnectionHandler.receiveChannels(
                        from: documents) else {return}
                self?.listOfChannels = receivedChannels
            }
            self?.messageTable.reloadData()
        }
        title = "Tinkoff Chat"
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case "SegueToDialog":
            guard
                let currentCellData = sender as? ConversationCellDataModel,
                let destinationController = segue.destination as? ConversationViewController
            else {
                return
            }
            destinationController.prepareView(with: currentCellData)
        case "Settings":
            guard
                let destinationController = segue.destination as? ThemesViewController
            else {
                return
            }
            destinationController.themePickerDelegate = self
            destinationController.themeHandlerClosure = {
                            [weak self] in
                            self?.useCurrentTheme()
                        }
        default:
            return
        }
    }
}

// everything connected with tableView
extension ConversationsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfChannels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageData = listOfChannels[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConversationCell
        else {
            return UITableViewCell()
        }
        cell.configure(with: messageData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        messageTable.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "SegueToDialog", sender: listOfChannels[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
        return "Channels"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = ThemesManager.getTheme().getTextColor
            header.contentView.backgroundColor = ThemesManager.getTheme().getNavigationBarColor
        }
    }
}

// everything connected with current Theme
extension ConversationsListViewController {
    func useCurrentTheme() {
        applyColors()
        messageTable.reloadData()
    }
    
    func applyColors() {
        
        let theme = ThemesManager.getTheme()
        
        view.backgroundColor = theme.getBackGroundColor
        messageTable.backgroundColor = theme.getBackGroundColor
        
        navigationController?.navigationBar.backgroundColor = theme.getBackGroundColor
        navigationController?.navigationBar.barTintColor = theme.getNavigationBarColor
        navigationController?.navigationBar.tintColor = theme.getTextColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: theme.getTextColor]
        
        addNewChanelButton.backgroundColor = theme.getNavigationBarColor
        addNewChanelButton.layer.cornerRadius = addNewChanelButton.frame.height / 2
        addNewChanelButton.tintColor = theme.getTextColor
    }
}
