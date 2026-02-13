//
//  MDInterfaceInfoCommand.swift
//  EZMackerUtilLib
//
//  Created by 박유경 on 10/14/24.
//

import Foundation

public enum MDInterfaceInfoCommand: CommandExecutable {
    case ifconfig(interface: String)

    public var executableURL: URL {
        switch self {
        case .ifconfig:
            return URL(fileURLWithPath: "/sbin/ifconfig")
        }
    }

    public var argumentsList: [[String]] {
        switch self {
        case .ifconfig(let interface):
            return [[interface]]
        }
    }

    public static func parse(_ output: String, for interface: String) -> NetworkInterfaceData {
        var info = NetworkInterfaceData(name: interface)
        let lines = output.components(separatedBy: .newlines)

        for line in lines {
            if line.contains("status:") {
                info.status = line.replacingOccurrences(of: "status: ", with: "").trimmingCharacters(in: .whitespaces)
            } else if line.contains("ether ") {
                info.ethernetAddress = line.replacingOccurrences(of: "ether ", with: "").trimmingCharacters(in: .whitespaces)
            } else if line.contains("inet ") {
                let components = line.components(separatedBy: .whitespaces)
                info.ipv4 = IPv4Info(
                    address: components.first(where: { $0.contains(".") }) ?? "",
                    subnetMask: components.first(where: { $0.contains("netmask") })?.replacingOccurrences(of: "netmask", with: "") ?? "",
                    broadcast: components.last ?? ""
                )
            } else if line.contains("inet6 ") {
                let components = line.components(separatedBy: .whitespaces)
                info.ipv6 = IPv6Info(
                    address: components.first(where: { $0.contains(":") }) ?? "",
                    prefixLength: components.first(where: { $0.contains("prefixlen") })?.replacingOccurrences(of: "prefixlen", with: "") ?? "",
                    scopeID: components.last ?? ""
                )
            } else if line.contains("media:") {
                info.media = line.replacingOccurrences(of: "media: ", with: "").trimmingCharacters(in: .whitespaces)
            }
        }

        return info
    }
}
