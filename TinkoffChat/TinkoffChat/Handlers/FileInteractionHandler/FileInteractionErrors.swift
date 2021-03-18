//
//  FileInteractionErrors.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 16.03.2021.
//

import UIKit

enum FileInteractionErrors : Error{
    case directoryNilError(message:String)
    case fileMissing(message:String)
    case textLoadingError(message:String)
}
