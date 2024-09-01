//
//  String + Extension.swift
//  EZMacker
//
//  Created by 박유경 on 8/13/24.
//

import SwiftUI

extension String {
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
        switch self {
        case "0x0004":
            return "정상 클럭 상태"
        case "0x0008":
            return "클럭 실행 중"
        case "0x0020":
            return "보조 전원 켜짐 또는 페이징 가능"
        case "0x0100":
            return "패스스루 모드"
        case "0x0400":
            return "절전 모드"
        case "0x0001":
            return "수면 모드 또는 도달 불가능한 상태"
        case "0x0080":
            return "재시작 모드 또는 자식 프로세스 제한 상태"
        case "0x0002":
            return "전원 켜짐"
        case "0x0010":
            return "시스템 수면 방지"
        case "0x0040":
            return "유휴 상태 수면 방지"
        case "0x0200":
            return "자식 프로세스 제한 상태 2"
        case "0x8000":
            return "장치 사용 가능(대기중)"
        case "0x4000":
            return "최대 성능 상태"
        case "0x2000":
            return "컨텍스트 유지됨"
        case "0x1000":
            return "설정 유지됨"
        case "0x0800":
            return "전원 관리되지 않음 또는 정적 전원 유효"
        default:
            return "알 수 없는 상태: \(self)"
        }
    }
}
