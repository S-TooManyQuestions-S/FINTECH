//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 16.02.2021.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //var delegate: LogoDelegate?
    //инициалы пользователя при отсутсвующей фотографии пользователя
    @IBOutlet weak var iconLabel: UILabel!
    //фотография профиля пользователя (default isHidden - true)
    @IBOutlet weak var userImage: UIImageView!
    //View представляющая собой фото профиля пользовтеля (если его нет - инициалы)
    @IBOutlet weak var userIcon: UIView!
    //кнопка смены фото профиля
    @IBOutlet weak var editButton: UIButton!
    
    let pickerController = UIImagePickerController()
    
    @IBAction func editUserIcon(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        //удаляем ошибочно выставленный констрейнт
        //alert.removeRedundantConstraint()
        //создание actionSheet с возможными путями задания фотографии пользователя (выбор из галлереи или снимок)
        alert.addAction(UIAlertAction(title: "Choose from gallery", style: .default , handler:{ (UIAlertAction)in
            self.chooseFromGallery()
        }))
        alert.addAction(UIAlertAction(title: "Make a photo", style: .default , handler:{ (UIAlertAction)in
            self.makeAPhoto()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /**
    Функция реализующая логику установки фотографии профиля при выборе пользователем категории "choose from gallery"
    */
    func chooseFromGallery(){
        //проверка доступности галлереи
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
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
    func makeAPhoto(){
        //проверяем доступна ли камера
        if (UIImagePickerController.isSourceTypeAvailable(.camera)){
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
        } else {
            //если камера недоступна - выводим предупреждение с соответствующей пояснительной информацией
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
        if let image = info[.originalImage] as? UIImage{
            userImage.image = image
            //delegate?.displayLogo(image)
            userImage.isHidden = false
        }
    }
    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
        //Logger.logProcess(fullDescription: "Edit button frame in <init?> is: \(editButton.frame)")
        //На данном этапе editButton имеет значение nil
        //Правильное описание: view еще не загрузилась - дочерние вьюшки еще не существуют, тоесть nil.
    
        //Когда вы перетаскиваете объект на раскадровку и настраиваете его, Interface Builder сериализует состояние этого объекта на диске, а затем десериализует его, когда раскадровка появляется на экране. Вам нужно рассказать Interface Builder, как это сделать, для этого вызывается метод init, однако при вызове кнопка editButton еще не инициализирована, десериализация только началась
   // }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Logger.logFieldValue(field: "editButton", value: "\(editButton.frame)", in: #function)
        //Размеры frame'ов разные, главной причиной данных отличий является рассчет фреймов непосрдественно после добавления subview's, на момент viewDidLoad они добавлены не были, а значит и рассчет их рамзеров не производился (размер их такой же как и в IB)
        //правильное описание: В данный момент View уже отобразилась на экране устройства. Уже отработал механизм autolayout для текущего устройства. Так как в сториборд файле и эмуляторе выбраны устройства с разными экранами (iphone se 2 и iphone 11), то и фреймы editButton в них разные
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Правильное описание: В данный момент View только загрузилась из связанного storyboard файла и frame указаны в соответствии с текущими значениями для выбранного в сториборд устройстве.
        Logger.logFieldValue(field: "editButton", value: "\(editButton.frame)", in: #function)
    
        //установка закргуленных углов у view, которое представляет аватарку пользователя
        userIcon?.layer.cornerRadius = userIcon.frame.size.height/2
        //установка закругленных углов у пока скрытой UIImageView, в которую (по желанию пользователя будет сохранена фотография
        userImage?.layer.cornerRadius = userImage.frame.size.height/2
        //регулируем размеры шрифта в зависимости от размера iconView
        iconLabel?.font = UIFont.systemFont(ofSize: userIcon.frame.width / 2)
        //устанавливаем закругленные углы у кнопки "Edit"
        editButton?.layer.cornerRadius = 14
        //для корректной работы выбора фотографии из галлереи
        pickerController.delegate = self
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


