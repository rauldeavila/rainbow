import SwiftUI

@main
struct rainbowApp: App {
    @AppStorage("showMenuBarIcon") private var showMenuBarIcon = true
    @AppStorage("showDockIcon") private var showDockIcon = true
    @StateObject private var menuBarController = MenuBarController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(menuBarController)
        }
        .commands {
            CommandGroup(after: .windowArrangement) {
                Divider()
                Toggle("Show Dock Icon", isOn: Binding(
                    get: { showDockIcon },
                    set: { newValue in
                        if newValue || showMenuBarIcon {
                            showDockIcon = newValue
                            if newValue {
                                NSApp.setActivationPolicy(.regular)
                            } else {
                                NSApp.setActivationPolicy(.accessory)
                            }
                        }
                    }
                ))
                .keyboardShortcut("d", modifiers: [.command, .shift])
                
                Toggle("Show Menu Bar Icon", isOn: Binding(
                    get: { showMenuBarIcon },
                    set: { newValue in
                        if newValue || showDockIcon {
                            showMenuBarIcon = newValue
                        }
                    }
                ))
                .keyboardShortcut("m", modifiers: [.command, .shift])
            }
        }
    }
}

class MenuBarController: NSObject, ObservableObject {
    private var statusItem: NSStatusItem?
    @AppStorage("showMenuBarIcon") private var showMenuBarIcon = true
    @AppStorage("showDockIcon") private var showDockIcon = true
    private var contextMenu: NSMenu?
    
    override init() {
        super.init()
        DispatchQueue.main.async {
            self.setupMenuBarIcon()
        }
    }
    
    func setupMenuBarIcon() {
        if showMenuBarIcon {
            statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
            if let button = statusItem?.button {
                button.image = NSImage(systemSymbolName: "paintpalette", accessibilityDescription: "Rainbow")
                button.action = #selector(handleClick)
                button.target = self
                button.sendAction(on: [.leftMouseUp, .rightMouseUp])
            }
            
            setupContextMenu()
        } else {
            statusItem = nil
        }
    }
    
    private func setupContextMenu() {
        contextMenu = NSMenu()
        
        let menuBarOnlyItem = NSMenuItem(title: "Menu Bar Icon Only", action: #selector(showMenuBarIconOnly), keyEquivalent: "")
        menuBarOnlyItem.target = self
        contextMenu?.addItem(menuBarOnlyItem)
        
        let dockOnlyItem = NSMenuItem(title: "Dock Icon Only", action: #selector(showDockIconOnly), keyEquivalent: "")
        dockOnlyItem.target = self
        contextMenu?.addItem(dockOnlyItem)
        
        let bothIconsItem = NSMenuItem(title: "Show Both Icons", action: #selector(showBothIcons), keyEquivalent: "")
        bothIconsItem.target = self
        contextMenu?.addItem(bothIconsItem)
        
        contextMenu?.addItem(NSMenuItem.separator())
        
        let quitItem = NSMenuItem(title: "Quit Rainbow", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.keyEquivalentModifierMask = .command
        quitItem.target = self
        contextMenu?.addItem(quitItem)
    }
    
    @objc private func handleClick(_ sender: NSStatusBarButton) {
        if let event = NSApp.currentEvent {
            switch event.type {
            case .rightMouseUp:
                statusItem?.menu = contextMenu
                statusItem?.button?.performClick(nil)
                // Reset menu after use to ensure left-click works next time
                DispatchQueue.main.async {
                    self.statusItem?.menu = nil
                }
            case .leftMouseUp:
                toggleAppVisibility()
            default:
                break
            }
        }
    }
    
    private func toggleAppVisibility() {
        if NSApp.isHidden {
            NSApp.unhide(nil)
            NSApp.activate(ignoringOtherApps: true)
        } else {
            NSApp.hide(nil)
        }
    }
    
    @objc private func showMenuBarIconOnly() {
        showMenuBarIcon = true
        showDockIcon = false
        NSApp.setActivationPolicy(.accessory)
    }
    
    @objc private func showDockIconOnly() {
        showMenuBarIcon = false
        showDockIcon = true
        NSApp.setActivationPolicy(.regular)
        setupMenuBarIcon()
    }
    
    @objc private func showBothIcons() {
        showMenuBarIcon = true
        showDockIcon = true
        NSApp.setActivationPolicy(.regular)
        setupMenuBarIcon()
    }
    
    @objc private func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}
