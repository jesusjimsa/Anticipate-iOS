//
//  DetailedView.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 14/3/24.
//

import SwiftUI

struct DetailedView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Image("link_img")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 300)

                VStack {
                    Text("57")
                        .font(.largeTitle)
                        .padding(.top)
                    Text("Days Left")
                }

                VStack {
                    Button(action: {}, label: {
                        Text("Edit Event")
                    })
                    .buttonStyle(.bordered)

                    Button(action: {}, label: {
                        Text("Delete Event")
                            .foregroundStyle(.red)
                    })
                    .buttonStyle(.bordered)
                }
            }
            .navigationTitle("Event title (to be changed)")
        }
    }
}

#Preview {
    DetailedView()
}
