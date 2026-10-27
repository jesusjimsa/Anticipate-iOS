//
//  MainView.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 12/3/24.
//

import SwiftUI
import SwiftData
import UserNotifications

struct ListItem: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let value: Int
}

struct MainView: View {
    init() {
        registerForNotifications()
    }

    func registerForNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if let error {
                print(error.localizedDescription)
            }
        }
    }

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \CountdownEvent.date) private var countdowns: [CountdownEvent]
    @State private var selectedCountdownID: UUID?

    var body: some View {
        NavigationStack {
                if countdowns.isEmpty {
                    VStack {
                        Spacer()
                        Spacer()
                        Text("Add a new item by tapping the 'Add' button in the corner.")
                            .font(.title3)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 32)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                        Spacer()
                    }
                }

                List {
                    ForEach(countdowns) { item in
                        let days_left = daysLeft(date: item.date)
                        let event_image: Image = createImage(item.image)

                        HStack {
                            NavigationLink(destination: DetailedView(countdown: item)) {
                                event_image
                                    .resizable()
                                    .scaledToFill()
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
                                    Text(days_left == 1 ? "Day Left" : "Days Left")
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
            .navigationDestination(item: $selectedCountdownID) { countdownID in
                if let countdown = countdowns.first(where: { $0.id == countdownID }) {
                    DetailedView(countdown: countdown)
                }
            }
        }
        .onOpenURL(perform: openCountdownURL)
    }

    private func openCountdownURL(_ url: URL) {
        guard url.scheme == "anticipate",
              url.host == "countdown",
              let countdownID = UUID(uuidString: url.pathComponents.dropFirst().first ?? ""),
              countdowns.contains(where: { $0.id == countdownID }) else {
            return
        }

        selectedCountdownID = countdownID
    }

    private func removeEvent(at indexSet: IndexSet) {
        for index in indexSet {
            let event = countdowns[index]

            removeNotification(event_id: event.id.uuidString)
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
