import SwiftUI
import WebKit

struct ExpenseVideo: View {
    let videoIDs = ["IfpAjsytwy0", "VaiqGsot5ws", "bMXTGGxrQ3A", "J6oHchaCxvM", "4j2emMn7UaI"] // Array of YouTube video IDs
    
    @Environment(\.horizontalSizeClass) var hSizeClass
    
    var body: some View {
        if hSizeClass == .regular {
            iPadOrMacContentView
        } else {
            NavigationView {
                iphoneView
            }
        }
    }
    
    private var iPadOrMacContentView : some View {
        ScrollView {
            HStack(spacing: 4) {
                Text("Expense Video")
                    .font(.headline)
            }

            VStack(alignment: .leading, spacing: 8) {
                ForEach(videoIDs, id: \.self) { videoID in
                    YouTubePlayer(videoID: videoID)
                        .frame(height: 200)
                        .padding(10)
                }
            }
        }
        .navigationBarTitle("", displayMode: .automatic)
        .navigationBarBackButtonHidden(true)
    }
    
    private var iphoneView : some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(videoIDs, id: \.self) { videoID in
                    YouTubePlayer(videoID: videoID)
                        .frame(height: 200)
                        .padding(10)
                }
            }
        }
        .navigationBarTitle("Expense Video", displayMode: .automatic)
        .navigationBarBackButtonHidden(true)
    }
    
    struct YouTubePlayer: UIViewRepresentable {
        let videoID: String
        
        func makeUIView(context: Context) -> WKWebView {
            let webView = WKWebView()
            return webView
        }
        
        func updateUIView(_ uiView: WKWebView, context: Context) {
            let embedHTML = """
            <iframe width="100%" height="95%" src="https://www.youtube.com/embed/\(videoID)" frameborder="0" allowfullscreen></iframe>
            """
            uiView.loadHTMLString(embedHTML, baseURL: nil)
        }
    }
}
