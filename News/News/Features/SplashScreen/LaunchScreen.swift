//
//  LaunchScreen.swift
//  News
//
//  Created by Dhruv Upadhyay on 16/10/24.
//

import SwiftUI

struct LaunchScreen: View {
    var body: some View {
        ZStack {
            Color.white // Background color
                .ignoresSafeArea()
            VStack {
                Image(Images.logo) // Replace with your logo image
                    .resizable()
                    .scaledToFit()
                    .frame(width: Sizes.s150, height: Sizes.s150) // Adjust size as needed
                    .padding(.bottom, Sizes.s20)
                
            }
        }
    }
}
