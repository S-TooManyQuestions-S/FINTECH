//
//  ThemeSaveHandlerProtocol.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 16.04.2021.
//

import Foundation

protocol ThemeSaveHandlerProtocol {
    func readTheme(from path: String) -> Theme
    func writeTheme(to path: String, rawTheme: Int)
}
