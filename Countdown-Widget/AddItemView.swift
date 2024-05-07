//
//  AddItemView.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 7/5/24.
//

import SwiftUI
import PhotosUI
import SwiftData

func generateRandomID() -> String {
    let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let length = 6
    var randomString = ""

    for _ in 0..<length {
        let randomIndex = Int.random(in: 0..<characters.count)
        let character = characters[characters.index(characters.startIndex, offsetBy: randomIndex)]

        randomString.append(character)
    }

    return randomString
}

func isIDAlreadyPresent(id: String) -> Bool {
//    let fetchRequest: NSFetchRequest<UserCountdowns> = UserCountdowns.fetchRequest()
//    fetchRequest.predicate = NSPredicate(format: "id == %@", id)
//    fetchRequest.fetchLimit = 1 // Optimize performance by limiting the fetch to 1 result
//
//    do {
//        let count = try context.count(for: fetchRequest)
//        return count > 0
//    } catch {
//        print("Error checking ID existence: \(error)")
//        return false
//    }

    return false
}

struct AddItemView: View {
    @State private var event_name: String = ""
    @State private var date = Date()
    @State private var eventPPicker: PhotosPickerItem?
    @State private var eventImage: Image?

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


            }
            .navigationTitle("New Event")
            .navigationBarItems(
//                leading: Button(action: {
//                                    // Add your button action here
//                                }) {
//                                    Text("Cancel")
//                                },
                trailing: Button(action: {
                            // Add your button action here
                        }) {
                            // Image(systemName: "plus")
                            Text("Save")
                        })

            HStack(spacing: 15) {
                // Fixed size image container on the left
                ZStack(alignment: .topLeading) {
                    if let eventImage = eventImage {
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
                            } else {
                                print("Failed")
                            }
                        }
                    }
        }
    }
}

#Preview {
    AddItemView()
}

