//
//  FileInteractionHandlerProtocol.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 11.04.2021.
//

import Foundation
import UIKit

protocol FileInteractionHandlerProtocol {
    
    func loadImage() throws -> UIImage?
    
    func saveText(text: String, to path: String) throws
    
    func loadText(from path: String) throws -> String
    
    func appendPath(path: String) throws -> URL
}
