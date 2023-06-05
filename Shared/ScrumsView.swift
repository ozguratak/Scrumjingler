/*
 See LICENSE folder for this sample’s licensing information.
 */

import SwiftUI

struct ScrumsView: View {
    @Binding var scrums: [DailyScrum]
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.colorScheme) private var colorScheme
    @State private var isPresentingNewScrumView = false
    @State private var isPresentSettingView = false
    @State private var isPresentWebView = false
    @State private var newScrumData = DailyScrum.Data()
    let saveAction: ()->Void
    
    
    var body: some View {
        //MARK: - Scrum Data is empty
        if scrums.count <= 0 {
            VStack{
                //MARK: - Admob
                Banner(bannerID: "ca-app-pub-5989837650310108/8320979549", width: UIScreen.main.bounds.width)
                Spacer()
                //MARK: - Main Content Start
                EmptyScrumView()
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    HStack {
                        Button(action: {
                            isPresentingNewScrumView = true
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .font(.system(size: 20))
                        }
                        .accessibilityLabel("New Scrum")
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        
                        Button(action: {
                            isPresentSettingView = true
                        }) {
                            Image(systemName: "gear")
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .font(.system(size: 20))
                        }
                        .accessibilityLabel("Settings")
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isPresentWebView = true
                    }) {
                        Image("byKobis")
                            .resizable()
                            .frame(width: 80, height: 80, alignment: .center)
                    }
                }
            }
            
            .sheet(isPresented: $isPresentingNewScrumView) {
                NavigationView {
                    DetailEditView(data: $newScrumData)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Dismis") {
                                    isPresentingNewScrumView = false
                                    newScrumData = DailyScrum.Data()
                                }
                            }
                            
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Add") {
                                    let newScrum = DailyScrum(data: newScrumData)
                                    scrums.append(newScrum)
                                    isPresentingNewScrumView = false
                                    newScrumData = DailyScrum.Data()
                                    Task{
                                        do {
                                            let totalSaved = try await DailyScrum.save(id: nil, scrums: [newScrum])
                                            Task{
                                                do {
                                                    if AuthenticationManager().updateScrumList(state: .add, scrumID: newScrum.id) {
                                                        print("saving success")
                                                        print(totalSaved)
                                                    }
                                                }
                                            }
                                        } catch {
                                            print("Saving error: \(error)")
                                        }
                                    }
                                }
                            }
                        }
                }.accentColor(colorScheme == .dark ? .white : .black)
            }
            .sheet(isPresented: $isPresentWebView) {
                NavigationView {
                    WebSiteView(url: (URL(string: "https://kobis.io/") ?? URL(string: "https://github.com/404")!))
                }
            }
            .sheet(isPresented: $isPresentSettingView) {
                NavigationView{
                    SettingsView(newMail: currentEmail)
                }
            }
            .onChange(of: scenePhase) { phase in
                if phase == .inactive { saveAction() }
            }
            
            //MARK: - Scrum Data is not empty
            
        } else {
            VStack{
                //MARK: - Admob
                Banner(bannerID: "ca-app-pub-5989837650310108/8320979549", width: UIScreen.main.bounds.width)
                    .padding()
                //MARK: - Main Content Start
                List {
                    ForEach($scrums.sorted(by: { $0.timeStamp.wrappedValue ?? Date().addingTimeInterval(1680765000) > $1.timeStamp.wrappedValue ?? Date().addingTimeInterval(1680766000) })) { $scrum in
                ZStack {
                NavigationLink(destination: DetailView(scrum: $scrum)) {
                EmptyView()
                }
                .accentColor(colorScheme == .dark ? .white : .black)
                .buttonStyle(PlainButtonStyle())
                .opacity(0.0)
                        HStack {
                            CardView(scrum: scrum)
                                .frame(width: UIScreen.main.bounds.width - 60)
                        }
                    }
                    .listRowBackground(scrum.theme.mainColor)
                }
                .navigationTitle("Daily Scrums")
                .accentColor(colorScheme == .dark ? .white : .black)
                }
                
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    HStack {
                        Button(action: {
                            isPresentingNewScrumView = true
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .font(.system(size: 20))
                        }
                        .accessibilityLabel("New Scrum")
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        
                        Button(action: {
                            isPresentSettingView = true
                        }) {
                            Image(systemName: "gear")
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .font(.system(size: 20))
                        }
                        .accessibilityLabel("Settings")
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isPresentWebView = true
                    }) {
                        Image("byKobis")
                            .resizable()
                            .frame(width: 80, height: 80, alignment: .center)
                    }
                }
            }
            
            .sheet(isPresented: $isPresentingNewScrumView) {
                NavigationView {
                    DetailEditView(data: $newScrumData)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Dismis") {
                                    isPresentingNewScrumView = false
                                    newScrumData = DailyScrum.Data()
                                }
                            }
                            
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Add") {
                                    let newScrum = DailyScrum(data: newScrumData)
                                    scrums.append(newScrum)
                                    isPresentingNewScrumView = false
                                    newScrumData = DailyScrum.Data()
                                    Task{
                                        do {
                                            let totalSaved = try await DailyScrum.save(id: nil, scrums: [newScrum])
                                            Task{
                                                do {
                                                    if AuthenticationManager().updateScrumList(state: .add, scrumID: newScrum.id) {
                                                        print("\(totalSaved) scrums are saved succesly")
                                                    }
                                                }
                                            }
                                        } catch {
                                            print("Saving error: \(error)")
                                        }
                                    }
                                }
                            }
                        }
                }.accentColor(colorScheme == .dark ? .white : .black)
            }
            
            .onAppear(perform: {
                ScrumStore().downloadScrums(mode: .allUser) { result in
                    switch result {
                    case .success(let scrumsFromFirebase):
                        scrums = scrumsFromFirebase
                    case .failure(let error):
                        print(error)
                    }
                }
            })
            
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
                .onDisappear {
                    WebSiteView(url: (URL(string: "https://kobis.io/") ?? URL(string: "https://github.com/404")!)).close()
                }
            }
            .sheet(isPresented: $isPresentSettingView) {
                NavigationView{
                    SettingsView(newMail: currentEmail)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("LogOut!") {
                                    isPresentSettingView = false
                                    AuthenticationManager().logout()
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .frame(width: 90, height: 30)
                                .background(
                                        LinearGradient(colors: [.blue, .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                                .cornerRadius(20)
                            }
                        }
                }
            }
            .onChange(of: scenePhase) { phase in
                if phase == .inactive { saveAction() }
                if phase == .active {
                    
                    ScrumStore().downloadScrums(mode: .allUser) { result in
                        switch result {
                        case .success(let scrumsFromFirebase):
                            scrums = scrumsFromFirebase
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            }
            
        }
    }
}

struct ScrumsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ScrumsView(scrums: .constant(DailyScrum.sampleData), saveAction: {})
        }
    }
}


