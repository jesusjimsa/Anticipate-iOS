//
//  DetailedView.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 7/5/24.
//

import SwiftUI
import SwiftData

struct DetailedView: View {
    var titleText: String?
    var timeLeftText: String?
    var daysLeftText: String?
    var image: UIImage?
    var eventIndex: Int?
    var eventDate: Date?
    var eventID: String?

    var body: some View {
        NavigationStack {
            VStack {
                if image != nil {
                    Image(uiImage: image!)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 300)
                }
                else {
                    Image("link_img")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 300)
                }

                VStack {
                    let left = daysLeft(date: eventDate ?? Date())

                    Text(left >= 0 ? String(left) : "0")
                        .font(.system(size: 100))
                        .padding(.top)
                        .padding(.top)
                    Text(left > 1 ? "Days Left" : "Day Left")
                        .padding(.bottom)
                }

                VStack {
                    NavigationLink(destination: AddItemView()) {
                        Text("Edit Event")
                            .frame(maxWidth: .infinity)
                    }
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
            .navigationTitle(titleText ?? "Event Name")
        }
    }
}

#Preview {
    DetailedView()
}

