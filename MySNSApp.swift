//
//  MySNSApp.swift
//  MySNS
//
//  Created by 日下拓海 on 2024/09/05.
//

import SwiftUI
import SwiftData

@main
struct MySNSApp: App {
    //  init() {
    //     // UserDefaultsのデータをクリア
    //     UserDefaults.standard.removeObject(forKey: "savedUsers")
    //     UserDefaults.standard.removeObject(forKey: "currentUser")
    // }
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView(user: User(username: "", university: "", posts: [], followers: [], following: [], accountname: "", faculty: "", department: "", club: "", bio: "", twitterHandle: "", email: "", stories: []))
        }
        .modelContainer(sharedModelContainer)
    }
}