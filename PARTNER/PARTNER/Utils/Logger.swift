//
//  Logger.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/03/10.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import Foundation

class Logger {
    class var sharedInstance : Logger {
        struct Static {
            static let instance = Logger()
        }
        return Static.instance
    }
    
    enum LogLevel {
        case Debug, Info, Warning, Error
        var toString: String {
            switch self {
            case .Debug:
                return "DEBUG"
            case .Info:
                return "INFO"
            case .Warning:
                return "WARNING"
            case .Error:
                return "ERROR"
            }
        }
    }
    
    class func debug (
        message: String,
        function: String = __FUNCTION__,
        file: String = __FILE__,
        line: Int = __LINE__) {
            #if DEBUG
                Logger.sharedInstance.LoggerWrite(.Debug, message: message, function: function, file: file, line: line)
            #endif
    };
    class func info(
        message: String,
        function: String = __FUNCTION__,
        file: String = __FILE__,
        line: Int = __LINE__) { Logger.sharedInstance.LoggerWrite(.Info, message: message, function: function, file: file, line: line) };
    class func warning(
        message: String,
        function: String = __FUNCTION__,
        file: String = __FILE__,
        line: Int = __LINE__) { Logger.sharedInstance.LoggerWrite(.Warning, message: message, function: function, file: file, line: line) };
    class func error(
        message: String,
        function: String = __FUNCTION__,
        file: String = __FILE__,
        line: Int = __LINE__) { Logger.sharedInstance.LoggerWrite(.Error, message: message, function: function, file: file, line: line) };
    func LoggerWrite(
        loglevel: LogLevel,
        message: String,
        function: String,
        file: String,
        line: Int) {
            let now = NSDate() // 現在日時の取得
            let dateFormatter = NSDateFormatter()
            dateFormatter.timeStyle = .MediumStyle
            dateFormatter.dateStyle = .MediumStyle
            //println(dateFormatter.stringFromDate(now)) // => 2014/12/11 15:19:04
            
            var nowdate = dateFormatter.stringFromDate(now)
 
            let filename = file.lastPathComponent.componentsSeparatedByString(".")[0]
//            println("\(nowdate) - [\(loglevel.toString)] - \(self.className):l\(line) - \(function) => \"\(message)\" ")
            println("\(nowdate) - [\(loglevel.toString)] - l\(line) - \(filename) - \(function) => \"\(message)\" ")
    }
}