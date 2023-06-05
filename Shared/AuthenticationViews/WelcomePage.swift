//
//  WelcomePage.swift
//  Scrumdinger (iOS)
//
//  Created by ozgur.atak on 28.03.2023.
//

import SwiftUI

struct WelcomePage: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var store = ScrumStore()
    @State private var errorWrapper: ErrorWrapper?
    @State private var isSignUpEnable = false
    @State public var isLoginSuccess = false
    @State public var isWelcomePagePresented = false
    @State var authController = AuthenticationManager()
    @State var name: String = "test@tester.com"
    @State var password: String = "1234567"
    @State var showPassword: Bool = false
    
    var isSignInButtonDisabled: Bool {
        [name, password].contains(where: \.isEmpty)
    }
    
    var body: some View {
        VStack {
            Image("byKobis")
                .resizable()
                .frame(width: 200, height: 200, alignment: .center)
            
            VStack(alignment: .leading, spacing: 15) {
                
                Spacer()
                
                TextField("E-Mail adress",
                          text: $name ,
                          prompt: Text("E-Mail adress").foregroundColor(.blue)
                )
                .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.blue, lineWidth: 2)
                }
                .padding(.horizontal)
                 
                HStack {
                    Group {
                        if showPassword {
                            TextField("Password",
                                      text: $password,
                                      prompt: Text("Password").foregroundColor(.red))
                        } else {
                            SecureField("Password",
                                        text: $password,
                                        prompt: Text("Password").foregroundColor(.red))
                        }
                    }
                    .padding(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.red, lineWidth: 2)
                    }
                    
                    Button {
                        showPassword.toggle()
                    } label: {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundColor(.red)
                    }
                    
                }.padding(.horizontal)
                
                Spacer()
//MARK: - Button Controls
                VStack{
                    Button {
                        authController.loginUser(email: name, password: password) { error, verifiedResult, currentID in
                            if error == nil {
                                isLoginSuccess = true
                                
                            } else {
                                errorWrapper = ErrorWrapper(error: error!, guidance: "Invalid password or username")
                            }
                        }
                        
                    } label: {
                        Text("Sign In")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(
                                isSignInButtonDisabled ?
                                LinearGradient(colors: [.gray], startPoint: .topLeading, endPoint: .bottomTrailing) :
                                    LinearGradient(colors: [.blue, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .cornerRadius(20)
                            .disabled(isSignInButtonDisabled)
                            .padding()
                    }
                    
                }
                
                Button {
                    isSignUpEnable = true
                } label: {
                    Text("Dont have an account? Sign Up!")
                        .font(.title3)
                        .bold()
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .frame(height: 20)
                        .frame(maxWidth: .infinity)
                        .disabled(isSignUpEnable)
                        .padding()
                }
            }
            .sheet(isPresented: $isSignUpEnable) {
                NavigationView {
                    SignupPage()
                    
                }
            }
            
            .task {
                ScrumStore().downloadScrums(mode: .allUser) { results in
                    switch results {
                    case .success(let scrumList):
                        store.scrums = scrumList
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            
            NavigationLink(
                destination: ScrumsView(scrums: $store.scrums, saveAction: {}).navigationBarBackButtonHidden(true),
                isActive: $isLoginSuccess,
                label: {
                    EmptyView()
                }
            )
            .hidden()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomePage()
    }
}
