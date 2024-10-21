//
//  EZImageTunerTabButtonView.swift
//  EZMacker
//
//  Created by 박유경 on 10/7/24.
//

import SwiftUI
import EZMackerUtilLib

enum TunerTabType: Int, CaseIterable {
    case reset, rotate, crop, filter, flip, addText
    case pen, save
    case undo, redo

    var icon: String {
        switch self {
        case .rotate: return "rotate.right"
        case .save: return "square.and.arrow.down"
        case .pen: return "highlighter"
        case .crop: return "crop"
        case .filter: return "wand.and.stars"
        case .reset: return "arrow.counterclockwise"
        case .addText: return "textbox"
        case .flip: return "arrow.left.and.right"
        case .undo: return "arrow.uturn.backward"
        case .redo: return "arrow.uturn.forward"
        }
    }

    var title: String {
        switch self {
        case .rotate: return "회전"
        case .save: return "저장"
        case .pen: return "펜"
        case .crop: return "자르기"
        case .filter: return "필터"
        case .reset: return "초기화"
        case .addText: return "텍스트"
        case .flip: return "뒤집기"
        case .undo: return "되돌리기"
        case .redo: return "앞돌리기"
        }
    }
}

struct EZImageTunerTabButtonView: View {
    @EnvironmentObject var systemThemeService: SystemThemeService
    let tab: TunerTabType
    let isSelected: Bool
    let isDisabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: tab.icon)
                    .font(.system(size: FontSizeType.medium.size))
                    .foregroundColor(imageColor())
                Text(tab.title)
                    .font(.caption)
                    .foregroundColor(textColor())
                    .padding(.top, 3)
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 7)
                    .fill(backgroundColor())
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isDisabled)
    }

    private func backgroundColor() -> Color {
        if isSelected && !isDisabled {
            switch systemThemeService.getColorScheme() {
            case ColorSchemeModeType.Light.title:
                return ThemeColorType.darkGray.color
            case ColorSchemeModeType.Dark.title:
                return ThemeColorType.darkBlue.color
            default:
                Logger.fatalErrorMessage("colorScheme is Empty")
                return Color.clear
            }
        }
        return Color.clear
    }

    private func textColor() -> Color {
        if isDisabled {
            return disabledColor()
        } else if isSelected {
            switch systemThemeService.getColorScheme() {
            case ColorSchemeModeType.Light.title:
                return ThemeColorType.black.color
            case ColorSchemeModeType.Dark.title:
                return ThemeColorType.lightWhite.color
            default:
                Logger.fatalErrorMessage("colorScheme is Empty")
                return Color.clear
            }
        } else {
            return titleTextColor()
        }
    }

    private func imageColor() -> Color {
        if isDisabled {
            return disabledColor()
        } else if isSelected {
            if tab == .pen {
                return ThemeColorType.orange.color }
            switch systemThemeService.getColorScheme() {
            case ColorSchemeModeType.Light.title:
                return ThemeColorType.darkBrown.color
            case ColorSchemeModeType.Dark.title:
                    return ThemeColorType.lightWhite.color
            default:
                Logger.fatalErrorMessage("colorScheme is Empty")
                return Color.clear
            }
        } else {
            return titleTextColor()
        }
    }

    private func titleTextColor() -> Color {
        switch systemThemeService.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return ThemeColorType.black.color
        case ColorSchemeModeType.Dark.title:
            return ThemeColorType.lightWhite.color
        default:
            Logger.fatalErrorMessage("colorScheme is Empty")
            return Color.clear
        }
    }

    private func disabledColor() -> Color {
        switch systemThemeService.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return ThemeColorType.darkGray.color.opacity(0.8)
        case ColorSchemeModeType.Dark.title:
            return ThemeColorType.lightWhite.color.opacity(0.4)
        default:
            Logger.fatalErrorMessage("colorScheme is Empty")
            return Color.clear
        }
    }
}
