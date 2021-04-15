//
//  RootAssemblyProtocol.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 11.04.2021.
//

import Foundation

protocol RootAssemblyProtocol {
    static var serviceAssembly: IServicesAssemblyProtocol {get}
    static var coreLayerAssembly: ICoreLayerAssemblyProtocol {get}
}
