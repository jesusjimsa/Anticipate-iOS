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
    var countdown: CountdownEvent?

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var deleteItemAlertDetails = DeleteItemAlertDetails()
    @State private var isDeleting = false
    @FocusState private var isEditorFocused: Bool

    var body: some View {
        if let countdown {
            ScrollView {
                VStack {
                    Spacer(minLength: 30)
                    createImage(countdown.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                        .clipped()
                    
                    VStack {
                        let daysLeft: Int = daysLeft(date: countdown.date)
                        
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
                        
                        Text(countdown.date, style: .date)
                            .padding(.top)
                            .padding(.bottom)
                    }
                    .offset(y: -30)
                    
                    HStack {
                        NavigationLink(destination: AddItemView(countdown: countdown), label: {
                            Text("Edit Event")
                                .frame(maxWidth: .infinity)
                        })
                        .buttonStyle(.bordered)
                        .padding(.leading)
                        
                        Button { isDeleting = true } label: {
                            Text("Delete Event")
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .padding(.trailing)
                    }
                    .offset(y: -30)
                    
                    // Notes
                    NotesEditor(countdown: countdown, isEditorFocused: $isEditorFocused)
                        .padding(.bottom)
                        .padding(.bottom)
                }
                .navigationTitle(countdown.title)
                .alert(
                    deleteItemAlertDetails.title,
                    isPresented: $isDeleting,
                    presenting: deleteItemAlertDetails
                ) { titleAlertDetails in
                    Button("Yes", role: .destructive) {
                        delete(countdown)
                    }
                    Button("Cancel", role: .cancel) {
                        isDeleting = false
                    }
                } message: { deleteItemAlertDetails in
                    Text(deleteItemAlertDetails.message)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture { isEditorFocused = false }
            .scrollDismissesKeyboard(.interactively)
        }
    }

    private func delete(_ event: CountdownEvent) {
        removeNotification(event_id: event.id.uuidString)
        modelContext.delete(event)
        dismiss()
    }
}

struct NotesEditor: View {
    @Bindable var countdown: CountdownEvent
    var isEditorFocused: FocusState<Bool>.Binding

    var body: some View {
        VStack {
            Text("Notes")
                .font(.title)

            TextEditor(text: $countdown.notes)
                .frame(height: 100)
                .frame(maxWidth: .infinity)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(.secondary.opacity(0.4)))
                .focused(isEditorFocused)
            
        }
    }
}

#Preview {
    DetailedView()
}
