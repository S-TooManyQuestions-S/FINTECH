//
//  FileInteractionHandler.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 16.03.2021.
//

import UIKit

class FileInteractionHandler{
    
    var errorOccuried = false
    
    static let fullNameDataPath = "name.txt"
    static let descriptionDataPath = "desc.txt"
    static let imageDataPath = "imge.png"
    
    let fileManager = FileManager.default
    
    func getDirectory() -> URL?{
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    func appendPath(path: String) throws -> URL{
        guard let dir = getDirectory()?.appendingPathComponent(path)
        else {throw FileInteractionErrors.directoryNilError(message: "Main directory was nil!")}
        return dir
    }
    
    func saveImage(data: Data) throws{
        let fullPath = try appendPath(path: FileInteractionHandler.imageDataPath)
        try? data.write(to: fullPath)
    }
    
    func loadImage() throws -> UIImage? {
        let fullPath = try appendPath(path: FileInteractionHandler.imageDataPath)
        
        guard fileManager.fileExists(atPath: fullPath.path)
        else{throw FileInteractionErrors.fileMissing(message:"No file \(FileInteractionHandler.imageDataPath)")}
        
        return UIImage(contentsOfFile: fullPath.path)
    }
    
    func saveText(text: String, to path: String) throws{
        let fullPath = try appendPath(path: path)
        try text.write(toFile: fullPath.path, atomically: true, encoding: String.Encoding.utf8)
    }
    
    func loadText(from path: String) throws -> String{
        let fullPath = try appendPath(path: path)
        guard let text = try? String(contentsOf: fullPath)
        else{throw FileInteractionErrors.textLoadingError(message:"Text loading error!")}
            return text
    }

}
