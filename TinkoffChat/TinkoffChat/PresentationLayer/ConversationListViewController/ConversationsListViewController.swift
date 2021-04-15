//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 02.03.2021.
//

import UIKit
import Firebase
import CoreData

class ConversationsListViewController: UIViewController, ThemesPickerDelegate {
    
    private let cellIdentifier = String(describing: ConversationCell.self)
    private var conversationListModel: ConversationListModelProtocol?
    
    // Buttons:
    @IBOutlet weak var addNewChanelButton: UIButton!
    @IBOutlet weak var userButton: UIButton!
    
    // TableView:
    @IBOutlet weak var messageTable: UITableView!
    
    lazy var fetchedResultController: NSFetchedResultsController<Channel> = {
        let request: NSFetchRequest<Channel> = Channel.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "lastActivity_db", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        request.resultType = .managedObjectResultType
        request.fetchBatchSize = 20
        
        let fetchedResultsController = RootAssembly.coreLayerAssembly.coreDataStackHandler.getFetchedResultController(with: request)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "Settings", sender: nil)
    }
    
    @IBAction func profileButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "ProfileID", sender: nil)
    }
    
    @IBAction func addNewChanelButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Add New Channel:", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Enter Channel Name"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { _ -> Void in
            if let textField = alertController.textFields?[0],
               let textOfField = textField.text,
               !textOfField.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                self.conversationListModel?.addNewChannel(with: textOfField)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.navigationController?.navigationBar.isTranslucent = true
        //        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        messageTable.delegate = self
        messageTable.dataSource = self
        
        conversationListModel = ConversationListModel(fetchedResultsController: self.fetchedResultController)
        messageTable.register(UINib(nibName: String(describing: ConversationCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        useCurrentTheme()
        
        try? fetchedResultController.performFetch()
        title = "Tinkoff Chat"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case "SegueToDialog":
            guard
                let currentCellData = sender as? Channel,
                let destinationController = segue.destination as? ConversationViewController
            else {
                return
            }
            if let id = currentCellData.identifier_db,
               let name = currentCellData.name_db {
                destinationController.prepareView(with: .init(id: id,
                                                              name: name,
                                                              lastMessage: currentCellData.lastMessage_db,
                                                              lastActivity: currentCellData.lastActivity_db))
            }
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

// everything connected with tableViewDelegate
extension ConversationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "SegueToDialog", sender: fetchedResultController.object(at: indexPath))
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            let currentTheme = RootAssembly.serviceAssembly.themeHandler.getTheme()
            header.textLabel?.textColor = currentTheme.getTextColor
            header.contentView.backgroundColor = currentTheme.getNavigationBarColor
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
        
        let theme = RootAssembly.serviceAssembly.themeHandler.getTheme()
        
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

extension ConversationsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultController.sections else {
            return 0
        }
        
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConversationCell,
              let channel = getItem(by: indexPath)
        else {
            return UITableViewCell()
        }
        
        cell.configure(with: channel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection
                    section: Int) -> String? {
        return "Channels"
    }
    
    func getItem(by index: IndexPath) -> ConversationCellDataModel? {
        
        let channel = self.fetchedResultController.object(at: index)
        guard
            let id = channel.identifier_db,
            let name = channel.name_db
        else {
            return nil
        }
        return .init(id: id,
                     name: name,
                     lastMessage: channel.lastMessage_db,
                     lastActivity: channel.lastActivity_db)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { [weak self] (_: UIContextualAction, _: UIView, success: (Bool) -> Void) in
            if let channel = self?.getItem(by: indexPath) {
                self?.conversationListModel?.deleteChannel(with: channel)
            }
            success(true)
        }
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        
        case .insert:
            if let newIndexPath = newIndexPath {
                messageTable.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath,
               let newIndexPath = newIndexPath {
                messageTable.deleteRows(at: [indexPath], with: .automatic)
                messageTable.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                messageTable.reloadRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                messageTable.deleteRows(at: [indexPath], with: .automatic)
            }
        default:
            break
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.messageTable.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.messageTable.endUpdates()
    }
}
