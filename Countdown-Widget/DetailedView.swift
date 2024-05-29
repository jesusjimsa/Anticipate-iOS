//
//  DetailedView.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 14/3/24.
//

import SwiftUI
import SwiftData

struct DetailedView: View {
//    var eventIndex: Int?

    var countdown: CountdownEvent?

    var body: some View {
        NavigationStack {
            VStack {
                createImage(countdown!.image)
                    .resizable()
//                    .scaledToFill()
                    .aspectRatio(contentMode: .fit)
//                    .frame(height: 300)
                    .clipped()
                    .frame(width: UIScreen.main.bounds.width, height: 300)

                VStack {
                    let daysLeft: Int = daysLeft(date: countdown!.date)

                    Text("\(daysLeft < 0 ? 0 : daysLeft)")
                        .font(.system(size: 100))
                        .padding(.top)
                        .padding(.top)

                    if daysLeft == 1 {
                        Text("Day Left")
                            .padding(.bottom)
                    }
                    else {
                        Text("Days Left")
                            .padding(.bottom)
                    }
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
            .navigationTitle("\(countdown!.title)")
        }
    }
}

#Preview {
    DetailedView()
}
