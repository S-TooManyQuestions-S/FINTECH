//
//  SettingsViewController.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 10.03.2021.
//

import UIKit

class ThemesViewController: UIViewController {
    
    /*
     При работе с данным View может возникнуть retain Cycle, если в замыкании мы обращаемся к self
     полям иного класса по strong ссылкам, тем самым, объекты, на которые ничто больше не ссылается
     не могут быть удалены, остаются захвачены в замыкании, например класс из которого мы вызываем данный контроллер,
     если бы мы не использовали weak ссылки, то получили бы retain cycle, то есть в root View имели бы указатель на
     ThemesViewController, а в ThemesViewController имели бы обращения к self полям root View - получился бы цикл,
     который нельзя удалить
     
     rootView -> themesView -> (captured) rootView.field
     */
    
    var themeHandlerClosure:(()->Void)?
    var themePickerDelegate:ThemesPickerDelegate?
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var classicLabel: UILabel!
    @IBOutlet weak var nightLabel: UILabel!
    
    @IBOutlet weak var classicThemeView: UIView!
    @IBOutlet weak var classicThemeInput: UIView!
    @IBOutlet weak var classicThemeOutput: UIView!
    
    @IBOutlet weak var dayThemeView: UIView!
    @IBOutlet weak var dayThemeInput: UIView!
    @IBOutlet weak var dayThemeOutput: UIView!
    
    @IBOutlet weak var nightThemeView: UIView!
    @IBOutlet weak var nightThemeInput: UIView!
    @IBOutlet weak var nightThemeOutput: UIView!
    
    @IBAction func classicThemeButtonPressed(_ sender: Any) {
        resetBorders(currentThemeView: classicThemeView)
        ThemesManager.applyTheme(theme: .classic)
        //themePickerDelegate?.useCurrentTheme() - uncomment for delegate use
        themeHandlerClosure?()
        applyToCurrentView()
    }
    
    @IBAction func dayThemeButtonPressed(_ sender: Any) {
        resetBorders(currentThemeView: dayThemeView)
        ThemesManager.applyTheme(theme: .day)
        //themePickerDelegate?.useCurrentTheme() - uncomment for delegate use
        themeHandlerClosure?()
        applyToCurrentView()
    }
    @IBAction func nightThemeButtonPressed(_ sender: Any) {
        resetBorders(currentThemeView: nightThemeView)
        ThemesManager.applyTheme(theme: .night)
        //hemePickerDelegate?.useCurrentTheme() - uncomment for delegate use
        themeHandlerClosure?()
        applyToCurrentView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        title = "Settings"
        prepareViews()
        applyToCurrentView()
    }
    
    func applyToCurrentView(){
        let currentTheme = ThemesManager.currentTheme()
        view.backgroundColor = currentTheme.getBackGroundColor
        dayLabel.textColor = currentTheme.getTextColor
        classicLabel.textColor = currentTheme.getTextColor
        nightLabel.textColor = currentTheme.getTextColor
        
    }
}


extension ThemesViewController{
    
    func prepareViews(){
        prepareView(parentView: classicThemeView, firstChild: classicThemeInput, secondChild: classicThemeOutput, theme: .classic)
        prepareView(parentView: dayThemeView, firstChild: dayThemeInput, secondChild: dayThemeOutput, theme: .day)
        prepareView(parentView: nightThemeView, firstChild: nightThemeInput, secondChild: nightThemeOutput, theme: .night)
        outlineCurrentTheme()
        
    }
    
    func prepareView(parentView: UIView, firstChild:UIView, secondChild:UIView, theme:Theme){
        parentView.backgroundColor = theme.getBackGroundColor
        firstChild.backgroundColor = theme.getInputMessageColor
        secondChild.backgroundColor = theme.getOutPutMessageColor
        
        parentView.layer.cornerRadius = parentView.frame.height * 14/40
        firstChild.layer.cornerRadius = firstChild.frame.height * 14/40
        secondChild.layer.cornerRadius = secondChild.frame.height * 14/40
        
        parentView.layer.borderWidth = 1
        parentView.layer.borderColor = UIColor.systemGray.cgColor
    }
    
    func outlineCurrentTheme(){
        switch ThemesManager.currentTheme(){
        case .classic:
            classicThemeView.layer.borderColor = UIColor.systemBlue.cgColor
            classicThemeView.layer.borderWidth = 3
        case .day:
            dayThemeView.layer.borderColor = UIColor.systemBlue.cgColor
            dayThemeView.layer.borderWidth = 3
        case .night:
            nightThemeView.layer.borderColor = UIColor.systemBlue.cgColor
            nightThemeView.layer.borderWidth = 3
        }
    }
    
    func resetBorders(currentThemeView:UIView){
        for view in [classicThemeView, dayThemeView, nightThemeView]{
            view?.layer.borderColor = UIColor.systemGray.cgColor
            view?.layer.borderWidth = 1
        }
        currentThemeView.layer.borderWidth = 3
        currentThemeView.layer.borderColor = UIColor.systemBlue.cgColor
    }
}
