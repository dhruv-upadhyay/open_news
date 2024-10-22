//
//  NewsDetailView.swift
//  News
//
//  Created by Dhruv Upadhyay on 14/10/24.
//

import SwiftUI

struct NewsDetailView: View {
    var article: MappedArticle
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    @State private var reload: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Sizes.s16) {
                
                if let imageUrl = article.imageUrl {
                    AsyncImage(url: imageUrl) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width, height: Sizes.s250)
                            .clipped()
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(Sizes.s0p3))
                            .frame(width: UIScreen.main.bounds.width, height: Sizes.s250)
                    }
                }
                Text(article.title)
                    .font(.title)
                    .padding(.horizontal)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(Titles.date).bold().font(.caption)
                            .foregroundColor(.gray) + Text(" \(formatDateToDDMMYYYY(dateString: article.publishedAt) ?? "")")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(Titles.posted).bold().font(.caption)
                            .foregroundColor(.gray) + Text(" \(timeAgo(from: article.publishedAt) ?? "") \(Titles.ago)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Button {
                        if BookmarkManager.shared.isBookmarked(article: article) {
                            BookmarkManager.shared.removeBookmark(bookmark: article)
                        } else {
                            BookmarkManager.shared.addBookmark(article: article)
                        }
                        reload.toggle()
                    } label: {
                        if reload || !reload {
                            Image(systemName: BookmarkManager.shared.isBookmarked(article: article) ? Images.bookmarkFill : Images.bookmark)
                        }
                    }
                    .padding([.leading])
                }.frame(width: UIScreen.main.bounds.width - Sizes.s40)
                    .padding()
                
                if let description = article.description {
                    Text(description)
                        .font(.body)
                        .padding(.horizontal)
                }
                Spacer()
                Button(action: {
                    UIApplication.shared.open(article.link)
                }) {
                    Text(Titles.readFullArticle)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(Sizes.s10)
                        .shadow(color: Color.black.opacity(Sizes.s0p2), radius: Sizes.s5, x: Sizes.zero, y: Sizes.s3)
                        .padding(.horizontal)
                        .scaleEffect(Sizes.s1)
                        .animation(.easeInOut(duration: Sizes.s0p2), value: true)
                }
                .buttonStyle(PlainButtonStyle())
                Spacer()
            }
            .navigationTitle(Titles.newsDetails)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
        }
    }

    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: Images.back)
            }
        }
        .buttonStyle(PlainButtonStyle())

    }
}
