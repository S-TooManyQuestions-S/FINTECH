//
//  Logger.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 25.02.2021.
//

import Foundation
import UIKit

class Logger {
    // ключ в коммандной строке (наличие обеспечивает дальнейшее логгировние зависящих от него функций)
    static let keyToLog = "-logNecessaryProcesses"
    static let keyToLogCoreData = "-logCoreDataProcess"
    // Логгирование какой то дополнительной информации
    static func logProcess(fullDescription: String) {
        if CommandLine.arguments.contains(keyToLog) {
            print(fullDescription)
        }
    }
    // Логгирование процессов CoreData
    static func logCoreDataProcess(fullDescription: String) {
        if CommandLine.arguments.contains(keyToLogCoreData) {
            NSLog(fullDescription)
        }
    }
    // Логгировение конкретного поля и его значения в определенном методе жизненного цикла
    static func logFieldValue(field: String, value: String, in methodName: String) {
        if CommandLine.arguments.contains(keyToLog) {
            print("Logged field: " + field + " with value: " + value + " in <" + methodName + ">")
        }
    }
}
