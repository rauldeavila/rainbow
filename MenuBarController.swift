import Cocoa

class MenuBarController: NSObject {
    private var statusItem: NSStatusItem?
    private var menu: NSMenu?
    
    override init() {
        super.init()
        setupMenuBarIcon()
    }
    
    func setupMenuBarIcon() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem?.button {
            button.image = NSImage(named: "menuBarIcon")
            button.action = #selector(menuBarIconClicked)
            button.target = self
        }
        
        menu = NSMenu()
        menu?.addItem(NSMenuItem(title: "Show Dock Icon", action: #selector(showDockIcon), keyEquivalent: ""))
        menu?.addItem(NSMenuItem(title: "Hide Dock Icon", action: #selector(hideDockIcon), keyEquivalent: ""))
        menu?.addItem(NSMenuItem(title: "Show Both Icons", action: #selector(showBothIcons), keyEquivalent: ""))
        menu?.addItem(NSMenuItem.separator())
        menu?.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q"))
    }
    
    @objc private func menuBarIconClicked() {
        statusItem?.menu = menu
        statusItem?.button?.performClick(nil)
    }
    
    @objc private func showDockIcon() {
        updateUserPreferences(showMenuBarIcon: false, showDockIcon: true)
    }
    
    @objc private func hideDockIcon() {
        updateUserPreferences(showMenuBarIcon: true, showDockIcon: false)
    }
    
    @objc private func showBothIcons() {
        updateUserPreferences(showMenuBarIcon: true, showDockIcon: true)
    }
    
    @objc private func quitApp() {
        NSApplication.shared.terminate(nil)
    }
    
    private func updateUserPreferences(showMenuBarIcon: Bool, showDockIcon: Bool) {
        UserDefaults.standard.set(showMenuBarIcon, forKey: "showMenuBarIcon")
        UserDefaults.standard.set(showDockIcon, forKey: "showDockIcon")
        
        if showMenuBarIcon {
            setupMenuBarIcon()
        } else {
            statusItem = nil
        }
        
        if showDockIcon {
            NSApp.setActivationPolicy(.regular)
        } else {
            NSApp.setActivationPolicy(.accessory)
        }
    }
}
