//
//  NetworkInterfaceData.swift
//  EZMackerUtilLib
//
//  Created by 박유경 on 10/14/24.
//

public struct NetworkInterfaceData {
    public var name: String = ""
    public var status: String = ""
    public var ipv4: IPv4Info = IPv4Info()
    public var ipv6: IPv6Info = IPv6Info()
    public var ethernetAddress: String = ""
    public var media: String = ""
}

public struct IPv4Info {
    public var address: String = ""
    public var subnetMask: String = ""
    public var broadcast: String = ""
}

public struct IPv6Info {
    public var address: String = ""
    public var prefixLength: String = ""
    public var scopeID: String = ""
}
