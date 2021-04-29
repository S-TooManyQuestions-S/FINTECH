//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 16.02.2021.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // indicatorViews
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    // buttons
    @IBOutlet weak var saveOperationButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveGCDButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    // UIViews
    @IBOutlet weak var saveButtonsView: UIView!
    @IBOutlet weak var userIcon: UIView!
    
    // Labels
    @IBOutlet weak var iconLabel: UILabel!
    
    // ImageViews
    @IBOutlet weak var userImage: UIImageView!

    // TextView
    @IBOutlet weak var describeLabel: UITextView!
    
    // TextFields
    @IBOutlet weak var nameLabel: UITextField!
    
    // other constants
    let pickerController = UIImagePickerController()
    let loadSaveHandlers = (GCD: GCDSaveHandler(),
                             Operation: OperationSaveHandler())
    
    // variables
    var savedUserData: UserProfileProtocol = UserProfile(fullName: "ФИО",
                                                         description: "Your description goes here",
                                                         profileImage: UIImage())
    
    // IBActions
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        prepareForCurrentMode(editingMode: false)
        loadData()
    }
    
    @IBAction func saveDataUsingGCDButtonPressed(_ sender: Any) {
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        
        self.loadSaveHandlers.GCD.writeData(newData: UserProfile(fullName: self.nameLabel.text,
                                                                description: self.describeLabel.text,
                                                                profileImage: self.userImage.image),
                                           completion: self.showSaveAlert(isSuccessfull:isGCDUsed:))
        
        self.prepareForCurrentMode(editingMode: false)
        // self.editButton.isEnabled = false
        
    }
    
    @IBAction func saveDataUsingOperationsButtonPressed(_ sender: Any) {
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        
        self.loadSaveHandlers.Operation.writeData(newData: UserProfile(fullName: self.nameLabel.text,
                                                                description: self.describeLabel.text,
                                                                profileImage: self.userImage.image),
                                           completion: self.showSaveAlert(isSuccessfull:isGCDUsed:))
        
        self.prepareForCurrentMode(editingMode: false)
        // self.editButton.isEnabled = false
    }
    
    var edit: Bool = false
    
    @IBAction func editButtonTouched(_ sender: Any) {
        if edit {
           cancelButtonPressed(self)
        } else {
            prepareForCurrentMode(editingMode: true)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Logger.logFieldValue(field: "editButton", value: "\(editButton.frame)", in: #function)
        
        /* Размеры frame'ов разные, главной причиной данных отличий является рассчет фреймов непосрдественно после добавления subview's,
            на момент viewDidLoad они добавлены не были,
            а значит и рассчет их рамзеров не производился (размер их такой же как и в IB)
        */
        
        /* правильное описание:
            В данный момент View уже отобразилась на экране устройства.
            Уже отработал механизм autolayout для текущего устройства.
            Так как в сториборд файле и эмуляторе выбраны устройства с разными экранами (iphone se 2 и iphone 11), то и фреймы editButton в них разные
        */
       
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // установка закргуленных углов у view, которое представляет аватарку пользователя
        userIcon?.layer.cornerRadius = userIcon.frame.size.height / 2
        // установка закругленных углов у пока скрытой UIImageView, в которую (по желанию пользователя будет сохранена фотография
        userImage?.layer.cornerRadius = userImage.frame.size.height / 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleImageTap(_:)))
        userIcon.addGestureRecognizer(tap)
        
        nameLabel.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)

        /* Правильное описание:
         В данный момент View только загрузилась из связанного storyboard файла и frame указаны в соответствии с текущими значениями для выбранного в сториборд устройстве.*/
        Logger.logFieldValue(field: "editButton", value: "\(editButton.frame)", in: #function)
        
        // регулируем размеры шрифта в зависимости от размера iconView
        iconLabel?.font = UIFont.systemFont(ofSize: userIcon.frame.width / 2)
        
        // устанавливаем закругленные углы у кнопки "Edit"
        editButton?.layer.cornerRadius = 14
        saveGCDButton?.layer.cornerRadius = 14
        saveOperationButton?.layer.cornerRadius = 14
        cancelButton?.layer.cornerRadius = 14
        
        describeLabel.delegate = self
        
        // для корректной работы выбора фотографии из галлереи
        pickerController.delegate = self
        
        useCurrentTheme()
        
        loadingIndicator.isHidden = false
        loadingIndicator.color = .red
        loadData()
    }
}

// data manipulations extentension
extension ProfileViewController {
    
    @objc func editingChanged(_ textField: Any) {
        if let nameLabel = textField as? UITextField {
            guard nameLabel.text != savedUserData.fullName else {
                return
            }
            saveGCDButton.isEnabled = true
            saveOperationButton.isEnabled = true
        }
        
    }
    
    func loadData() {
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        loadSaveHandlers.GCD.readData(setUpProfile(loadedProfile:))
    }
    
