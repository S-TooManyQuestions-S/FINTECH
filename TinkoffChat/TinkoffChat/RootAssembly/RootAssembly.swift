//
//  RootAssembly.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 11.04.2021.
//

import Foundation

class RootAssembly: RootAssemblyProtocol {
    static var serviceAssembly: IServicesAssemblyProtocol = ServiceAssembly()
    static var coreLayerAssembly: ICoreLayerAssemblyProtocol = ICoreLayerAssembly()
}
