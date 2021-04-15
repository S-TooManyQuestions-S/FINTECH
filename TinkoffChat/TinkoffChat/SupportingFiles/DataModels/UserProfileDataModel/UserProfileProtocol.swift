//
//  UserProfileProtocol.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 16.04.2021.
//

import UIKit

protocol UserProfileProtocol {
    var fullName: String? {get}
    var description: String? {get}
    var profileImage: UIImage? {get}
}
