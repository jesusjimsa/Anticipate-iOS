//
//  DetailedView.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 14/3/24.
//

import SwiftUI
import SwiftData

struct DeleteItemAlertDetails {
    let title = "Are you sure?"
    let message = "Are you sure you want to delete this event?"
}

struct DetailedView: View {
//    var eventIndex: Int?

    var countdown: CountdownEvent?

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var deleteItemAlertDetails = DeleteItemAlertDetails()

    @State private var isDeleting = false

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
//                    Button(action: {}, label: {
//                        Text("Edit Event")
//                            .frame(maxWidth: .infinity)
//                    })
                    NavigationLink(destination: AddItemView(countdown: countdown), label: {
                        Text("Edit Event")
                            .frame(maxWidth: .infinity)
                    })
                    .buttonStyle(.bordered)
                    .padding(.horizontal)

                    Button { isDeleting = true } label: {
                        Text("Delete Event")
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .padding(.horizontal)
                }
                .alert(
                    deleteItemAlertDetails.title,
                    isPresented: $isDeleting,
                    presenting: deleteItemAlertDetails
                ) { titleAlertDetails in
                    Button("Yes", role: .destructive) {
                        delete(countdown!)
                    }
                    Button("Cancel", role: .cancel) {
                        isDeleting = false
                    }
                } message: { deleteItemAlertDetails in
                    Text(deleteItemAlertDetails.message)
                }
            }
            .navigationTitle("\(countdown!.title)")
        }
    }

    private func delete(_ event: CountdownEvent) {
        modelContext.delete(event)
        dismiss()
    }
}

#Preview {
    DetailedView()
}
