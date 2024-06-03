//
//  MainView.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 12/3/24.
//

import SwiftUI
import SwiftData

struct ListItem: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let value: Int
}

struct MainView: View {
    let items: [ListItem] = [
        ListItem(imageName: "link_img", title: "Rrrtwrww", value: 93),
        ListItem(imageName: "link_img", title: "Item 2", value: 100),
        // Add more list items here
    ]

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \CountdownEvent.date) private var countdowns: [CountdownEvent]

    var body: some View {
        NavigationStack {
            List {
                ForEach(countdowns) { item in
                    let days_left = daysLeft(date: item.date)

                    let event_image: Image = createImage(item.image)

                    HStack {
                        NavigationLink(destination: DetailedView(countdown: item)) {
                            event_image
                                .resizable()
                                .frame(width: 128, height: 128)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            VStack(alignment: .leading) {
                                Text(item.title)
                                    .font(.title)
                                    .minimumScaleFactor(0.01)
                                    .lineLimit(2)
                                Text("\(days_left < 0 ? 0 : days_left)")
                                    .font(.system(size: 50))
                                    .padding(.vertical, 0.5)
                                if days_left == 1 {
                                    Text("Days Left")
                                }
                                else {
                                    Text("Day Left")
                                }
                            }
                            .padding(.horizontal, 8)
                        }
                    }
                    .padding(.vertical, 10)
                }
                .onDelete(perform: removeEvent)
            }
            .navigationTitle("Events")
            .navigationBarItems(
                leading: NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gear")
                },
                trailing: NavigationLink(destination: AddItemView(countdown: nil)) {
                    Text("Add")
                })
        }
    }

    private func removeEvent(at indexSet: IndexSet) {
        for index in indexSet {
            let event = countdowns[index]

            modelContext.delete(event)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}


#Preview {
    MainView()
}
