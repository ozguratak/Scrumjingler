//
//  EmptyScrumView.swift
//  Scrumdinger (iOS)
//
//  Created by ozgur.atak on 21.03.2023.
//

import SwiftUI

struct EmptyScrumView: View {
    var body: some View {
        VStack{
            Text("There is no scrum found, press the + button to add scrum!")
                .frame(width: 400, height: 60, alignment: .center)
                .padding()
            LottieView(name: "EmptyScrumAnimation", loopMode: .loop)
                       .frame(width: 400, height: 400)
                .navigationTitle("Daily Scrums")
        }
    }
}

struct EmptyScrumView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyScrumView()
    }
}
