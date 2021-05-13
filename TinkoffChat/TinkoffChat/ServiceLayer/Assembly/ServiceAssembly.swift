//
//  ServiceAssembly.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 11.04.2021.
//

import Foundation

class ServiceAssembly: IServicesAssemblyProtocol {
    
    var themeHandler: ThemesHandlerProtocol = ThemesHandler(themeSaveHandler:
                                                                RootAssembly.coreLayerAssembly.themeSaveHandler)
    
    var userIDHandler: UserIdHandlerProtocol = UserIdHandler()
    
    var saveHandlers: SaveHandlerProtocol = GCDSaveHandler()
    
    var coreDataHandler: CoreDataHandlerProtocol = CoreDataHandler()
    
    var networkHandler: NetworkHandlerProtocol = NetworkHandler(with: RootAssembly.coreLayerAssembly.requestSender)
}
