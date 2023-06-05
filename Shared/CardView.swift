/*
 See LICENSE folder for this sample’s licensing information.
 */

import SwiftUI

struct CardView: View {
    @Environment(\.colorScheme) var colorScheme
    let scrum: DailyScrum
    
    var body: some View {
        VStack{
            HStack {
                VStack(alignment: .leading) {
                    Text(scrum.title)
                        .accessibilityAddTraits(.isHeader)
                        .font(.headline)
                        .foregroundColor(colorScheme == .dark ? .black : .white)
                    
                    Spacer()
                    HStack {
                        Label("\(scrum.attendees.count + 1)", systemImage: "person.3")
                            .accessibilityLabel("\(scrum.attendees.count) attendees")
                            .foregroundColor(colorScheme == .dark ? .black : .white)
                        Spacer()
                        Label("\(scrum.lengthInMinutes)", systemImage: "clock")
                            .accessibilityLabel("\(scrum.lengthInMinutes) minute meeting")
                            .labelStyle(.trailingIcon)
                            .foregroundColor(colorScheme == .dark ? .black : .white)
                    }
                    .font(.caption)
                }
                .padding()
                .foregroundColor(scrum.theme.mainColor)
                
                Image(systemName: "chevron.right")
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .frame(alignment: .trailing)
                    .padding(3)
            }
            Divider()
                .foregroundColor(colorScheme == .dark ? .gray : .black)
                .font(.title2)
                .frame(height: 10)
        }

    }
}

struct StraightLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return path
    }
}

struct CardView_Previews: PreviewProvider {
    static var scrum = DailyScrum.sampleData[0]
    static var previews: some View {
        CardView(scrum: scrum)
            .background(scrum.theme.accentColor)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}

