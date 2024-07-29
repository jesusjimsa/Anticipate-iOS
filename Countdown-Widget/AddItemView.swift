//
//  AddItemView.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 12/3/24.
//

import SwiftUI
import PhotosUI

struct ImageAlertDetails {
    let title = "Alert"
    let message = "You have not added an image"
}

struct TitleAlertDetails {
    let title = "Alert"
    let message = "You have not added a title"
}

struct AddItemView: View {
    let countdown: CountdownEvent?

    @State private var event_name: String = ""
    @State private var date = Date()
    @State private var eventPPicker: PhotosPickerItem?
    @State private var eventImage: Image?
    @State private var eventImageData: Data?
    @State private var event_id: UUID?

    @State private var showImageAlert = false
    @State private var showTitleAlert = false
    @State private var imageAlertDetails = ImageAlertDetails()
    @State private var titleAlertDetails = TitleAlertDetails()

    @State private var isEditing: Bool = false

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Add a title to your event")
                    .font(.title3)
                    .padding(.leading)

                HStack {
                    Spacer(minLength: 10)
                    TextField("Add a title to your countdown", text: $event_name)
                        .border(.tertiary)
                        .textFieldStyle(.roundedBorder)
                        .onTapGesture {
                            self.isEditing = true
                        }
                    Spacer(minLength: 10)
                }

                Text("Select the date")
                    .font(.title3)
                    .padding(.top)
                    .padding(.leading)
                DatePicker(
                        "Start Date",
                        selection: $date,
                        in: Date.now...,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.graphical)
                    .onTapGesture(count: 99, perform: {
                        // Override iOS bug
                    })


            }
            .navigationTitle("New Event")
            .navigationBarItems(
                trailing: Button(action: {
                    showTitleAlert = event_name.isEmpty
                    showImageAlert = eventImage == nil

                    if !showImageAlert && !showTitleAlert {
                        save()
                        dismiss()
                    }
                }) {
                    // Image(systemName: "plus")
                    Text("Save")
                })
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                self.isEditing = false
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                self.isEditing = true
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                self.isEditing = false
            }
            .alert(
                imageAlertDetails.title,
                isPresented: $showImageAlert,
                presenting: imageAlertDetails
            ) { imageAlertDetails in
                Button("OK") {
                    // Nothing
                }
            } message: { imageAlertDetails in
                Text(imageAlertDetails.message)
            }
            .alert(
                titleAlertDetails.title,
                isPresented: $showTitleAlert,
                presenting: titleAlertDetails
            ) { titleAlertDetails in
                Button("OK") {
                    // Nothing
                }
            } message: { titleAlertDetails in
                Text(titleAlertDetails.message)
            }

            HStack(spacing: 15) {
                // Fixed size image container on the left
                ZStack(alignment: .topLeading) {
                    if let eventImage {
                        eventImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 128, height: 128)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    } else {
                        Text("No Image Selected")
                            .foregroundColor(.gray)
                            .frame(width: 128, height: 128)
                            .opacity(0.5)
                    }
                }

                // PhotosPicker Button on the right with fixed width
                PhotosPicker("Select an image", selection: $eventPPicker, matching: .images)
                    .buttonStyle(.bordered)
            }
            .onChange(of: eventPPicker) {
                        Task {
                            if let loaded = try? await eventPPicker?.loadTransferable(type: Image.self) {
                                eventImage = loaded
                                ImgToData()
                            } else {
                                print("Failed")
                            }
                        }
                    }
        }
        .onAppear {
            if let countdown = countdown {
                event_name = countdown.title
                date = countdown.date
                eventImage = createImage(countdown.image)
            }
        }
    }

    private func save() {
        if let countdown {
            countdown.title = event_name
            countdown.date = date
            if let eventImageData {
                countdown.image = eventImageData
            }
        }
        else {
            let newCountdown = CountdownEvent(id: UUID(), title: event_name, date: date, image: eventImageData!)
            modelContext.insert(newCountdown)
        }
    }

    private func ImgToData() {
        Task { @MainActor in
            if let imageData = try await eventPPicker?.loadTransferable(type: Data.self) {
                eventImageData = imageData
            }
            else {
                // Handle error (e.g., print message, show alert)
                print("Error loading image data")
            }
        }
    }
}

#Preview {
    AddItemView(countdown: nil)
}
