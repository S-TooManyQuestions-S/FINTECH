//
//  SettingsViewController.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 10.03.2021.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var classicThemeView: UIView!
    @IBOutlet weak var classicThemeInput: UIView!
    @IBOutlet weak var classicThemeOutput: UIView!
    
    @IBOutlet weak var dayThemeView: UIView!
    @IBOutlet weak var dayThemeInput: UIView!
    @IBOutlet weak var dayThemeOutput: UIView!
    
    @IBOutlet weak var nightThemeView: UIView!
    @IBOutlet weak var nightThemeInput: UIView!
    @IBOutlet weak var nightThemeOutput: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        title = "Settings"
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
        classicThemeView.layer.cornerRadius = classicThemeView.frame.height * 14/40
        classicThemeInput.layer.cornerRadius = classicThemeInput.frame.height * 14/40
        classicThemeOutput.layer.cornerRadius = classicThemeOutput.frame.height * 14/40
        
        classicThemeView.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha:1)
        classicThemeInput.backgroundColor = UIColor(red: 223/255.0, green: 223/255.0, blue: 223/255.0, alpha:1)
        classicThemeOutput.backgroundColor = UIColor(red: 220/255.0, green: 247/255.0, blue: 197/255.0, alpha: 1)

        
        dayThemeView.layer.cornerRadius = dayThemeView.frame.height * 14/40
        dayThemeInput.layer.cornerRadius = dayThemeInput.frame.height * 14/40
        dayThemeOutput.layer.cornerRadius = dayThemeOutput.frame.height * 14/40
        
        dayThemeView.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha:1)
        dayThemeInput.backgroundColor = UIColor(red: 234/255.0, green: 235/255.0, blue: 237/255.0, alpha:1)
        dayThemeOutput.backgroundColor = UIColor(red: 67/255.0, green: 137/255.0, blue: 249/255.0, alpha: 1)
        
        nightThemeView.layer.cornerRadius = nightThemeView.frame.height * 14/40
        nightThemeInput.layer.cornerRadius = nightThemeInput.frame.height * 14/40
        nightThemeOutput.layer.cornerRadius = nightThemeOutput.frame.height * 14/40
        
        nightThemeView.backgroundColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha:1)
        nightThemeInput.backgroundColor = UIColor(red: 46/255.0, green: 46/255.0, blue: 46/255.0, alpha:1)
        nightThemeOutput.backgroundColor = UIColor(red: 92/255.0, green: 92/255.0, blue: 92/255.0, alpha: 1)
        
    }

    
}
