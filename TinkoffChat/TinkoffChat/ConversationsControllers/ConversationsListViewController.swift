//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 02.03.2021.
//

import UIKit

class ConversationsListViewController: UIViewController, ThemesPickerDelegate{

    @IBOutlet weak var userButton: UIButton!
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "Settings", sender: nil)
    }
    
    @IBAction func profileButtonPressed(_ sender: Any) {
         performSegue(withIdentifier: "ProfileID", sender: nil)
    }
    @IBOutlet weak var messageTable: UITableView!
    
    private var testMessages = [(Status: "Online", Messages: [ConversationCellDataModel]()), (Status:"History", Messages: [ConversationCellDataModel]())]
    
    private let cellIdentifier = String(describing: ConversationCell.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        messageTable.delegate = self
        messageTable.dataSource = self
        messageTable.register(UINib(nibName: String(describing: ConversationCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        createTestMessages()
        title = "Tinkoff Chat"
        
        useCurrentTheme()
    }
}

extension ConversationsListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testMessages[section].Messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageData = testMessages[indexPath.section].Messages[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConversationCell
        else{
            return UITableViewCell()
        }
        cell.configure(with: messageData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        messageTable.deselectRow(at: indexPath, animated: true)
        
        let message = testMessages[indexPath.section].Messages[indexPath.row]
        performSegue(withIdentifier:"SegueToDialog", sender: message)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
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
            else{
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
        return testMessages[section].Status
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = ThemesManager.getTheme().getTextColor
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    
    func useCurrentTheme() {
        applyColors()
        messageTable.reloadData()
    }
    
    func applyColors(){
        
        let theme = ThemesManager.getTheme()
        
        view.backgroundColor = theme.getBackGroundColor
        messageTable.backgroundColor = theme.getBackGroundColor
        
        navigationController?.navigationBar.backgroundColor = theme.getBackGroundColor
        navigationController?.navigationBar.barTintColor = theme.getNavigationBarColor
        navigationController?.navigationBar.tintColor = theme.getTextColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: theme.getTextColor]
    }
    
}

extension ConversationsListViewController{
    private func createTestMessages(){
        let messages = [
            ConversationCellDataModel(name: "Samarenko Andrew", message: "Hello, what about our previous deal, dm me as soon as possible!", date: getDate(withStringForm: "2021-03-01T11:42"), online: true, hasUnreadMessages: true),
            ConversationCellDataModel(name: "Alexander Samarenko", message: "Let's hang out together, dm me bro", date: Date(), online: true, hasUnreadMessages: false),
            ConversationCellDataModel(name: "Shadi Abdelsalam", message: "Vodka and Chudo is awesome, we should try it again!", date: getDate(withStringForm: "2021-03-04T13:42"), online: true, hasUnreadMessages: true),
            ConversationCellDataModel(name: "Nikita Kazantsev", message: nil, date: Date(), online: true, hasUnreadMessages: false),
            ConversationCellDataModel(name: nil, message: "I am from darknet, we have deal special 4 u, dm us now!", date: getDate(withStringForm: "2021-02-04T13:42"), online: true, hasUnreadMessages: false),
            ConversationCellDataModel(name: "Alexander Vlasyuk", message: "The last one task is pretty hard, we need to cooperate to do it in time, i know, that you are spending almost the whole time with your Tinkoff course, but dm me, deadline is near ASAP", date: getDate(withStringForm: "2021-02-04T16:42"), online: true, hasUnreadMessages: false),
            ConversationCellDataModel(name: "Barnaby Marmaduke Aloysius Benji Cobweb Dartagnan Egbert", message: "Bro, I have the longest name in the world and I can help you to debug your constraints!", date: Date(), online: true, hasUnreadMessages: true),
            ConversationCellDataModel(name: "Mom", message: "I'll visit your grandma, please buy something sweet in shop 4 me :3!", date: Date(), online: true, hasUnreadMessages: true),
            ConversationCellDataModel(name: "Tinkoff Bank", message: "Hello, I am Oleg, how can I help you today?", date: Date(), online: true, hasUnreadMessages: false),
            ConversationCellDataModel(name: "HSE UNIVERSITY", message: "40 Deadlines are ready, 1000 is on their way!", date: getDate(withStringForm: "2021-02-04T17:21"), online: true, hasUnreadMessages: false),
            
            ConversationCellDataModel(name: "Samarenko Andrew", message: "Hello, what about our previous deal, dm me as soon as possible!", date: getDate(withStringForm: "2021-03-01T11:42"), online: false, hasUnreadMessages: true),
            ConversationCellDataModel(name: "Alexander Samarenko", message: "Let's hang out together, dm me bro", date: Date(), online: false, hasUnreadMessages: false),
            ConversationCellDataModel(name: "Shadi Abdelsalam", message: "Vodka and Chudo is awesome, we should try it again!", date: getDate(withStringForm: "2021-03-04T13:42"), online: false, hasUnreadMessages: true),
            ConversationCellDataModel(name: "Nikita Kazantsev", message: nil, date: Date(), online: false, hasUnreadMessages: false),
            ConversationCellDataModel(name: nil, message: "I am from darknet, we have deal special 4 u, dm us now!", date: getDate(withStringForm: "2021-02-04T13:42"), online: false, hasUnreadMessages: false),
            ConversationCellDataModel(name: "Alexander Vlasyuk", message: "The last one task is pretty hard, we need to cooperate to do it in time, i know, that you are spending almost the whole time with your Tinkoff course, but dm me, deadline is near ASAP", date: getDate(withStringForm: "2021-02-04T16:42"), online: false, hasUnreadMessages: false),
            ConversationCellDataModel(name: "Barnaby Marmaduke Aloysius Benji Cobweb Dartagnan Egbert", message: "Bro, I have the longest name in the world and I can help you to debug your constraints!", date: getDate(withStringForm: "XXX"), online: false, hasUnreadMessages: true),
            ConversationCellDataModel(name: "Mom", message: "I'll visit your grandma, please buy something sweet in shop 4 me :3!", date: Date(), online: false, hasUnreadMessages: true),
            ConversationCellDataModel(name: "Tinkoff Bank", message: "Hello, I am Oleg, how can I help you today?", date: Date(), online: false, hasUnreadMessages: false),
            ConversationCellDataModel(name: "HSE UNIVERSITY", message: "40 Deadlines are ready, 1000 is on their way!", date: getDate(withStringForm: "2021-02-04T17:21"), online: false, hasUnreadMessages: false)
        ]
        
        testMessages[0].Messages = messages.filter{message in return message.online}
        testMessages[1].Messages = messages.filter{message in return !message.online}
    }
    
    func getDate(withStringForm: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: withStringForm)
    }
}

