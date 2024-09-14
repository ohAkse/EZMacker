//
//  CommandRunner.swift
//  EZMackerUtilLib
//
//  Created by 박유경 on 9/1/24.
//
import AppKit
import EZMackerThreadLib

public struct CommandToolRunner {
    public static func runCommand<T: CoomandExecutable>(command: T, completion: @escaping (String?) -> Void) {
        let group = DispatchGroup()
        let commandRunQueue = DispatchQueueBuilder().createQueue(for: .commandRun)
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
                    let output = String(decoding: data, as: UTF8.self)
                    
                    if !output.isEmpty {
                        lock.lock()
                        results.append(output)
                        lock.unlock()
                    }
                    group.leave()
                }
            }
            
            commandRunQueue.async {
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
