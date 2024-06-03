//
//  FinanceNewsView.swift
//  TrackIT
//
//  Created by Dikshita Rajendra Patel on 17/04/24.
//

import SwiftUI
import WebKit

struct FinanceNewsView: View {
    @ObservedObject var viewModel = FinanceNewsViewModel()
    @Environment(\.horizontalSizeClass) var sizeClass 
    var body: some View {
        Group {
            if sizeClass == .regular {
                NavigationSplitView {
                    List(viewModel.news) { newsItem in
                        FinanceNewsRow(newsItem: newsItem)
                        NavigationLink(destination: WebView(url: newsItem.link)) {
                            Text("Read more...")
                                .foregroundColor(.blue)
                                .font(.subheadline)
                        }
                    }
                    .navigationBarTitle("Financial News", displayMode: .automatic)
                    .onAppear {
                        viewModel.fetchNews()
                    }
                } detail: {
                    Text("Select a news item")
                }
            } else {
                NavigationView {
                    List(viewModel.news) { newsItem in
                        FinanceNewsRow(newsItem: newsItem)
                        NavigationLink(destination: WebView(url: newsItem.link)) {
                            Text("Read more...")
                                .foregroundColor(.blue)
                                .font(.subheadline)
                        }
                    }
                    .navigationBarTitle("Financial News", displayMode: .automatic)
                    .onAppear {
                        viewModel.fetchNews()
                    }
                }
            }
        }
    }
}

struct FinanceNewsRow: View {
    var newsItem: FinanceNews

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(newsItem.title)
                .font(.headline)
            HStack {
                Text("Author:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(newsItem.author)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            HStack {
                Text("Published on:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(newsItem.date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct DetailView: View {
    var newsItem: FinanceNews

    var body: some View {
        WebView(url: newsItem.link)
            .navigationBarTitle(newsItem.title, displayMode: .inline)
    }
}
