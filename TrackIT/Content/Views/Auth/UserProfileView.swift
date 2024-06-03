import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

struct UserProfileView: View {
    @State private var age = ""
    @State private var sex = ""
    @State private var fullName = ""
    @State private var email = ""
    @State private var profileImage: UIImage? = nil
    @State private var isImagePickerPresented = false
    @State private var navigateToMain = false
    @State private var error: String? = nil
    @State private var selectedSexIndex = 0

    let defaultProfileImage = UIImage(named: "default_profile_image")
    let firebaseManager = FirebaseManager.shared
    let sexes = ["Male", "Female", "Other"]

    var body: some View {
        ScrollView {
                VStack {
                    ZStack {
                        Image(uiImage: profileImage ?? defaultProfileImage!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 6)
                        
                        Image(systemName: "camera")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                            .offset(x: 40, y: 40)
                            .onTapGesture {
                                isImagePickerPresented = true
                            }
                    }
                    .padding(.bottom, 20)
                    
                    VStack(spacing: 10) {
                        TextField("UserName/Email", text: $email)
                            .disabled(true)
                            .padding()
                            .frame(width: 350, height: 50)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.gray.opacity(0.1)))
                        TextField("Full Name", text: $fullName)
                            .padding()
                            .frame(width: 350, height: 50)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.gray.opacity(0.1)))
                        TextField("Age", text: $age)
                            .padding()
                            .frame(width: 350, height: 50)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.gray.opacity(0.1)))
                        Picker(selection: $selectedSexIndex, label: Text("Sex")) {
                            ForEach(0..<sexes.count) { index in
                                Text(sexes[index].capitalized)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                        .frame(width: 350, height: 50)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.gray.opacity(0.1)))

                    }
                    Button(action: {
                        saveProfile()
                    }) {
                        Text("Save")
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
                    .padding(.horizontal)
                }
                .padding(.top, 100)


            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(image: $profileImage)
            }
            .onAppear {
                loadUserProfile()
            }
            NavigationLink(destination: MainView().navigationBarBackButtonHidden(true), isActive: $navigateToMain)
            {
                EmptyView()
            }
        }
    }
    
    func loadUserProfile() {
        if let currentUser = firebaseManager.auth.currentUser {
            email = currentUser.email ?? ""
            let db = firebaseManager.firestore
            let userRef = db.collection("users").document(currentUser.uid)
            userRef.getDocument { document, error in
                if let document = document, document.exists {
                    let data = document.data()
                    fullName = data?["fullName"] as? String ?? ""
                    age = data?["age"] as? String ?? ""
                    sex = data?["sex"] as? String ?? ""
                    sex = data?["sex"] as? String ?? ""
                    if let sexIndex = sexes.firstIndex(of: sex.lowercased().capitalized) {
                            selectedSexIndex = sexIndex
                    }
                    if let profileImage = data?["profileImageURL"] as? String {
                        loadProfileImage(urlString: profileImage)
                    } else {
                        profileImage = defaultProfileImage
                    }
                } else {
                    print("User profile document does not exist")
                }
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
                return
            }
            
            if let uiImage = UIImage(data: data) {
                profileImage = uiImage
            } else {
                print("Failed to create UIImage from data")
            }
        }.resume()
    }
    
    func saveProfile() {
        if let user = firebaseManager.auth.currentUser {
            let db = firebaseManager.firestore
            let userRef = db.collection("users").document(user.uid)
            
            var profileData: [String: Any] = [
                "fullName": fullName,
                "email": email,
                "age": age,
                "sex": sexes[selectedSexIndex]
            ]
            
            if let image = profileImage {
                guard let imageData = image.jpegData(compressionQuality: 0.5) else {
                    print("Failed to convert image to data")
                    return
                }
                
                let storageRef = firebaseManager.storage.reference().child("profile_images").child("\(user.uid).jpg")
                storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                    if let error = error {
                        print("Error uploading profile image: \(error.localizedDescription)")
                    } else {
                        storageRef.downloadURL { (url, error) in
                            if let downloadURL = url {
                                print("Download URL: \(downloadURL)")
                                profileData["profileImageURL"] = downloadURL.absoluteString
                                // Save profile data to Firestore
                                userRef.setData(profileData, merge: true) { error in
                                    if let error = error {
                                        print("Error saving profile information: \(error.localizedDescription)")
                                    } else {
                                        navigateToMain = true // Navigate to MainView
                                    }
                                }
                            } else {
                                print("Error getting download URL: \(error?.localizedDescription ?? "")")
                            }
                        }
                    }
                }
            } else {
                userRef.setData(profileData, merge: true) { error in
                    if let error = error {
                        print("Error saving profile information: \(error.localizedDescription)")
                    } else {
                        navigateToMain = true
                    }
                }
            }
        }
    }
}
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
