//
//  OperationSaveHandler.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 17.03.2021.
//

import UIKit

class OperationSaveHandler: FileInteractionHandler, SaveHandlerProtocol {
    func writeData(newData: UserProfileProtocol, completion: @escaping (_ isSuccessfullyCompleted: Bool, _ isGCDUsed: Bool) -> Void) {
        self.errorOccuried = false
        
        let operationQueue = OperationQueue()
        operationQueue.qualityOfService = .utility
        
        let saveUserNameOperation = SaveTextDataOperation(textData: newData.fullName, pathToSave: FileInteractionHandler.fullNameDataPath, handler: self)
        let saveDescriptionOperation = SaveTextDataOperation(textData: newData.description, pathToSave: FileInteractionHandler.descriptionDataPath, handler: self)
        let saveImageOperation = SaveImageDataOperation(image: newData.profileImage, handler: self)
        
        let completionOperation = BlockOperation(block: {
            OperationQueue.main.addOperation {
                completion(!self.errorOccuried, false)
            }
        })
        
        completionOperation.addDependency(saveImageOperation)
        completionOperation.addDependency(saveDescriptionOperation)
        completionOperation.addDependency(saveUserNameOperation)
        
        operationQueue.addOperations([saveDescriptionOperation, saveUserNameOperation, saveImageOperation, completionOperation], waitUntilFinished: false)
        
    }
    
    func readData(_ action: @escaping (UserProfileProtocol) -> Void) {
        let operationsQueue = OperationQueue()
        operationsQueue.qualityOfService = .utility
        
        let loadUserNameOperation = LoadTextDataOperation(handler: self, pathForLoading: FileInteractionHandler.fullNameDataPath)
        let loadDescriptionOperation = LoadTextDataOperation(handler: self, pathForLoading: FileInteractionHandler.descriptionDataPath)
        let loadImageOperation = LoadImageDataOperation(handler: self)
        
        let completionOperation = BlockOperation(block: {
            action(UserProfile(fullName: loadUserNameOperation.loadedText, description: loadDescriptionOperation.loadedText, profileImage: loadImageOperation.image))
        })
        
        completionOperation.addDependency(loadImageOperation)
        completionOperation.addDependency(loadDescriptionOperation)
        completionOperation.addDependency(loadUserNameOperation)
        
        operationsQueue.addOperations([loadImageOperation, loadDescriptionOperation, loadUserNameOperation, completionOperation], waitUntilFinished: false)
    }
}

class SaveTextDataOperation: Operation {
    var textDataToSave: String?
    var saveToPath: String
    weak var handler: FileInteractionHandler?
    
    init(textData: String?, pathToSave: String, handler: FileInteractionHandler) {
        self.textDataToSave = textData
        self.saveToPath = pathToSave
        self.handler = handler
    }
    
    override func main() {
        guard !isCancelled else {
            return
        }
       
        do {
            if let textDataToSave = textDataToSave {
                try handler?.saveText(text: textDataToSave, to: saveToPath)
            }
        } catch {
            handler?.errorOccuried = true
        }
    }
}

class SaveImageDataOperation: Operation {
    var image: UIImage?
    weak var handler: FileInteractionHandler?
    
    init(image: UIImage?, handler: FileInteractionHandler) {
        self.handler = handler
        self.image = image
    }
    
    override func main() {
        guard !isCancelled else {
            return
        }
        do {
            if let imageDataToSave = image?.pngData() {
                try handler?.saveImage(data: imageDataToSave)
            }
        } catch {
            handler?.errorOccuried = true
        }
    }
}

class LoadTextDataOperation: Operation {
    var loadedText: String?
    var pathForLoading: String
    weak var handler: FileInteractionHandler?
    
    init(handler: FileInteractionHandler, pathForLoading: String) {
        self.handler = handler
        self.pathForLoading = pathForLoading
    }
    
    override func main() {
        guard !isCancelled else {
            return
        }
        loadedText = try? handler?.loadText(from: pathForLoading)
        
    }
}

class LoadImageDataOperation: Operation {
    var image: UIImage?
    weak var handler: FileInteractionHandler?
    
    init(handler: FileInteractionHandler) {
        self.handler = handler
    }
    
    override func main() {
        guard !isCancelled else {
            return
        }
        image = try? handler?.loadImage()
        
    }
}
