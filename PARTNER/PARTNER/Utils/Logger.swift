//
//  Logger.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/03/10.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import Foundation

extension NSObject {
    
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
    
    func LoggerDebug(
        message: String,
        function: String = __FUNCTION__,
        file: String = __FILE__,
        line: Int = __LINE__) {
            #if DEBUG
                LoggerWrite(.Debug, message: message, function: function, file: file, line: line)
            #endif
    };
    func LoggerInfo(
        message: String,
        function: String = __FUNCTION__,
        file: String = __FILE__,
        line: Int = __LINE__) { LoggerWrite(.Info, message: message, function: function, file: file, line: line) };
    func LoggerWarning(
        message: String,
        function: String = __FUNCTION__,
        file: String = __FILE__,
        line: Int = __LINE__) { LoggerWrite(.Warning, message: message, function: function, file: file, line: line) };
    func LoggerError(
        message: String,
        function: String = __FUNCTION__,
        file: String = __FILE__,
        line: Int = __LINE__) { LoggerWrite(.Error, message: message, function: function, file: file, line: line) };
    func LoggerWrite(
        loglevel: LogLevel,
        message: String,
        function: String,
        file: String,
        line: Int) {
            let now = NSDate() // 現在日時の取得
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
            dateFormatter.timeStyle = .MediumStyle
            dateFormatter.dateStyle = .MediumStyle
            //println(dateFormatter.stringFromDate(now)) // => 2014/12/11 15:19:04
            
            var nowdate = dateFormatter.stringFromDate(now)
            
            var filename = file
            if let match = filename.rangeOfString("[^/]*$", options: .RegularExpressionSearch) {
                filename = filename.substringWithRange(match)
            }
            println("\(nowdate) - [\(loglevel.toString)] - \(self.className):l\(line) - \(function) => \"\(message)\" ")
    }
}