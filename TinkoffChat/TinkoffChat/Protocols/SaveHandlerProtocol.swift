//
//  SaveHandlerDelegate.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 16.03.2021.
//

import UIKit

protocol SaveHandlerProtocol : AnyObject {
    func writeData(newData: UserProfile,
                   completion: @escaping (_ isSuccessfullyCompleted : Bool, _ isGCDUsed : Bool) -> Void)
    func readData(_ action: @escaping (_ loadedProfile: UserProfile) -> Void)
}
