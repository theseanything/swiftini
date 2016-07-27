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
    let bundle = Bundle(for: swiftiniTests.self);
    
    override func setUp() {
        super.setUp()
        trueSections = ["section1":[ "key1.1" : "value1.1", "key1.2" : "value1.2" ],"section2":[ "key2.1" : "value2.1", "key2.2" : "value2.2" ],"section3":[ "key3.1" : "value3.1", "key3.2" : "value3.2" ],"section4":[ "key4.1" : "value4.1", "key4.2" : "value4.2" ],"section5":[ "key5.1" : "value5.1", "key5.2" : "value5.2" ]]
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func loadSectionsFromFile(_ filename: String) -> [String: Dictionary<String, String>]{
        let filePath = bundle.pathForResource(filename, ofType: "ini", inDirectory: "TestIniFiles")
        var IniFileObj = [String: Dictionary<String, String>]()
        do { IniFileObj = try Inifile(filepathAsString: filePath!)!.sections } catch { XCTAssert(true, "Could not initalise inifile object") }
        return IniFileObj
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
        let iniFile = try? Inifile(filepathAsString: "/nonexistant.ini")
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
    
    func testPerformanceSectionParsing() {
        var many_sections = ""
        for i in 1 ... 10000 {
            many_sections.append("[ section " + String(i) + " ]\n")
        }
        self.measure {
            let _ = Inifile(with: many_sections)
        }
    }
    
    func testPerformancePropertyParsing() {
        var many_properties = "[Section]\n"
        for i in 1 ... 1000 {
            many_properties.append("key" + String(i) + "= value\n")
        }
        self.measure {
            let _ = Inifile(with: many_properties)
            
        }
    
    }
    
    func testPerformanceCommentParsing() {
        var many_comments = ""
        for _ in 1 ... 10000 {
            many_comments.append("; comment \n")
            many_comments.append("not a comment ; comment \n")
        }
        self.measure {
            let _ = Inifile(with: many_comments)
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
