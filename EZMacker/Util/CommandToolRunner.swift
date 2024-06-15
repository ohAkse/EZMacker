//
//  CommandToolRunner.swift
//  EZMacker
//
//  Created by 박유경 on 5/27/24.
//

//https://ss64.com/mac/
import Foundation
struct CommandToolRunner {
    static let shared = CommandToolRunner()
    func runMDFind() {
        let process = Process()
        // Use the correct path to mdfind
        process.executableURL = URL(fileURLWithPath: "/usr/bin/mdfind")
        process.arguments = ["-name", "Info.plist"]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe
        
        do {
            try process.run()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: data, encoding: .utf8) {
                Logger.writeLog(.info, message: output)
            }
        } catch {
            DispatchQueue.main.async {
                Logger.writeLog(.error, message: error.localizedDescription)
            }
        }
    }
}
