//
//  NewsRow.swift
//  News
//
//  Created by Dhruv Upadhyay on 14/10/24.
//

import SwiftUI

struct NewsRow: View {
    let item: MappedArticle
    
    var body: some View {
        VStack(alignment: .leading) {
            // Display the news item's image if available
            if let imageUrl = item.imageUrl {
                AsyncImage(url: imageUrl) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width - Sizes.s36, height: Sizes.s200)
                        .clipped()
                } placeholder: {
                    ZStack {
                        Image(Images.newsDefaultPlaceholder)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: Sizes.s200)
                            .clipped()
                        ProgressView()
                    }
                }
            }
            
            // Display the news item's title and description
            VStack(alignment: .leading, spacing: Sizes.s8) {
                Text(item.title)
                    .font(.headline)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                Text(item.description ?? "")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                
                // New rows for Date, Time Ago, and Author Name
                HStack(alignment: .center, spacing: Sizes.s2) {
                    Text(Titles.date).bold().font(.caption)
                        .foregroundColor(.gray) + Text(" \(formatDateToDDMMYYYY(dateString: item.publishedAt) ?? "")")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Spacer()
                    Text(Titles.posted).bold().font(.caption)
                        .foregroundColor(.gray) + Text(" \(timeAgo(from: item.publishedAt) ?? "") \(Titles.ago)")
                            .font(.caption)
                            .foregroundColor(.gray)
                }
                
                // "Read More" link at the bottom right
                HStack {
                    Spacer()
                    Text(Titles.readMore)
                        .font(.caption)
                        .foregroundColor(.blue)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding()
            
        }
        .frame(width: UIScreen.main.bounds.width - Sizes.s36)
    }
}
