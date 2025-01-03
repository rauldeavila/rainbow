import SwiftUI

@main
struct rainbowApp: App {
    @StateObject private var menuBarController = MenuBarController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    menuBarController.setupMenuBarIcon()
                }
        }
    }
}
