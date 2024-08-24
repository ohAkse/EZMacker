//
//  Logger.swift
//  EZMacker
//
//  Created by 박유경 on 5/6/24.
//

import Foundation
import OSLog
enum LogLevel {
    case debug
    case info
    case warning
    case error
    case fatal
}

struct Logger {
    private static let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "EZMacker App")
    
    static func writeLog(_ level: LogLevel, message: String, isNeededStackTraceInfo: Bool = false, line: Int = #line, fileName: String = #file, caller: String = #function) {
        let logType: OSLogType
        var logMessage = ""
        var emoji = ""

        switch level {
        case .debug: 
            logType = .debug
            emoji = "ℹ️"
        case .info:
            logType = .info
            emoji = "✅"
        case .warning:
            logType = .default
            emoji = "⚠️"
        case .error:
            logType = .error
            emoji = "❌"
        case .fatal:
            logType = .fault
            emoji = "🚫"
        }
        
        logMessage = "[\(Date().getCurrentTime()) - App][Func : \(caller)] : \(emoji) : \(message) -> \(fileName.split(separator: "/").last!) :\(line)\r\n"
        
        if isNeededStackTraceInfo {
            logMessage += Thread.callStackSymbols.joined(separator: "\r\n")
        }
        
        if level == .error || level == .fatal {
            #if DEBUG
            saveLog(logMessage)
            #endif
        }
        
        os_log("%@", log: log, type: logType, logMessage)
    }

    static func fatalErrorMessage(_ message: String, fileName: String = #file, line: Int = #line, caller: String = #function) {
        #if DEBUG
        let emoji = "❕"
        let fatalLog = "[\(Date().getCurrentTime()) - App][Func : \(caller)] : \(emoji) : \(message) -> \(fileName.split(separator: "/").last!) :\(line)\r\n"
        fatalError(fatalLog)
        #endif
    }
    
    private static func saveLog(_ logMessage: String) {
        DispatchQueue.global().async {
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileName = "error_log_\(Date().getCurrentTime(Dataforamt: "yyyy-MM-dd")).txt"
                let fileURL = documentsDirectory.appendingPathComponent(fileName)
                print(fileURL) // 에뮬레이터 경로 이걸로 확인
                do {
                    let modifiedLogMessage = logMessage + "\r\n"
                    if FileManager.default.fileExists(atPath: fileURL.path) {
                        let fileHandle = try FileHandle(forWritingTo: fileURL)
                        fileHandle.seekToEndOfFile()

                        if let data = modifiedLogMessage.data(using: .utf8) {
                            fileHandle.write(data)
                            fileHandle.closeFile()
                        }
                    } else {
                        try modifiedLogMessage.write(to: fileURL, atomically: false, encoding: .utf8)
                    }
                } catch {
                    Logger.writeLog(.error, message: error.localizedDescription)
                    fatalErrorMessage("로그 파일 열기 또는 추가 실패: \(error)")
                }
            }
        }
    }
}
