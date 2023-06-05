//
//  Setting.swift
//  Scrumdinger (iOS)
//
//  Created by ozgur.atak on 21.03.2023.
//

import Foundation
struct SettingModel: Identifiable, Codable {
    let id: UUID
    var title: String
  
    var lengthInMinutes: Int
    var theme: Theme
    var history: [History] = []
    
    init(id: UUID = UUID(), title: String, attendees: [String], lengthInMinutes: Int, theme: Theme) {
        self.id = id
        self.title = title
        self.lengthInMinutes = lengthInMinutes
        self.theme = theme
    }
}
