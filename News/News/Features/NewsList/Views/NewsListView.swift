//
//  NewsListView.swift
//  News
//
//  Created by Dhruv Upadhyay on 14/10/24.
//

import SwiftUI

struct NewsListView: View {
    @StateObject private var viewModel = NewsViewModel()
    @State private var selectedArticle: MappedArticle?
    @State private var title: String = Titles.topHeadlines
    @State private var reload: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .leading, spacing: Sizes.s2) {
                    HStack {
                        Spacer()
                        Text(title).font(.headline)
                        Spacer()
                    }
                    .padding([.leading, .trailing, .bottom], Sizes.s16)
                    
                    Divider()
                    
                    HStack {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: Sizes.s16) {
                                ForEach(viewModel.options) { option in
                                    VStack {
                                        Text(option.title)
                                            .font(.caption)
                                            .padding(Sizes.s8)
                                            .background(
                                                viewModel.selectedOption?.id == option.id ? Color.gray.opacity(Sizes.s0p2) : Color.clear
                                            )
                                            .cornerRadius(Sizes.s8)
                                    }
                                    .onTapGesture {
                                        viewModel.selectedOption = option
                                        title = option.title
                                        viewModel.fetchNews()
                                    }
                                    
                                    Divider()
                                        .frame(height: Sizes.s16)
                                        .background(Color.gray)
                                }
                            }
                            .padding()
                        }
                        
                        Button {
                            title = Titles.bookmark
                            if !viewModel.isBookMarked() {
                                viewModel.fetchBookmarks()
                            }
                        } label: {
                            Image(systemName: viewModel.isBookMarked() ? Images.bookmarkFill : Images.bookmark)
                        }.padding([.trailing])
                    }

                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.articles) { item in
                                ZStack {
                                    NavigationLink(destination: NewsDetailView(article: item)
                                        .navigationBarBackButtonHidden(true)
                                    ) {
                                        NewsRow(item: item)
                                            .background(Color.white)
                                            .cornerRadius(Sizes.s10)
                                            .shadow(radius: Sizes.s5)
                                            .padding([.horizontal])
                                    }
                                    .overlay(alignment: .bottom) {
                                        HStack {
                                            Button {
                                                if BookmarkManager.shared.isBookmarked(article: item) {
                                                    BookmarkManager.shared.removeBookmark(bookmark: item)
                                                } else {
                                                    BookmarkManager.shared.addBookmark(article: item)
                                                }
                                                reload.toggle()
                                            } label: {
                                                if reload || !reload {
                                                    Image(systemName: BookmarkManager.shared.isBookmarked(article: item) ? Images.bookmarkFill : Images.bookmark)
                                                }
                                            }
                                            .padding([.leading])
                                            Spacer()
                                        }.frame(width: UIScreen.main.bounds.width - Sizes.s40)
                                            .padding()
                                    }
                                }.padding([.bottom])
                            }
                        }
                    }
                    .padding([.leading, .trailing], Sizes.s16)
                }
                .background(Color.white)
                
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(Sizes.s2)
                }
                
                
                VStack {
                    Image(Images.noDataFound)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: Sizes.s200)
                        .clipped()
                    
                    Text(viewModel.isBookMarked() ? Titles.noBookMark : Titles.noDataFound)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .padding()
                .opacity(viewModel.getOpecity())
            }
        }
    }
}



