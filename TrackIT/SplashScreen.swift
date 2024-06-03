//
//  SplashScreen.swift
//  TrackIT
//
//  Created by Raj Shah on 5/3/24.
//

import SwiftUI
import Combine

struct SplashScreen: View {
    @State private var navigateToMain = false

    var body: some View {
        NavigationView {
            VStack {
                Image("splash_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                Text("TrackIT")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hexString: "#4b948d"))
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    navigateToMain = true
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .background(NavigationLink("", destination: ContentView().navigationBarBackButtonHidden(true), isActive: $navigateToMain))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            SplashScreen()
        }
    }
}
