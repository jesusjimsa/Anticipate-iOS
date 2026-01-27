//
//  AddItemView.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 12/3/24.
//

import SwiftUI
import PhotosUI
import UserNotifications
import WidgetKit

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
    @State private var showGallery = false

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            ScrollView {
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
                        // https://stackoverflow.com/questions/77373659/swiftui-datepicker-issue-ios-17-1
                    })


                }
                .navigationTitle("New Event")
                .navigationBarItems(
                    trailing: Button(action: {
                        showTitleAlert = event_name.isEmpty
                        showImageAlert = eventImage == nil

                        if !showImageAlert && !showTitleAlert {
                            save()
                            schedule_notification()
                            dismiss()
                        }
                    }) {
                        // Image(systemName: "plus")
                        Text("Save")
                    })
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil,
                                                    for: nil)
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

                    VStack(alignment: .leading, spacing: 10) {
                        // PhotosPicker Button
                        PhotosPicker("Select an image", selection: $eventPPicker, matching: .images)
                            .buttonStyle(.bordered)
                        
                        // Gallery Button
                        Button(action: {
                            showGallery = true
                        }) {
                            Text("Choose from gallery")
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .onChange(of: eventPPicker) {
                    Task {
                        if let imageData = try? await eventPPicker?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: imageData) {
                            let fixedImage = uiImage.fixedOrientation()
                            eventImage = Image(uiImage: fixedImage)
                            
                            // Then process for storage
                            ImgToData()
                        } else {
                            print("Failed")
                        }
                    }
                }
                .sheet(isPresented: $showGallery) {
                    ImageGalleryView(selectedImage: $eventImage, selectedImageData: $eventImageData)
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
        .ignoresSafeArea(.keyboard)
    }

    private func save() {
        if let countdown {
            countdown.title = event_name
            countdown.date = date
            if let eventImageData {
                countdown.image = eventImageData
            }
            event_id = countdown.id
        }
        else {
            event_id = UUID()
            let newCountdown = CountdownEvent(id: event_id!, title: event_name, date: date, image: eventImageData!)
            modelContext.insert(newCountdown)
        }
        
        // Apparently, just one call won't update the widget for some reason
        WidgetCenter.shared.reloadAllTimelines()
        WidgetCenter.shared.reloadAllTimelines()
        WidgetCenter.shared.reloadAllTimelines()
    }

    private func schedule_notification() {
        let center = UNUserNotificationCenter.current()
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: date)

        // Send notifications at 9:00 the day of the event
        dateComponents.hour = 9
        dateComponents.minute = 0
        dateComponents.second = 0

        // Attempt removing notification in case we are editing an event
        center.removePendingNotificationRequests(withIdentifiers: [event_id!.uuidString])

        let content = UNMutableNotificationContent()
        // This trigger is for testing
        // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        content.title = event_name + " is today"
        content.sound = UNNotificationSound.default
        
        if (eventImageData == nil && countdown != nil) {
            eventImageData = countdown?.image
        }

        // Attach event image
        if let imageData = eventImageData {
            let tempDirectory = FileManager.default.temporaryDirectory
            let imageURL = tempDirectory.appendingPathComponent("event_image.jpg")

            do {
                // Write the image data to a temporary file
                try imageData.write(to: imageURL)

                // Create the notification attachment
                let attachment = try UNNotificationAttachment(identifier: "event_image", url: imageURL,
                                                              options: nil)
                content.attachments = [attachment]
            } catch {
                print("Failed to add image attachment: \(error)")
            }
        }

        let request = UNNotificationRequest(identifier: event_id!.uuidString, content: content, trigger: trigger)
        let scheduledDate = date    // Capture the date value before the closure to avoid warning

        center.add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            } else {
                print("Notification rescheduled successfully for \(scheduledDate)")
            }
        }
    }

    private func ImgToData() {
        Task { @MainActor in
            if let imageData = try await eventPPicker?.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: imageData) {

                // Normalize orientation BEFORE resizing
                let normalizedImage = uiImage.fixedOrientation()
                
                // Resize image for widget use (max 400px width/height)
                let resizedImage = normalizedImage.resizedForWidget(maxWidth: 400)

                // Compress to JPEG with 0.7 quality
                if let compressedData = resizedImage.jpegData(compressionQuality: 0.7) {
                    eventImageData = compressedData
                    print("Original size: \(imageData.count) bytes, Optimized size: \(compressedData.count) bytes")
                }
                else {
                    print("Failed to compress image")
                    eventImageData = imageData // Fallback to original
                }
            } else {
                print("Error loading image data")
            }
        }
    }
}

extension UIImage {
    func resizedForWidget(maxWidth: CGFloat = 400) -> UIImage {
        // If image is already small enough, return as-is
        if size.width <= maxWidth && size.height <= maxWidth {
            return self
        }
        
        let scale = min(maxWidth / size.width, maxWidth / size.height)
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        
        // Use UIGraphicsImageRenderer for better performance and memory management
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
    
    // Alternative method with more aggressive compression for widgets
    func optimizedForWidget() -> UIImage {
        // Resize to maximum 300px for widgets (more conservative)
        let resized = resizedForWidget(maxWidth: 300)
        
        // Convert to JPEG and back to reduce file size
        guard let jpegData = resized.jpegData(compressionQuality: 0.8),
              let compressedImage = UIImage(data: jpegData) else {
            return resized
        }
        
        return compressedImage
    }
    
    func fixedOrientation() -> UIImage {
        // If image is already in correct orientation, return as-is
        if imageOrientation == .up {
            return self
        }
        
        // Render the image in correct orientation
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return normalizedImage ?? self
    }
}

#Preview {
    AddItemView(countdown: nil)
}
