//
//  IconsListView.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 2/4/24.
//

import SwiftUI

struct IconsListView: View {
    var body: some View {
        NavigationStack {
            List {
                HStack {
                    Image("first_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 128, height: 128)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    Text("First prototype")
                }
            }
            .navigationTitle("Icons")
        }
    }
}

#Preview {
    IconsListView()
}
