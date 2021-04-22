//
//  CoreLayerAssemblyProtocol.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 13.04.2021.
//

import Foundation

protocol ICoreLayerAssemblyProtocol {
    var coreDataStackHandler: CoreDataStackProtocol {get}
    var fileInteractionHandler: FileInteractionHandlerProtocol {get}
    var saveHandler: SaveHandlerProtocol {get}
    var userIdSaveHandler: UserIDSaveHandlerProtocol {get}
    var themeSaveHandler: ThemeSaveHandlerProtocol {get}
    var requestSender: IRequestSender {get}
}
