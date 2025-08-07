//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Элина Борисова on 07.08.2025.
//

import SwiftUI

@main
struct BookwormApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Book.self)
    }
}
