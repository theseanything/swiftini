//
//  File.swift
//  swiftini
//
//  Created by Sean Rankine on 15/03/2016.
//  Copyright © 2016 Sean Rankine. All rights reserved.
//

import Foundation

public class Inifile{
    let fileManager = NSFileManager.defaultManager()
    public var sections = [String: Dictionary<String, String>]()
    let sectionRegex = try? NSRegularExpression(pattern: "^\\s?\\[(.+)\\]", options:[])
    let propertyRegex = try? NSRegularExpression(pattern: "(\\S+)\\s?=\\s?(\\S+)", options:[])
    let commentRegex = try? NSRegularExpression(pattern: "^([^;#]+)[;#]?.*$", options:[])
    
    public convenience init?(filepathAsString: String) {
        let fileURL = NSURL(fileURLWithPath: (filepathAsString as NSString).stringByStandardizingPath)
        self.init(filepathAsURL: fileURL)
    }
    
    public init?(filepathAsURL: NSURL) {
        let fileURL = filepathAsURL.URLByStandardizingPath!
        let filePath = fileURL.path!
        if fileManager.isReadableFileAtPath(filePath){
            let contents = try? String(contentsOfFile: filePath, encoding: NSUTF8StringEncoding)
            if (contents != nil){
                parseSections(contents!)
            } else {
                print("File Not Readable")
            }
        } else {
            return nil
        }
    }
    
    func parseSections(file: String){
        let lines = file.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
        
        for var index = 0; index < lines.count; ++index {
            var line = lines[index]
            line = parseComments(line)
            let sectionResult = sectionRegex!.firstMatchInString(line, options: [], range: NSMakeRange(0, line.characters.count))
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
            let result = propertyRegex!.firstMatchInString(line, options: [], range: NSMakeRange(0, line.characters.count))
            if (result != nil) {
                let key = (line as NSString).substringWithRange(result!.rangeAtIndex(1))
                let value = (line as NSString).substringWithRange(result!.rangeAtIndex(2))
                properties[key] = value
            } else if (sectionRegex!.firstMatchInString(line, options: [], range: NSMakeRange(0, line.characters.count)) != nil) {
                return properties
            }
        }
        
        return properties
    }
    
    func parseComments(line: String) -> String {
        let commentResult = commentRegex!.firstMatchInString(line, options: [], range: NSMakeRange(0, line.characters.count))
        if (commentResult != nil){
            return (line as NSString).substringWithRange(commentResult!.rangeAtIndex(1))
        }
        return ""
    }
    
}

