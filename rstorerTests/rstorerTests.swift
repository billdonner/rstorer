//
//  rstorerTests.swift
//  rstorerTests
//
//  Created by bill donner on 8/26/23.
//

import XCTest
@testable import rstorer

final class rstorerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {

    do {
      let (structure1, structure2) = try RecoveryManager.restoreOrInitializeStructures()
      print(structure1)
      print(structure2)
    } catch {
      print("Error: \(error)")
    }
  }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
       let _ =  try! RecoveryManager.restoreOrInitializeStructures()
        }
    }

}
