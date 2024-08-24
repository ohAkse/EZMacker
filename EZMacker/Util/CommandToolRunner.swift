//
//  CommandToolRunner.swift
//  EZMacker
//
//  Created by 박유경 on 5/27/24.
//


import Foundation
import AppKit
//https://ss64.com/mac/

struct CommandToolRunner {
    static let shared = CommandToolRunner()
    func runCommand<T: CoomandExecutable>(command: T, completion: @escaping (String?) -> Void) {
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "ezMacker.com", attributes: .concurrent)
        let lock = NSLock()
        var results = [String]()
        
        for arguments in command.argumentsList {
            group.enter()
            
            let process = Process().then {
                $0.executableURL = command.executableURL
                $0.arguments = arguments
                
                let pipe = Pipe()
                $0.standardOutput = pipe
                $0.standardError = pipe
                
                $0.terminationHandler = { _ in
                    let data = pipe.fileHandleForReading.readDataToEndOfFile()
                    if let output = String(data: data, encoding: .utf8), !output.isEmpty {
                        lock.lock()
                        results.append(output)
                        lock.unlock()
                    }
                    group.leave()
                }
            }
            
            queue.async {
                do {
                    try process.run()
                } catch {
                    Logger.writeLog(.error, message: "\(command.executableURL.lastPathComponent) error: \(error.localizedDescription)")
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            let combinedResults = results.joined(separator: "\n")
            if !combinedResults.isEmpty {
                completion(combinedResults)
            } else {
                completion(nil)
            }
        }
    }
}
