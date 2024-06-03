//
//  ProfileMenuView.swift
//  TrackIT
//
//  Created by Raj Shah on 4/28/24.
//

import SwiftUI
import Firebase
struct ProfileMenuView: View {
    let defaultProfileImage = UIImage(named: "default_profile_image")
    var firebaseManager = FirebaseManager.shared
    @State var isSignedOut: Bool = false
    @State private var userName: String?
    @State private var profileImage: UIImage?
    @State private var isLoadingImage = false

    var body: some View {
        ScrollView {
            Button(action: {}) {
                HStack {
                    if let userName = userName {
                        NavigationLink(destination: UserProfileView()) {
                            if isLoadingImage {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .frame(width: 24, height: 24)
                            } else {
                                if let profileImage = profileImage {
                                    Image(uiImage: profileImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 24, height: 24)
                                        .clipShape(Circle())
                                } else {
                                    Image(uiImage: defaultProfileImage!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 24, height: 24)
                                        .clipShape(Circle())
                                }
                            }
                            Text(userName)
                        }
                    }
                }
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
            .padding()
            Button(action: {
            }) {
                NavigationLink(destination: LocateUsView()) {
                    HStack {
                        Image(systemName: "location")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 24, height: 24)
                            .clipShape(Circle())
                        Text("Locate Nearby Banks")
                    }.font(.headline)
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
            }
            .padding()
            
            Button(action: {
                signOut()
            }) {
                HStack {
                    Image(systemName: "arrowshape.turn.up.left.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 24, height: 24)
                        .clipShape(Circle())
                    Text("Sign Out")
                }.font(.headline)
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
            .padding()
        }
        .onAppear {
            self.isSignedOut = false
            fetchUserDetails()
        }.background(
            NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true)
                           , isActive: $isSignedOut) {
                               EmptyView()
            }
        )
    }

    func fetchUserDetails() {
        guard let userId = firebaseManager.auth.currentUser?.uid else {
            print("User ID not found")
            return
        }

        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                if let userName = data?["email"] as? String {
                    self.userName = userName
                }
                if let profileImageURL = data?["profileImageURL"] as? String {
                    isLoadingImage = true
                    loadProfileImage(urlString: profileImageURL)
                }
            } else {
                print("User document does not exist")
            }
        }
    }

    func loadProfileImage(urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid image URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to load image:", error?.localizedDescription ?? "Unknown error")
                isLoadingImage = false
                return
            }

            if let uiImage = UIImage(data: data) {
                self.profileImage = uiImage
            } else {
                print("Failed to create UIImage from data")
            }
            isLoadingImage = false
        }.resume()
    }

    func signOut() {
        firebaseManager.signOut { error in
            if let _ = error {
                print("Error signing out.")
            } else {
                isSignedOut = true
            }
        }
    }
}
