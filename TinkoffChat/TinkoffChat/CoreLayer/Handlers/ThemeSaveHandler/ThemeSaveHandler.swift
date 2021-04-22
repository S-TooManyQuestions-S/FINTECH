//
//  ThemeSaveHandler.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 16.04.2021.
//

import Foundation

class ThemeSaveHandler: ThemeSaveHandlerProtocol {
    func readTheme(from path: String) -> Theme {
        guard let fullPath = try? RootAssembly.coreLayerAssembly.fileInteractionHandler.appendPath(path: path),
              let strValue = try? String(contentsOf: fullPath),
              let theme = Theme(rawValue: Int(strValue) ?? 0)
        else {return .classic}
       
        return theme
    }
    
    func writeTheme(to path: String, rawTheme: Int) {
        DispatchQueue.global(qos: .utility).async {
            try? RootAssembly.coreLayerAssembly.fileInteractionHandler.saveText(text: String(rawTheme), to: path)
        }
    }
}
