//
//  SettingsView.swift
//  Scrumdinger (iOS)
//
//  Created by ozgur.atak on 21.03.2023.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) private var colorScheme
    @State var newMail: String
    @State var password: String = ""
    @State var isEditingEnd: Bool = false
    @State var isLogout: Bool = false
    @State var isRemindMe: Bool = true
    
    var body: some View {
        VStack {
            HStack(alignment: .center){
                Image("byKobis")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width / 5, height: 80)
                    .padding(.horizontal)
                Text("Settings")
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)
                Image("byKobis")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width / 5, height: 80)
                    .padding(.horizontal)
                
            }.padding(.vertical)
            
            VStack{
                TextField("New E-Mail Adress",
                          text: $newMail ,
                          prompt: Text("E-Mail Adress").foregroundColor(.blue)
                )
                .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.blue, lineWidth: 2)
                }
                .padding(.horizontal)
                
                TextField("New Password",
                          text: $password ,
                          prompt: Text("New Password").foregroundColor(.blue)
                )
                .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.blue, lineWidth: 2)
                }
                .padding(.horizontal)
                
                
                Button {
                    isEditingEnd = true
                    
                } label: {
                    Text("Save Changes")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(
                            isEditingEnd ?
                            LinearGradient(colors: [.gray], startPoint: .topLeading, endPoint: .bottomTrailing) :
                                LinearGradient(colors: [.blue, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .cornerRadius(20)
                        .disabled(isEditingEnd)
                        .padding()
                }
                HStack{
                    Toggle("Remind my account informations", isOn: $isRemindMe)
                        .toggleStyle(SwitchToggleStyle(tint: .green))
                }
            }
        }
        //VSTACK END
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(newMail: currentEmail)
    }
}
