//
//  FinanceNews.swift
//  TrackIT
//
//  Created by Raj Shah on 4/17/24.
//

import Foundation

struct FinanceNewsResponse: Codable {
    var content: [FinanceNews]
}

struct FinanceNews: Codable, Identifiable {
    let id: UUID = UUID()
    let title: String
    let date: String
    let content: String
    let tickers: String
    let image: String
    let link: String
    let author: String
    let site: String

    enum CodingKeys: String, CodingKey {
        case title, date, content, tickers, image, link, author, site
    }
}
