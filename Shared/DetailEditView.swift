/*
 See LICENSE folder for this sample’s licensing information.
 */

import SwiftUI

struct DetailEditView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isPresentWebView = false
    @Binding var data: DailyScrum.Data
    @State private var newAttendeeName = ""
    
    var body: some View {
        VStack{
            
            //MARK: - Main Content Start
            Form {
                Section(header: Text("Meeting Info")) {
                    TextField("Title", text: $data.title)
                    HStack {
                        Slider(value: $data.lengthInMinutes, in: 5...30, step: 1) {
                            Text("Length")
                        }
                        .accessibilityValue("\(Int(data.lengthInMinutes)) minutes")
                        Spacer()
                        Text("\(Int(data.lengthInMinutes)) minutes")
                            .accessibilityHidden(true)
                    }
                    ThemePicker(selection: $data.theme)
                }
                Section(header: Text("Attendees")) {
                    ForEach(data.attendees) { attendee in
                        Text(attendee.name)
                    }
                    .onDelete { indices in
                        data.attendees.remove(atOffsets: indices)
                    }
                    HStack {
                        TextField("New Attendee", text: $newAttendeeName)
                        Button(action: {
                            withAnimation {
                                let attendee = DailyScrum.Attendee(name: newAttendeeName)
                                data.attendees.append(attendee)
                                newAttendeeName = ""
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .accessibilityLabel("Add attendee")
                        }
                        .disabled(newAttendeeName.isEmpty)
                    }
                }
            }
            //MARK: - Main Content Finish
            //Website Direcetor
            Button(action: {
                isPresentWebView = true
            }) {
                Text("Combine library by Kobis")
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .frame(alignment: .center)
            }
            //Vstack Finish
            
            //MARK: - Navigation Controller
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
        }
    }
}


struct DetailEditView_Previews: PreviewProvider {
    static var previews: some View {
        DetailEditView(data: .constant(DailyScrum.sampleData[0].data))
    }
}
