/*
See LICENSE folder for this sample’s licensing information.
*/

import SwiftUI
import AVFoundation

struct MeetingView: View {
    @Binding var scrum: DailyScrum
    @StateObject var scrumTimer = ScrumTimer()
    @StateObject var speechRecognizer = SpeechRecognizer()
    @Environment(\.colorScheme) var colorScheme
    @State private var isPresentWebView = false
    @State private var isRecording = false
    private var player: AVPlayer { AVPlayer.sharedDingPlayer }
    
    var body: some View {
        VStack{
            //MARK: - Admob
            Banner(bannerID: "ca-app-pub-5989837650310108/8320979549", width: UIScreen.main.bounds.width)
                .padding()
            //MARK: - Main Content Start
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(scrum.theme.mainColor)
                VStack {
                    MeetingHeaderView(secondsElapsed: scrumTimer.secondsElapsed, secondsRemaining: scrumTimer.secondsRemaining, theme: scrum.theme)
                    MeetingTimerView(speakers: scrumTimer.speakers, isRecording: isRecording, theme: scrum.theme)
                    MeetingFooterView(speakers: scrumTimer.speakers, skipAction: scrumTimer.skipSpeaker)
                }
            }
            //MARK: - Main Content Finish
            
            Button(action: {
                isPresentWebView = true
            }) {
                Text("Combine library by Kobis")
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .frame(alignment: .center)
            }
        }
        
        .padding()
        .foregroundColor(scrum.theme.accentColor)
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
        
        
        .onAppear {
            scrumTimer.reset(lengthInMinutes: scrum.lengthInMinutes, attendees: scrum.attendees)
            scrumTimer.speakerChangedAction = {
                player.seek(to: .zero)
                player.play()
            }
            speechRecognizer.reset()
            speechRecognizer.transcribe()
            isRecording = true
            scrumTimer.startScrum()
        }
        
        .onDisappear {
            scrumTimer.stopScrum()
            speechRecognizer.stopTranscribing()
            isRecording = false
            let newHistory = History(attendees: scrum.attendees, lengthInMinutes: scrum.timer.secondsElapsed / 60, transcript: speechRecognizer.transcript)
            scrum.history.insert(newHistory, at: 0)
            Task{
                do {
                    let totalSaved = try await DailyScrum.save(id: nil, scrums: [scrum])
                    Task{
                        do {
                            AuthenticationManager().updateScrumHistory(history: newHistory, scrumID: scrum.id)
                            print("saving success")
                            print(totalSaved)
                        }
                    }
                } catch {
                    print("Saving error: \(error)")
                }
            }
            
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MeetingView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingView(scrum: .constant(DailyScrum.sampleData[0]))
    }
}
