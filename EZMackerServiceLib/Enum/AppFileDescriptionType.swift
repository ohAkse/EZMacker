//
//  FileDescription.swift
//  EZMackerServiceLib
//
//  Created by 박유경 on 9/1/24.
//

enum AppFileDescriptionType: String {
    case regular = "NSFileTypeRegular"
    case directory = "NSFileTypeDirectory"
    case symbolicLink = "NSFileTypeSymbolicLink"
    case socket = "NSFileTypeSocket"
    case characterSpecial = "NSFileTypeCharacterSpecial"
    case blockSpecial = "NSFileTypeBlockSpecial"
    case unknown = "Unknown"
    
    init(type: String) {
        switch type {
        case AppFileDescriptionType.regular.rawValue:
            self = .regular
        case AppFileDescriptionType.directory.rawValue:
            self = .directory
        case AppFileDescriptionType.symbolicLink.rawValue:
            self = .symbolicLink
        case AppFileDescriptionType.socket.rawValue:
            self = .socket
        case AppFileDescriptionType.characterSpecial.rawValue:
            self = .characterSpecial
        case AppFileDescriptionType.blockSpecial.rawValue:
            self = .blockSpecial
        default:
            self = .unknown
        }
    }
    
    var name: String {
        switch self {
        case .regular:
            return "파일"
        case .directory:
            return "폴더"
        case .symbolicLink:
            return "심볼릭 링크"
        case .socket:
            return "소켓"
        case .characterSpecial:
            return "문자 특수 파일"
        case .blockSpecial:
            return "블록 특수 파일"
        case .unknown:
            return "알 수 없는 유형"
        }
    }
}
