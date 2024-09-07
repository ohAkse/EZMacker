//
//  BatteryChargeErrorType.swift
//  EZMackerUtilLib
//
//  Created by 박유경 on 9/7/24.
//

import Foundation

// MARK: notChargingReason 정보 수집중
// 0x400001: 완충됐을때 에러코드?
public enum BatteryChargeErrorType: String {
    case normalClockState = "0x0004"
    case clockRunning = "0x0008"
    case secondaryPowerOn = "0x0020"
    case passThroughMode = "0x0100"
    case sleepMode = "0x0400"
    case unreachableSleepMode = "0x0001"
    case restartMode = "0x0080"
    case powerOn = "0x0002"
    case preventSystemSleep = "0x0010"
    case preventIdleSleep = "0x0040"
    case childProcessLimit = "0x0200"
    case deviceAvailable = "0x8000"
    case maxPerformance = "0x4000"
    case contextMaintained = "0x2000"
    case settingsMaintained = "0x1000"
    case unmanagedPower = "0x0800"
    case alreadyFullChaged = "0x400001"
    case unknown
    
    public func description() -> String {
        switch self {
        case .normalClockState:
            return "정상 클럭 상태"
        case .clockRunning:
            return "클럭 실행 중"
        case .secondaryPowerOn:
            return "보조 전원 켜짐 또는 페이징 가능"
        case .passThroughMode:
            return "패스스루 모드"
        case .sleepMode:
            return "절전 모드"
        case .unreachableSleepMode:
            return "수면 모드 또는 도달 불가능한 상태"
        case .restartMode:
            return "재시작 모드 또는 자식 프로세스 제한 상태"
        case .powerOn:
            return "전원 켜짐"
        case .preventSystemSleep:
            return "시스템 수면 방지"
        case .preventIdleSleep:
            return "유휴 상태 수면 방지"
        case .childProcessLimit:
            return "자식 프로세스 제한 상태 2"
        case .deviceAvailable:
            return "장치 사용 가능(대기중)"
        case .maxPerformance:
            return "최대 성능 상태"
        case .contextMaintained:
            return "컨텍스트 유지됨"
        case .settingsMaintained:
            return "설정 유지됨"
        case .unmanagedPower:
            return "전원 관리되지 않음 또는 정적 전원 유효"
        case .alreadyFullChaged:
            return "충전 완료"
        case .unknown:
            return "알 수 없는 상태"
        }
    }
    
    public static func from(hexString: String) -> BatteryChargeErrorType {
        return BatteryChargeErrorType(rawValue: hexString) ?? .unknown
    }
}
