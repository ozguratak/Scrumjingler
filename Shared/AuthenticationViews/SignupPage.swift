//
//  SignupPage.swift
//  Scrumdinger (iOS)
//
//  Created by ozgur.atak on 28.03.2023.
//

import SwiftUI
struct SignupPage: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) var dismiss
    @State var authController = AuthenticationManager()
    @State private var errorWrapper: ErrorWrapper?
    @State public var isRegisterSuccess = false
    @State var email: String = "test@tester.com"
    @State var password: String = "1234567"
    @State var passwordAgain: String = "1234567"
    @State var name: String = "test"
    @State var lastName: String = "user"
    @State var showPassword: Bool = false
    
    var passError: Error?
    var isSignInButtonDisabled: Bool {
        [name, password, email, lastName, passwordAgain].contains(where: \.isEmpty)
    }
    
    var body: some View {
        VStack {
            Image("byKobis")
                .resizable()
                .frame(width: 250, height: 180, alignment: .center)
            
            VStack(alignment: .leading, spacing: 15) {
                TextField("E-Mail adress",
                          text: $email ,
                          prompt: Text("E-Mail adress").foregroundColor(.blue)
                )
                .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.blue, lineWidth: 2)
                }
                .padding(.horizontal)
                
                TextField("Name",
                          text: $name ,
                          prompt: Text("Name").foregroundColor(.blue)
                )
                .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.blue, lineWidth: 2)
                }
                .padding(.horizontal)
                
                TextField("Last Name",
                          text: $lastName ,
                          prompt: Text("Last Name").foregroundColor(.blue)
                )
                .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.blue, lineWidth: 2)
                }
                .padding(.horizontal)
                
                VStack{
                    HStack {
                        Group {
                            if showPassword {
                                TextField("Password", // how to create a secure text field
                                          text: $password,
                                          prompt: Text("Password").foregroundColor(.red)) // How to change the color of the TextField Placeholder
                            } else {
                                SecureField("Password", // how to create a secure text field
                                            text: $password,
                                            prompt: Text("Password").foregroundColor(.red)) // How to change the color of the TextField Placeholder
                            }
                        }
                        .padding(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.red, lineWidth: 2) // How to add rounded corner to a TextField and change it colour
                        }
                        
                      
                    }
                    
                    
                    HStack {
                        Group {
                            if showPassword {
                                TextField("Password Again", // how to create a secure text field
                                          text: $passwordAgain,
                                          prompt: Text("Password Again").foregroundColor(.red)) // How to change the color of the TextField Placeholder
                            } else {
                                SecureField("Password Again", // how to create a secure text field
                                            text: $passwordAgain,
                                            prompt: Text("Password Again").foregroundColor(.red)) // How to change the color of the TextField Placeholder
                            }
                        }
                        .padding(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.red, lineWidth: 2) // How to add rounded corner to a TextField and change it colour
                        }
                        
                        Button {
                            showPassword.toggle()
                        } label: {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .foregroundColor(.red) // how to change image based in a State variable
                        }
                        .padding(.vertical)
                    }
                }
          .padding(.horizontal)
          //MARK: - TextField Content End
                
                Spacer()
                
                VStack{
                    Button {
                        if password == passwordAgain {
                            authController.registerUser(email: email, password: password, name: name, lastName: lastName) { error in
                                if error == nil {
                                    isRegisterSuccess = true
                                       
                                } else {
                                    errorWrapper = ErrorWrapper(error: error!, guidance: "An error occured please check your informations adn try again!")
                                }
                            }
                        } else {
                            print("password are not equal!")
                        }
                      
                        
                    } label: {
                        Text("Register!")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                            .frame(height: 50)
                            .frame(maxWidth: .infinity) // how to make a button fill all the space available horizontaly
                            .background(
                                isSignInButtonDisabled ? // how to add a gradient to a button in SwiftUI if the button is disabled
                                LinearGradient(colors: [.gray], startPoint: .topLeading, endPoint: .bottomTrailing) :
                                    LinearGradient(colors: [.blue, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .cornerRadius(20)
                            .disabled(isSignInButtonDisabled) // how to disable while some condition is applied
                            .padding()
                    }
                    
                }
                
            }
        }
    }
}

struct SignupPage_Previews: PreviewProvider {
    static var previews: some View {
        SignupPage()
    }
}