    func setUpProfile(loadedProfile: UserProfileProtocol) {
        savedUserData = loadedProfile
        if let fullName = savedUserData.fullName {
            nameLabel.text = fullName
        } else {
            nameLabel.text = "ФИО"
        }
        
        if let description = savedUserData.description {
            describeLabel.text = description
        } else {
            describeLabel.text = "Your information goes here"
        }
        
        if let profileImage = savedUserData.profileImage {
            userImage.isHidden = false
            userImage.image = profileImage
        } else {
            userImage.isHidden = true
        }
        loadingIndicator.stopAnimating()
    }
    
    // так как текущих состояний экрана всего два - переменная типа bool, но в дальнейшем можно сделать enum
    // для нескольких состояний View
    
    func enableEditMode() {
        saveButtonsView.isHidden = false
      //  editButton.isHidden = true
        
        nameLabel.isUserInteractionEnabled = true
        describeLabel.isUserInteractionEnabled = true
        describeLabel.isEditable = true
        
        let newPosition = nameLabel.endOfDocument
        nameLabel.selectedTextRange = nameLabel.textRange(from: newPosition, to: newPosition)
        nameLabel.becomeFirstResponder()
    }
    
    func enableStandardMode() {
        saveButtonsView.isHidden = true
       // editButton.isHidden = false
        
        nameLabel.isUserInteractionEnabled = false
        describeLabel.isUserInteractionEnabled = false
        describeLabel.isEditable = false
    }
    
    func prepareForCurrentMode(editingMode: Bool) {
        if editingMode {
            enableEditMode()
            edit = true
        } else {
            enableStandardMode()
            edit = false
        }
        animation()
        saveGCDButton.isEnabled = false
        saveOperationButton.isEnabled = false
    }
    
    func showSuccessAlert(isGCDUsed: Bool) {
        let alert = UIAlertController(title: "Success!", message: "Your profile information was successfully saved!", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: {
            self.prepareForCurrentMode(editingMode: false)
            self.loadingIndicator.stopAnimating()
            self.loadData()
        })
        self.editButton.isEnabled = true
    }
    
    func showFailAlert(isGCDUsed: Bool) {
        let alert = UIAlertController(title: "Failed!",
                                      message: "Your profile information wasn't saved due to occuried error!\nWould you like to try again?",
                                      preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Try again", style: UIAlertAction.Style.default, handler: {_ in
            
            if isGCDUsed {
                self.loadSaveHandlers.GCD.writeData(newData: UserProfile(fullName: self.nameLabel.text,
                                                                         description: self.describeLabel.text,
                                                                         profileImage: self.userImage.image),
                                                    completion: self.showSaveAlert(isSuccessfull:isGCDUsed:))
            } else {
                self.loadSaveHandlers.Operation.writeData(newData: UserProfile(fullName: self.nameLabel.text,
                                                                               description: self.describeLabel.text,
                                                                               profileImage: self.userImage.image),
                                                          completion: self.showSaveAlert(isSuccessfull:isGCDUsed:))
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {_ in
            self.prepareForCurrentMode(editingMode: false)
            self.loadSaveHandlers.GCD.writeData(newData: self.savedUserData, completion: {_, _ in return})
            self.setUpProfile(loadedProfile: self.savedUserData)
        }))
        
        self.present(alert, animated: true, completion: {
            self.loadingIndicator.stopAnimating()
        })
        
        self.editButton.isEnabled = true
    }
    
    func showSaveAlert(isSuccessfull: Bool, isGCDUsed: Bool) {
        if isSuccessfull {
            showSuccessAlert(isGCDUsed: isGCDUsed)
        } else {
            showFailAlert(isGCDUsed: isGCDUsed)
        }
    }
}

// theme settings extension
extension ProfileViewController {
    func useCurrentTheme() {
        let theme = RootAssembly.serviceAssembly.themeHandler.getTheme()
        
        editButton.backgroundColor = theme.getNavigationBarColor
        
        view.backgroundColor = theme.getBackGroundColor
        
        describeLabel.textColor = theme.getTextColor
        describeLabel.backgroundColor = theme.getBackGroundColor
        
        nameLabel.textColor = theme.getTextColor
        
        saveGCDButton.backgroundColor = theme.getNavigationBarColor
        saveOperationButton.backgroundColor = theme.getNavigationBarColor
        
        cancelButton.backgroundColor = theme.getNavigationBarColor
    }
}

