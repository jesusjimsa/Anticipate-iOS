//
//  ContentView.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 7/5/24.
//

import SwiftUI
import SwiftData

//struct MainView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query private var items: [Item]
//
//    var body: some View {
//        NavigationSplitView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
//                    } label: {
//                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//        } detail: {
//            Text("Select an item")
//        }
//    }
//
//    private func addItem() {
//        withAnimation {
//            let newItem = Item(timestamp: Date())
//            modelContext.insert(newItem)
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(items[index])
//            }
//        }
//    }
//}

struct ListItem: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let value: Int
}

struct MainView: View {
    let items = [
        ListItem(imageName: "link_img", title: "Rrrtwrww", value: 93),
        ListItem(imageName: "link_img", title: "Item 2", value: 100),
        // Add more list items here
    ]

    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    HStack {
                        Image(item.imageName)
                            .resizable()
                            .frame(width: 128, height: 128)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.title)
                            Text("\(item.value)")
                                .font(.system(size: 50))
                                .padding(.vertical, 0.5)
                            Text("Days Left")
                        }
                        .padding(.horizontal, 8)
                    }
                    .padding(.vertical, 10)
                }
            }
            .navigationTitle("Events")
            .navigationBarItems(
                leading: NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gear")
                },
                trailing: NavigationLink(destination: AddItemView()) {
                    Text("Add")
                })
        }
    }
}

#Preview {
    MainView()
        .modelContainer(for: EventsList.self, inMemory: true)
}
