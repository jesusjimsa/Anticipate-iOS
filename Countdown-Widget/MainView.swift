//
//  MainView.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 12/3/24.
//

import SwiftUI

struct ListItem: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let value: Int
}

struct ContentView: View {
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
                                .font(.largeTitle)
                                .padding(.vertical, 5)
                            Text("Days Left")
                        }
                    }
                    .padding(.vertical, 10)
                }
            }
            .navigationTitle("Events")
            .navigationBarItems(
                leading: Button(action: {
                                    // Add your button action here
                                }) {
                                    Image(systemName: "gear")
                                },
                trailing: Button(action: {
                            // Add your button action here
                        }) {
                            // Image(systemName: "plus")
                            Text("Add")
                        })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


#Preview {
    ContentView()
}
