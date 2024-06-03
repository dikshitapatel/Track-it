//
//  FinanceNewsViewModel.swift
//  finance-news
//
//  Created by Dikshita Rajendra Patel on 17/04/24.
//

import Foundation

class FinanceNewsViewModel: ObservableObject {
    @Published var news = [FinanceNews]()

    func fetchNews() {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/fmp/articles?page=0&size=5&apikey=GYJFk486vkl5hU3pwgcF0xGPnXqpUn70") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(FinanceNewsResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.news = decodedResponse.content
                    }
                } catch {
                    print("Failed to decode JSON: \(error)")
                }
            } else if let error = error {
                print("Fetch failed: \(error.localizedDescription)")
            }
        }.resume()
    }
}

