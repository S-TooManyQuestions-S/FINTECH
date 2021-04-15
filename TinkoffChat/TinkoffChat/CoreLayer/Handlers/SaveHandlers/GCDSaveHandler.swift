//
//  GCDSaveHandler.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 16.03.2021.
//

import UIKit

class GCDSaveHandler: FileInteractionHandler, SaveHandlerProtocol {
    
    func writeData(newData: UserProfileProtocol, completion: @escaping (_ isSuccessfullyCompleted: Bool, _ isGCDUsed: Bool) -> Void) {
        
        self.errorOccuried = false
        
        DispatchQueue.global(qos: .utility).async {
            let dispatchGroup = DispatchGroup()
            
            dispatchGroup.enter()
            DispatchQueue.global(qos: .utility).async {
                if let fullName = newData.fullName {
                    do {
                        try self.saveText(text: fullName, to: FileInteractionHandler.fullNameDataPath)
                    } catch {
                        self.errorOccuried = true
                    }
                }
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            DispatchQueue.global(qos: .utility).async {
                if let description = newData.description {
                    do {
                        try self.saveText(text: description, to: FileInteractionHandler.descriptionDataPath)
                    } catch {
                        self.errorOccuried = true
                    }
                }
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            DispatchQueue.global(qos: .utility).async {
                if  let data = newData.profileImage?.pngData() {
                    do {
                        try self.saveImage(data: data)
                    } catch {
                        self.errorOccuried = true
                    }
                }
                dispatchGroup.leave()
            }
            dispatchGroup.wait()
            DispatchQueue.main.async {
                completion(!self.errorOccuried, true)
            }
        }
    }
    
    func readData(_ action: @escaping (UserProfileProtocol) -> Void) {
        
        DispatchQueue.global(qos: .default).async {
            let dispatchGroup = DispatchGroup()
            
            var fullName: String?
            var description: String?
            var image: UIImage?
            
            dispatchGroup.enter()
            DispatchQueue.global(qos: .utility).async {
                fullName = try? self.loadText(from: FileInteractionHandler.fullNameDataPath)
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            DispatchQueue.global(qos: .utility).async {
                description = try? self.loadText(from: FileInteractionHandler.descriptionDataPath)
                
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            DispatchQueue.global(qos: .utility).async {
                image = try? self.loadImage()
                dispatchGroup.leave()
            }
            dispatchGroup.wait()
            
            DispatchQueue.main.async {
                action(UserProfile(fullName: fullName, description: description, profileImage: image))
            }
        }
        
    }
}