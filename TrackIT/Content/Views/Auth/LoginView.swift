import SwiftUI
import Firebase

struct LoginView: View {
    let firebaseManager = FirebaseManager.shared

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var error: String?
    @State private var navigateToMain = false
    
    var body: some View {
        ScrollView {
            VStack {
                    ZStack {
                        Image("login")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 6)
                    }
                    .padding(.bottom, 20)
                    
                    VStack(spacing: 10) {
                        TextField("Email", text: $email)
                            .padding()
                            .frame(width: 350, height: 50)
                            .background(RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color.gray.opacity(0.1)))
                        SecureField("Password", text: $password)
                            .padding()
                            .frame(width: 350, height: 50)
                            .background(RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color.gray.opacity(0.1)))
                        
                    }
                    if let error = error {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                    }
                    Button(action: {
                        signIn()
                    }) {
                        Text("Log In")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                            .frame(width: 350, height: 50)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                            .padding([.leading, .trailing], 10)
                    }
                    HStack {
                        Text("New User?")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        NavigationLink(destination: RegisterView().navigationBarBackButtonHidden(true)) {
                            Text("Register")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                }
            .padding(.top, 150)
            
            .navigationBarHidden(true)
            .onAppear {
                self.navigateToMain = false
            }
            .background(
                NavigationLink(destination: MainView().navigationBarBackButtonHidden(true)
                               , isActive: $navigateToMain) {
                                   EmptyView()
                }
            )
            .navigationBarBackButtonHidden(true)
        }
    }
    
    func signIn() {
        firebaseManager.auth.signIn(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                switch error.code {
                case AuthErrorCode.userNotFound.rawValue, AuthErrorCode.invalidEmail.rawValue:
                    self.error = "Invalid email"
                case AuthErrorCode.wrongPassword.rawValue:
                    self.error = "Invalid password"
                default:
                    self.error = "An error occurred"
                }
            } else {
                self.navigateToMain = true
            }
        }
    }
}
