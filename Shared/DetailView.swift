/*
 See LICENSE folder for this sample’s licensing information.
 */

import SwiftUI

struct DetailView: View {
    @Binding var scrum: DailyScrum
    @Environment(\.colorScheme) var colorScheme
    @State private var data = DailyScrum.Data()
    @State private var isPresentWebView = false
    @State private var isPresentingEditView = false
    
    var body: some View {
        VStack{
            //MARK: - Admob
            Banner(bannerID: "ca-app-pub-5989837650310108/8320979549", width: UIScreen.main.bounds.width)
                .padding()
            //MARK: - MAin Content Start
            List {
                Section(header: Text("Meetıng Info")) {
                    
                    NavigationLink(destination: MeetingView(scrum: $scrum)) {
                        Label("Start Meeting", systemImage: "timer")
                            .font(.headline)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                    
                    
                    HStack {
                        Label("Length", systemImage: "clock")
                        Spacer()
                        Text("\(scrum.lengthInMinutes) minutes")
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .accessibilityElement(children: .combine)
                    HStack {
                        Label("Theme", systemImage: "paintpalette")
                        Spacer()
                        Text(scrum.theme.name)
                            .padding(4)
                            .foregroundColor(scrum.theme.accentColor)
                            .background(scrum.theme.mainColor)
                            .cornerRadius(4)
                    }
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .accessibilityElement(children: .combine)
                }
                
                Section(header: Text("Attendees")) {
                    ForEach(scrum.attendees) { attendee in
                        Label(attendee.name, systemImage: "person")
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                }
                .foregroundColor(colorScheme == .dark ? .white : .black)
                
                Section(header: Text("Hıstory")) {
                    if scrum.history.isEmpty {
                        Label("No meetings yet", systemImage: "calendar.badge.exclamationmark")
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                    ForEach(scrum.history) { history in
                        NavigationLink(destination: HistoryView(history: history)) {
                            HStack {
                                Image(systemName: "calendar")
                                Text(history.date, style: .date)
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                            }
                        }
                    }
                }
            }
            //MARK: - Main Content Finish
        }
        
        .navigationTitle(scrum.title)
        .foregroundColor(colorScheme == .dark ? .white : .black)
        .toolbar {
            Button("Edit") {
                isPresentingEditView = true
                data = scrum.data
            }
            .foregroundColor(colorScheme == .dark ? .white : .black)
        }
        //MARK: - Website Director
        Button(action: {
            isPresentWebView = true
        }) {
            Text("Combine library by Kobis")
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .frame(alignment: .center)
        }
         
        //MARK: - Navigation Controllers
        .sheet(isPresented: $isPresentingEditView) {
            NavigationView {
                DetailEditView(data: $data)
                    .navigationTitle(scrum.title)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                isPresentingEditView = false
                            }
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                Task{
                                    do {
                                        let totalSaved = try await DailyScrum.save(id: scrum.id, scrums: [scrum])
                                        Task{
                                            do {
                                                isPresentingEditView = false
                                                scrum.update(from: scrum.data)
                                            }
                                        }
                                    } catch {
                                        print("Saving error: \(error)")
                                    }
                                }
                            }
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                    }
            }
            .accentColor(colorScheme == .dark ? .white : .black)
        }
        
        .sheet(isPresented: $isPresentWebView) {
            NavigationView {
                WebSiteView(url: (URL(string: "https://kobis.io/") ?? URL(string: "https://github.com/404")!))
                    .toolbar {
                        HStack(alignment: .center){
                            Image(systemName: "arrow.down")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            
                            Text("Hold & drag down for closing")
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            
                            Image(systemName: "arrow.down")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                        .padding(.trailing, 70)
                    }
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(scrum: .constant(DailyScrum.sampleData[0]))
        }
    }
}
