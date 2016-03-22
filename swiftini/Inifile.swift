//
//  File.swift
//  swiftini
//
//  Created by Sean Rankine on 15/03/2016.
//  Copyright © 2016 Sean Rankine. All rights reserved.
//

import Foundation

enum parseError: ErrorType{
    case FileNotFound
    case FileNotWritable
    case FileNotReadable
    case ErrorReadingFile
}

public class Inifile {
    let fileManager = NSFileManager.defaultManager()
    public var sections = [String: Dictionary<String, String>]()
    let sectionRegex = try! NSRegularExpression(pattern: "^\\s*\\[(.+?)\\]", options:[])
    let propertyRegex = try! NSRegularExpression(pattern: "(\\S+)\\s?=\\s?(\\S+)", options:[])
    let commentRegex = try! NSRegularExpression(pattern: "^([^;#]+)[;#]?.*$", options:[])
    
    public init?(filepathAsString: String) throws {
        if (!fileManager.fileExistsAtPath(filepathAsString)) {
            throw parseError.FileNotFound
        } else if (!fileManager.isReadableFileAtPath(filepathAsString)) {
            throw parseError.FileNotReadable
        } else {
            do {
                let contents = try String(contentsOfFile: filepathAsString, encoding: NSUTF8StringEncoding)
                parseSections(contents)
            } catch {
                parseError.ErrorReadingFile
            }
        }
    }
    
    public convenience init?(filepathAsURL: NSURL) throws {
        let fileURL = filepathAsURL.URLByStandardizingPath!
        let filePath = fileURL.path!
        try self.init(filepathAsString: filePath)
    }
    
    func parseSections(file: String){
        let lines = file.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
        
        for var index = 0; index < lines.count; ++index {
            var line = lines[index]
            line = parseComments(line)
            let sectionResult = sectionRegex.firstMatchInString(line, options: [], range: NSMakeRange(0, line.characters.count))
            if (sectionResult != nil) {
                let sectionName = (line as NSString).substringWithRange(sectionResult!.rangeAtIndex(1))
                ++index
                let properties = parseProperties(lines, index: &index)
                sections[sectionName] = properties
                --index
            }
        }
    }
    
    func parseProperties(lines: Array<String>, inout index: Int) -> [String: String] {
        var properties = [String: String]()
        
        for ; index < lines.count; ++index {
            var line = lines[index]
            line = parseComments(line)
            let result = propertyRegex.firstMatchInString(line, options: [], range: NSMakeRange(0, line.characters.count))
            if (sectionRegex.firstMatchInString(line, options: [], range: NSMakeRange(0, line.characters.count)) != nil) {
                return properties
            } else if (result != nil) {
                let key = (line as NSString).substringWithRange(result!.rangeAtIndex(1))
                let value = (line as NSString).substringWithRange(result!.rangeAtIndex(2))
                properties[key] = value
            }
        }
        
        return properties
    }
    
    func parseComments(line: String) -> String {
        let commentResult = commentRegex.firstMatchInString(line, options: [], range: NSMakeRange(0, line.characters.count))
        if (commentResult != nil){
            return (line as NSString).substringWithRange(commentResult!.rangeAtIndex(1))
        }
        return ""
    }
    
}

