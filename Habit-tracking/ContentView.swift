//
//  ContentView.swift
//  Habit-tracking
//
//  Created by Mario Alberto Barragán Espinosa on 12/11/19.
//  Copyright © 2019 Mario Alberto Barragán Espinosa. All rights reserved.
//

import SwiftUI

struct ActivityItem: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String
}

class Activities: ObservableObject {
    @Published var items: [ActivityItem] {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let items = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ActivityItem].self, from: items) {
                self.items = decoded
                return
            }
        }

        self.items = []
    }
}

struct ContentView: View {
    
    @ObservedObject var activities = Activities()
    @State private var showingAddActivity = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(activities.items) { item in
                     HStack {
                           VStack(alignment: .leading) {
                               Text(item.title)
                                   .font(.headline)
                               Text(item.description)
                           }
                           Spacer()
                       }
                }
                .onDelete(perform: removeItems)
            }
            .navigationBarTitle("Habit Tracking")
            .navigationBarItems(leading: EditButton(), trailing:
                Button(action: {
                    self.showingAddActivity = true
                }) {
                    Image(systemName: "plus")
                }
            )
        }
        .sheet(isPresented: $showingAddActivity) {
            AddActivity(activities: self.activities)
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        activities.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
