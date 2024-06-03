// ContentView.swift

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

struct ContentView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Spacer()
                    Image("mainlogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 400)
                        .shadow(radius: 6)
                    NavigationLink(destination: RegisterView().navigationBarBackButtonHidden(true)) {
                        Text("Get Started")
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
                    }.padding(.bottom)
                    
                    HStack {
                        Text("Already have an account? ")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true)) {
                            Text("Log In")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }.padding(.top, 100)
            }.edgesIgnoringSafeArea(.all)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
