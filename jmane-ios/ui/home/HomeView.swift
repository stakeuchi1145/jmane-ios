//
//  HomeView.swift
//  jmane-ios
//
//  Created by Shin Takeuchi on 2026/02/17.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    ZStack {
                        Text("Home")
                            .font(.system(size: 28))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(4)
                    }

                    Divider()
                        .frame(height: 2)
                        .background(.gray.opacity(0.4))
                }
                .frame(maxWidth: .infinity)
                .background(.red)

                VStack {
                    Text("test")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }
}

#Preview {
    HomeView()
}
