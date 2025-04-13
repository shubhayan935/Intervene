//
//  InterveneApp.swift
//  Intervene
//
//  Created by Shubhayan Srivastava on 4/12/25.
//

import SwiftUI

@main
struct InterveneApp: App {
    let persistenceController = PersistenceController.shared

    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        // Menu bar–only app, we don't need to show any windows on launch
        Settings {
            EmptyView()
        }
    }
}
