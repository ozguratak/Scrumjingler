/*
See LICENSE folder for this sample’s licensing information.
*/


import SwiftUI

enum Theme: String, CaseIterable, Identifiable, Codable {
    case bubblegum
    case buttercup
    case indigo
    case lavender
    case magenta
    case navy
    case orange
    case oxblood
    case periwinkle
    case poppy
    case purple
    case seafoam
    case sky
    case tan
    case teal
    case yellow
    
    var accentColor: Color {
        switch self {
        case .indigo: return Color(.systemIndigo)
        case .orange: return Color(.systemOrange)
        case .yellow: return Color(.systemYellow)
        case .purple: return Color(.systemPurple)
        case .magenta: return Color(red: 255, green: 0, blue: 255)
        case .bubblegum: return Color(red: 255, green: 193, blue: 204)
        case .lavender: return Color(red: 230, green: 230, blue: 250)
        case .periwinkle: return Color(red: 204, green: 204, blue: 255)
        case .poppy: return Color(red: 218, green: 37, blue: 37)
        case .seafoam: return Color(red: 32, green: 178, blue: 170)
        case .sky: return Color(red: 135, green: 206, blue: 235)
        case .tan: return Color(red: 210, green: 180, blue: 140)
        case .teal: return Color(red: 0, green: 128, blue: 128)
        case .buttercup: return Color(red: 245, green: 179, blue: 30)
        case .navy: return Color(red: 32, green: 42, blue: 68)
        case .oxblood: return Color(red: 74, green: 4, blue: 4)
        }
    }
    var mainColor: Color {
        Color(rawValue)
    }
    var name: String {
        rawValue.capitalized
    }
    var id: String {
        name
    }
}
