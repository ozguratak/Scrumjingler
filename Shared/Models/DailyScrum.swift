/*
See LICENSE folder for this sample’s licensing information.
*/

import Foundation

struct DailyScrum: Identifiable, Codable {
    
    let id: String
    var title: String
    var attendees: [Attendee]
    var lengthInMinutes: Int
    var theme: Theme
    var history: [History] = []
    var timeStamp: Date? // timeStamp özelliği eklendi

    init(title: String, attendees: [String], lengthInMinutes: Int, theme: Theme) {
        let Id = UUID().uuidString
        self.id = Id
        self.title = title
        self.attendees = attendees.map { Attendee(name: $0) }
        self.lengthInMinutes = lengthInMinutes
        self.theme = theme
        self.timeStamp = Date() // timeStamp oluşturma zamanı ayarlandı
    }
}

extension DailyScrum {
    struct Attendee: Identifiable, Codable {
        let id: UUID
        var name: String
        
        init(id: UUID = UUID(), name: String) {
            self.id = id
            self.name = name
        }
    }
    
    struct Data {
        var title: String = ""
        var attendees: [Attendee] = []
        var lengthInMinutes: Double = 5
        var theme: Theme = .seafoam
    }
    
    var data: Data {
        Data(title: title, attendees: attendees, lengthInMinutes: Double(lengthInMinutes), theme: theme)
    }
    
    mutating func update(from data: Data) {
            title = data.title
            attendees = data.attendees
            lengthInMinutes = Int(data.lengthInMinutes)
            theme = data.theme
            timeStamp = Date() // title değiştiği zaman timeStamp güncellendi
        }

        init(data: Data) {
            id = UUID().uuidString
            title = data.title
            attendees = data.attendees
            lengthInMinutes = Int(data.lengthInMinutes)
            theme = data.theme
            timeStamp = Date() // timeStamp oluşturma zamanı ayarlandı
        }
}

extension DailyScrum {
    static var sampleData: [DailyScrum] =
    [
        DailyScrum(title: "Design", attendees: ["Cathy", "Daisy", "Simon", "Jonathan"], lengthInMinutes: 10, theme: .yellow),
        DailyScrum(title: "App Dev", attendees: ["Katie", "Gray", "Euna", "Luis", "Darla"], lengthInMinutes: 5, theme: .orange),
        DailyScrum(title: "Web Dev", attendees: ["Chella", "Chris", "Christina", "Eden", "Karla", "Lindsey", "Aga", "Chad", "Jenn", "Sarah"], lengthInMinutes: 5, theme: .poppy)
    ]
}
