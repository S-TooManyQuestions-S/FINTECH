//
//  TinkoffChatTests.swift
//  TinkoffChatTests
//
//  Created by Андрей Самаренко on 06.05.2021.
//

@testable import TinkoffChat
import XCTest

class TinkoffChatTests: XCTestCase {
    
    func testThemeHandler() {
        
        // Arrange
        let themeSaveHandler = ThemeSaveHandlerMock()
        let themeServiceHandler = ThemesHandler(themeSaveHandler: themeSaveHandler)

        // Act
        _ = themeServiceHandler.getTheme()
        
        themeServiceHandler.applyTheme(theme: .day)
        let firstReceivedTheme = themeServiceHandler.getTheme()
        
        themeServiceHandler.applyTheme(theme: .night)
        let secondReceivedTheme = themeServiceHandler.getTheme()
        
        themeServiceHandler.applyTheme(theme: .classic)
        var thirsReceivedTheme = themeServiceHandler.getTheme()
        thirsReceivedTheme = themeServiceHandler.getTheme()
        
        let predictedKey = "selectedThemeKey.txt"
        
        // Assert
        
        // input check
        XCTAssertEqual(themeSaveHandler.path, predictedKey)
                
        XCTAssertEqual(themeSaveHandler.readCallsCount, 1)
        XCTAssertEqual(themeSaveHandler.writeCallsCount, 3)
        XCTAssertEqual(themeSaveHandler.receviedThemes, [.day, .night, .classic])
        
        // output check
        XCTAssertEqual(firstReceivedTheme, .day)
        XCTAssertEqual(secondReceivedTheme, .night)
        XCTAssertEqual(thirsReceivedTheme, .classic)

    }

    func testNetworkHandler() {
        
        // Arrange
        let unsuccessFullRequest = RequestSenderMock(isSuccessFull: false)
        let successFullRequest = RequestSenderMock(isSuccessFull: true)
        
        let failTestedHandler = NetworkHandler(with: unsuccessFullRequest)
        let successTestedHandler = NetworkHandler(with: successFullRequest)
        
        var failHandlerResponse: Response?
        var failHandlerError: String?
        
        var successHandlerResponse: Response?
        var successHandlerError: String?
        
        let predictedError = "response error: bad code 401"
        let predictedResponse = Response(hits:
                                            [.init(id: 13, webformatUrl: "someString1.com"),
                                             .init(id: 14, webformatUrl: "someString2.com")])
        let predictedURL = "https://pixabay.com/api/?key=21269857-9477edce33fa7929331f69fa2&q=yellow+flowers"
            + "&image_type=photo&pretty=true&per_page=100"
        
        // Act
        failTestedHandler.getImagesArray { response, error in
            failHandlerResponse = response
            failHandlerError = error
        }
        
        successTestedHandler.getImagesArray { response, error in
            successHandlerResponse = response
            successHandlerError = error
        }
        
        // Assert
        
        // response check
        XCTAssertNil(failHandlerResponse)
        XCTAssertNotNil(failHandlerError)
        XCTAssertEqual(failHandlerError, predictedError)
        
        XCTAssertNil(successHandlerError)
        XCTAssertEqual(successHandlerResponse, predictedResponse)
        
        // calls count check
        XCTAssertEqual(unsuccessFullRequest.callsCount, 1)
        XCTAssertEqual(successFullRequest.callsCount, 1)
        
        // input info check
        XCTAssertEqual(successFullRequest.receivedURL, predictedURL)
        XCTAssertEqual(unsuccessFullRequest.receivedURL, predictedURL)
        
    }
}
