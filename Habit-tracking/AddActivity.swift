//
//  AddActivity.swift
//  Habit-tracking
//
//  Created by Mario Alberto Barragán Espinosa on 12/11/19.
//  Copyright © 2019 Mario Alberto Barragán Espinosa. All rights reserved.
//

import SwiftUI

struct AddActivity: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var description = ""
    
    @State private var showingAlert = false
        
    @ObservedObject var activities: Activities
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Activity title", text: $title)
                TextField("Activity description", text: $description)
            }
            .navigationBarTitle("Add new activity")
            .navigationBarItems(trailing: Button("Save") {
                if !self.title.isEmpty && !self.description.isEmpty {
                    let newActivity = ActivityItem(title: self.title, description: self.description)
                    self.activities.items.append(newActivity)
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    self.showingAlert = true
                }
            })
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Empty parameter"), message: Text("Parameter is empty"), dismissButton: .default(Text("Ok")))
            }
        }
    }
}

struct AddActivity_Previews: PreviewProvider {
    static var previews: some View {
        AddActivity(activities: Activities())
    }
}
