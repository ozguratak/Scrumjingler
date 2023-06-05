//
//  EmptyTrancriptView.swift
//  Scrumdinger (iOS)
//
//  Created by ozgur.atak on 24.03.2023.
//

import SwiftUI

struct EmptyTranscriptView: View {
    
    var body: some View {
        VStack{
            Text("Transcript couldn't find...")
                .frame(width: 400, height: 60, alignment: .center)
                .padding()
            LottieView(name: "EmptyTranscriptAnimation", loopMode: .loop)
                       .frame(width: 400, height: 400)
                       
        }
    }
}

struct EmptyTrancriptView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyTranscriptView()
    }
}
