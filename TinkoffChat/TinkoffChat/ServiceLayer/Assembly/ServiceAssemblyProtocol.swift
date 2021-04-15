//
//  ServiceAssemblyProtocol.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 11.04.2021.
//

import Foundation

protocol IServicesAssemblyProtocol {
    
    var themeHandler: ThemesHandlerProtocol {get}
    
    var userIDHandler: UserIdHandlerProtocol {get}
    
    var saveHandlers: SaveHandlerProtocol {get}
    
    var coreDataHandler: CoreDataHandlerProtocol {get}
}