// image picker extension
extension ProfileViewController {
    /**
     Функция реализующая логику установки фотографии профиля при выборе пользователем категории "choose from gallery"
     */
    func chooseFromGallery() {
        // проверка доступности галлереи
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Warning", message: "Photo library is currently unvailable", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Resume", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /**
     Функция реализующая логику установки фотографии профиля при выборе пользователем категории "make a photo"
     */
    func makeAPhoto() {
        // проверяем доступна ли камера
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
            
        } else {
            // если камера недоступна - выводим предупреждение с соответствующей пояснительной информацией
            let alert = UIAlertController(title: "Warning", message: "Camera is currently unvailable", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Resume", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /**
     Функция для обработки выбора пользователем фотографии из галлереи (или сделанное фото) (отображение ее в качестве текущей фотографии профиля)
     
     **Parameters:**
     - picker: контроллер для обработки выбора
     - info: информация о выборе
     */
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        pickerController.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
            userImage.image = image
            // delegate?.displayLogo(image)
            userImage.isHidden = false
            
            saveGCDButton.isEnabled = true
            saveOperationButton.isEnabled = true
        }
    }
    
    @objc func handleImageTap(_ sender: UITapGestureRecognizer? = nil) {
        guard editButton.isHidden else {return}
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        // удаляем ошибочно выставленный констрейнт
        // alert.removeRedundantConstraint()
        // создание actionSheet с возможными путями задания фотографии пользователя (выбор из галлереи или снимок)
        alert.addAction(UIAlertAction(title: "Choose from gallery", style: .default, handler: { (_)in
            self.chooseFromGallery()
        }))
        alert.addAction(UIAlertAction(title: "Make a photo", style: .default, handler: { (_)in
            self.makeAPhoto()
        }))
        alert.addAction(UIAlertAction(title: "Download", style: .default, handler: {(_) in
            self.performSegue(withIdentifier: "toImagePickerCollectionView", sender: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_)in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationController = segue.destination as? ImagePickerCollectionViewController {
            destinationController.imagePicker = self
        }
    }
}

extension ProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text != savedUserData.description {
            saveGCDButton.isEnabled = true
            saveOperationButton.isEnabled = true
        }
    }
}

extension ProfileViewController: ImagePickerDelegate {
    func pickNetImage(image: UIImage) {
        userImage.image = image
        userImage.isHidden = false
        
        saveGCDButton.isEnabled = true
        saveOperationButton.isEnabled = true
    }
}

extension ProfileViewController {
    
    func animation() {
        let startPosition = self.editButton.center
        let x = startPosition.x
        let y = startPosition.y
        
        if self.edit {
            UIView.animateKeyframes(withDuration: 0.3,
                                    delay: 0.0, options: [.repeat, .allowUserInteraction]) {
                UIView.addKeyframe(withRelativeStartTime: 0.0,
                                   relativeDuration: 0.06,
                                   animations: {
                                    self.editButton.layer.position.y = y + 5
                                    self.editButton.layer.position.x = x + 5
                                    self.editButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 180 * 18)
                                   })
                UIView.addKeyframe(withRelativeStartTime: 0.06,
                                   relativeDuration: 0.06,
                                   animations: {
                                    self.editButton.layer.position.y = y - 5
                                   })
                
                UIView.addKeyframe(withRelativeStartTime: 0.12,
                                   relativeDuration: 0.06,
                                   animations: {
                                    self.editButton.layer.position.y = y - 5
                                    self.editButton.layer.position.x = x - 5
                                    self.editButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 180 * -18)
                                   })
                UIView.addKeyframe(withRelativeStartTime: 0.18,
                                   relativeDuration: 0.06,
                                   animations: {
                                    self.editButton.layer.position.y = y + 5
                                   })
                
                UIView.addKeyframe(withRelativeStartTime: 0.24,
                                   relativeDuration: 0.06,
                                   animations: {
                                    self.editButton.layer.position.x = x
                                    self.editButton.layer.position.y = y
                                    self.editButton.transform = CGAffineTransform(rotationAngle: 0)
                                   })
            }
        } else {
            UIView.animateKeyframes(withDuration: 1,
                                    delay: 0.0, options: [.allowUserInteraction]) {
                UIView.addKeyframe(withRelativeStartTime: 0.0,
                                   relativeDuration: 1,
                                   animations: {
                                    self.editButton.layer.removeAllAnimations()
                                    self.editButton.center = startPosition
                                    self.editButton.transform = CGAffineTransform(rotationAngle: 0)
                                   })
            }
        }
    }
    
}

/*
extension UIAlertController{
    func removeRedundantConstraint(){
        for subView in self.view.subviews {
            for constraint in subView.constraints where
                constraint.debugDescription.contains("width == - 16"){
                subView.removeConstraint(constraint)
            }
        }
    }
}
*/

/*
required init?(coder: NSCoder) {
    super.init(coder: coder)
    Logger.logProcess(fullDescription: "Edit button frame in <init?> is: \(editButton.frame)")
    На данном этапе editButton имеет значение nil
    Правильное описание: view еще не загрузилась - дочерние вьюшки еще не существуют, тоесть nil.

    Когда вы перетаскиваете объект на раскадровку и настраиваете его,
    Interface Builder сериализует состояние этого объекта на диске,
    а затем десериализует его, когда раскадровка появляется на экране.
    Вам нужно рассказать Interface Builder, как это сделать,
    для этого вызывается метод init, однако при вызове кнопка editButton еще не инициализирована, десериализация только началась
}
*/
