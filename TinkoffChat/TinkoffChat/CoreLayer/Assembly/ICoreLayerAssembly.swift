//
//  CoreLayerAssembly.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 13.04.2021.
//

import Foundation
class ICoreLayerAssembly: ICoreLayerAssemblyProtocol {
    
    var saveHandler: SaveHandlerProtocol = GCDSaveHandler()
    
    var coreDataStackHandler: CoreDataStackProtocol = CoreDataStack()
    
    var fileInteractionHandler: FileInteractionHandlerProtocol = FileInteractionHandler()
    
    var userIdSaveHandler: UserIDSaveHandlerProtocol = UserIDSaveHandler()
    
    var themeSaveHandler: ThemeSaveHandlerProtocol = ThemeSaveHandler()
    
    var requestSender: IRequestSender = RequestSender(with: URLSession.shared)
}
