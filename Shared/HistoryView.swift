//
//  HistoryView.swift
//  Scrumdinger (iOS)
//
//  Created by Tengku Zulfadli on 15/10/2022.
//

import SwiftUI

struct HistoryView: View {
    @State private var isPresentWebView = false
    @Environment(\.colorScheme) var colorScheme
    let history: History
    
    var body: some View {
        VStack {
            //MARK: - Admob
            Banner(bannerID: "ca-app-pub-5989837650310108/8320979549", width: UIScreen.main.bounds.width)
                .padding()
            //MARK: - Main Content Start
            ScrollView {
                VStack(alignment: .leading) {
                  
                    Divider()
                        .padding(.bottom)
                //MARK: - Main Content Start
                    if let transcript = history.transcript {
                        if transcript.isEmpty || transcript == ""{
                            EmptyTranscriptView()
                        } else {
                            Text("Attendees")
                                .font(.headline)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            Text(history.attendeeString)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            
                            Text("Transcript")
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .font(.headline)
                                .padding(.top)
                            Text(transcript)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                    }
                }
                //MARK: - Main Content Finish
            }
            //Scrollable Main Content's Vstack End
            
            Button(action: {
                isPresentWebView = true
            }) {
                Text("Combine library by Kobis")
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .frame(alignment: .center)
            }
        }
        //Vstack End
        
        .sheet(isPresented: $isPresentWebView) {
            NavigationView {
                WebSiteView(url: (URL(string: "https://kobis.io/") ?? URL(string: "https://github.com/404")!))
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Dismis") {
                                WebSiteView(url: (URL(string: "https://kobis.io/") ?? URL(string: "https://github.com/404")!)).close()
                                isPresentWebView = false
                            }
                        }
                    }
            }
            }
        .navigationTitle(Text(history.date, style: .date))
        .padding()
    }
}

extension History {
    var attendeeString: String {
        ListFormatter.localizedString(byJoining: attendees.map { $0.name })
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var history: History {
        History(attendees: [DailyScrum.Attendee(name: "Jon"), DailyScrum.Attendee(name: "Darla"), DailyScrum.Attendee(name: "Luis")], lengthInMinutes: 10, transcript: "Darla, would you like to start today? Sure, yesterday I reviewed Luis' PR and met with the design team to finalize the UI...")
    }
    static var previews: some View {
        HistoryView(history: history)
    }
}
