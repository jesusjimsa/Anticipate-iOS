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
                    .frame(height: 350)

                VStack {
                    Text("57")
                        .font(.system(size: 100))
                        .padding(.top)
                    Text("Days Left")
                        .padding(.bottom)
                }

                VStack {
                    Button(action: {}, label: {
                        Text("Edit Event")
                            .frame(maxWidth: .infinity)
                    })
                    .buttonStyle(.bordered)
                    .padding(.horizontal)

                    Button(action: {}, label: {
                        Text("Delete Event")
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity)
                    })
                    .buttonStyle(.bordered)
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Event title (to be changed)")
        }
    }
}

#Preview {
    DetailedView()
}
