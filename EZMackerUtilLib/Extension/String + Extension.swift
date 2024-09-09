//
//  String + Extension.swift
//  EZMackerUtilLib
//
//  Created by 박유경 on 9/1/24.
//

import Foundation

public extension String {
    func converFileType() -> String {
        switch self {
        case "NSFileTypeDirectory":
            return "폴더"
        case "NSFileTypeRegular":
            return "파일"
        case "NSFileTypeSymbolicLink":
            return "심볼릭 링크"
        case "NSFileTypeSocket":
            return "소켓"
        case "NSFileTypeCharacterSpecial":
            return "문자 장치"
        case "NSFileTypeBlockSpecial":
            return "블록 장치"
        case "NSFileTypeUnknown":
            return "알 수 없는 파일"
        default:
            return self
        }
    }
    func toErrorDescription() -> String {
        let errorType = BatteryChargeErrorType.from(hexString: self)
        return errorType.description()
    }
}
public extension String.Encoding {
    func decode(_ data: Data) -> String? {
        return String(data: data, encoding: self)
    }
}
