//
//  swiftiniTests.swift
//  swiftiniTests
//
//  Created by Sean Rankine on 15/03/2016.
//  Copyright © 2016 Sean Rankine. All rights reserved.
//

import XCTest
@testable import swiftini

class swiftiniTests: XCTestCase {
    var trueSections = [String: Dictionary<String, String>]()
    let bundle = NSBundle(forClass: swiftiniTests.self);
    
    override func setUp() {
        super.setUp()
        trueSections = ["section1":[ "key1.1" : "value1.1", "key1.2" : "value1.2" ],"section2":[ "key2.1" : "value2.1", "key2.2" : "value2.2" ],"section3":[ "key3.1" : "value3.1", "key3.2" : "value3.2" ],"section4":[ "key4.1" : "value4.1", "key4.2" : "value4.2" ],"section5":[ "key5.1" : "value5.1", "key5.2" : "value5.2" ]]
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func loadSectionsFromFile(filename: String) -> [String: Dictionary<String, String>]{
        let filePath = bundle.pathForResource(filename, ofType: "ini", inDirectory: "TestIniFiles")
        return Inifile(filepathAsString: filePath!)!.sections
    }
    
    func testNormalFile() {
        let fileSections = loadSectionsFromFile("normal")
        XCTAssert(trueSections == fileSections)
    }
    
    func testComments(){
        let fileSections = loadSectionsFromFile("comments")
        XCTAssert(trueSections == fileSections)
    }
    
    func testEmptyFile(){
        let fileSections = loadSectionsFromFile("empty")
        XCTAssert([:] == fileSections)
    }
    
    func testNonExistantFile(){
        let iniFile = Inifile(filepathAsString: "/nonexistant.ini")
        XCTAssertNil(iniFile)
    }
    
    func testParameters(){
        let fileSections = loadSectionsFromFile("parameters")
        XCTAssert(trueSections == fileSections)
    }
    
    func testSections(){
        let fileSections = loadSectionsFromFile("sections")
        trueSections["emptySection"] = [String: String]()
        XCTAssert(trueSections == fileSections)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}

// Overloading of the == operator to support nested dictionaries.

func == <T: Equatable, K1: Hashable, K2: Hashable>(lhs: [K1: [K2: T]], rhs: [K1: [K2: T]]) -> Bool {
    if lhs.count != rhs.count { return false }
    
    for (key, lhsub) in lhs {
        if let rhsub = rhs[key] {
            if lhsub != rhsub {
                return false
            }
        } else {
            return false
        }
    }
    
    return true
}
