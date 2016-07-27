//
//  File.swift
//  swiftini
//
//  Created by Sean Rankine on 15/03/2016.
//  Copyright © 2016 Sean Rankine. All rights reserved.
//

import Foundation

enum parseError: ErrorProtocol{
    case fileNotFound
    case fileNotWritable
    case fileNotReadable
}

public class Inifile {
    public var sections = [String: Dictionary<String, String>]()
    
    let sectionRegex = try! RegularExpression(pattern: "^\\s*\\[(.+?)\\]", options:[])
    let propertyRegex = try! RegularExpression(pattern: "(\\S+)\\s?=\\s?(\\S+)", options:[])
    let commentRegex = try! RegularExpression(pattern: "^([^;]+)[;]?.*$", options:[])
    
    
    public init(with string: String) {
        self.read(from: string)
    }
    
    public convenience init?(filepathAsString: String) throws {
        let contents = try String(contentsOfFile: filepathAsString, encoding: String.Encoding.utf8)
        try self.init(with: contents)
    }
    
    public convenience init?(filepathAsURL: URL) throws {
        let fileURL = try! filepathAsURL.standardizingPath()
        let filePath = fileURL.path!
        try self.init(filepathAsString: filePath)
    }
    
    private func read(from file: String){
        let lines = file.components(separatedBy: CharacterSet.newlines)
        var current_section_name:String?
        
        for raw_line in lines {
            let line = removeComment(from: raw_line) as NSString

            if (line.trimmingCharacters(in: NSCharacterSet.whitespaces) == ""){
                continue
            }
            
            let section_name = parseSections(line as String)
            if (section_name != nil){
                current_section_name = section_name
                self.sections[section_name!] = [:]
                continue
            }
            
            let property = parseProperties(line as String)
            if (property != nil && current_section_name != nil){
                self.sections[current_section_name!]?[property!.key] = property!.value
            }
            
            
        }
    }
    
    func parseSections(_ line: String) -> String? {
        let sectionResult = self.sectionRegex.firstMatch(in: line, options: [], range: NSMakeRange(0, line.characters.count))
        if (sectionResult != nil) {
            return (line as NSString).substring(with: sectionResult!.range(at: 1))
        }
        return nil
        
    }
    
    func parseProperties(_ line: String) -> (key: String, value: String)? {
        let result = self.propertyRegex.firstMatch(in: line, options: [], range: NSMakeRange(0, line.characters.count))
        if (result != nil) {
            let key = (line as NSString).substring(with: result!.range(at: 1))
            let value = (line as NSString).substring(with: result!.range(at: 2))
            return (key, value)
        }
        return nil
    }
    
    func removeComment(from line: String) -> String {        
        if (line.characters.first == ";"){
            return ""
        }
        let commentResult = self.commentRegex.firstMatch(in: line, options: [], range: NSMakeRange(0, line.characters.count))
        if (commentResult != nil){
            return (line as NSString).substring(with: commentResult!.range(at: 1))
        }
        return line
    }
    
}

