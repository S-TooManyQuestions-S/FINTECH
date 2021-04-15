//
//  ThemesHandlerProtocol.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 11.04.2021.
//

import Foundation

protocol ThemesHandlerProtocol {
    func applyTheme(theme: Theme)
    func getTheme() -> Theme 
}
