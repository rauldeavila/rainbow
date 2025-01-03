import SwiftUI

struct ColorInfo: Identifiable {
    let id = UUID()
    let color: Color
    let name: String
}

struct MaterialInfo: Identifiable {
    let id = UUID()
    let material: Material
    let name: String
    var position: CGPoint
}

struct ToastView: View {
    let message: String
    let color: Color?
    
    var body: some View {
        Text(message)
            .font(.caption)
            .padding(8)
            .background(Color.black.opacity(0.8))
            .foregroundColor(message.contains("Copied") ? (color ?? .white) : .white)
            .cornerRadius(8)
    }
}

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var selectedColorInfo: ColorInfo?
    
    // Define all system colors with their names
    let colorItems: [ColorInfo] = [
        ColorInfo(color: .blue, name: "Blue"),
        ColorInfo(color: .yellow, name: "Yellow"),
        ColorInfo(color: .purple, name: "Purple"),
        ColorInfo(color: .red, name: "Red"),
        ColorInfo(color: .green, name: "Green"),
        ColorInfo(color: .orange, name: "Orange"),
        ColorInfo(color: .pink, name: "Pink"),
        ColorInfo(color: .gray, name: "Gray"),
        ColorInfo(color: .black, name: "Black"),
        ColorInfo(color: .white, name: "White"),
        ColorInfo(color: .brown, name: "Brown"),
        ColorInfo(color: .cyan, name: "Cyan"),
        ColorInfo(color: .mint, name: "Mint"),
        ColorInfo(color: .indigo, name: "Indigo"),
        ColorInfo(color: .teal, name: "Teal"),
        ColorInfo(color: .primary, name: "Primary"),
        ColorInfo(color: .secondary, name: "Secondary"),
        ColorInfo(color: .accentColor, name: "Accent")
    ]
    
    // Define all available materials with initial positions
    @State private var materialItems: [MaterialInfo] = [
        MaterialInfo(material: .ultraThinMaterial, name: "Ultra Thin Material", position: CGPoint(x: 100, y: 100)),
        MaterialInfo(material: .thinMaterial, name: "Thin Material", position: CGPoint(x: 150, y: 200)),
        MaterialInfo(material: .regularMaterial, name: "Regular Material", position: CGPoint(x: 200, y: 300)),
        MaterialInfo(material: .thickMaterial, name: "Thick Material", position: CGPoint(x: 250, y: 400)),
        MaterialInfo(material: .ultraThickMaterial, name: "Ultra Thick Material", position: CGPoint(x: 300, y: 500))
    ]
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Colors Tab
            VStack(spacing: 0) {
                ColorsGridView(colorItems: colorItems,
                             selectedColorInfo: $selectedColorInfo)
                
                Divider()
                
                ColorDetailPanel(colorInfo: selectedColorInfo)
                    .frame(height: 200)
            }
            .tabItem {
                Label("Colors", systemImage: "paintpalette")
            }
            .tag(0)
            
            // Materials Tab
            MaterialsView(materialItems: $materialItems)
                .tabItem {
                    Label("Materials", systemImage: "circle.grid.cross")
                }
                .tag(1)
        }
    }
}

// Color Grid View
struct ColorsGridView: View {
    let colorItems: [ColorInfo]
    @Binding var selectedColorInfo: ColorInfo?
    
    let columns = Array(repeating: GridItem(.adaptive(minimum: 100), spacing: 16), count: 4)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(colorItems) { colorInfo in
                    ColorItemView(colorInfo: colorInfo, isSelected: selectedColorInfo?.id == colorInfo.id)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedColorInfo = colorInfo
                            }
                        }
                }
            }
            .padding()
        }
    }
}

// Color Item View
struct ColorItemView: View {
    let colorInfo: ColorInfo
    let isSelected: Bool
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(colorInfo.color)
                .frame(height: 100)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(isSelected ? Color.blue : Color.gray.opacity(0.3),
                                    lineWidth: isSelected ? 2 : 1)
                )
                .shadow(radius: isSelected ? 4 : 2)
            
            Text(colorInfo.name)
                .font(.caption)
                .foregroundColor(.primary)
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
    }
}

// Color Detail Panel
struct ColorDetailPanel: View {
    let colorInfo: ColorInfo?
    
    var body: some View {
        Group {
            if let colorInfo = colorInfo {
                ColorDetails(colorInfo: colorInfo)
            } else {
                NoSelectionView()
            }
        }
        .padding()
        .background(Color(NSColor.windowBackgroundColor))
    }
}

struct NoSelectionView: View {
    var body: some View {
        VStack {
            Image(systemName: "arrow.up.circle")
                .font(.largeTitle)
                .foregroundColor(.secondary)
            Text("Select a color to view its details")
                .font(.headline)
                .foregroundColor(.secondary)
        }
    }
}

struct ColorDetails: View {
    let colorInfo: ColorInfo
    @State private var toastMessage: String?
    @State private var toastLocation: CGPoint?
    
    var swiftCodeString: String { "Color.\(colorInfo.name.lowercased())" }
    var rgbString: String {
        let rgba = colorInfo.color.getRGBA()
        return String(format: "Color(red: %.2f, green: %.2f, blue: %.2f, opacity: %.2f)",
                     rgba.red, rgba.green, rgba.blue, rgba.alpha)
    }
    
    var body: some View {
        HStack(spacing: 20) {
            // Color Preview
            RoundedRectangle(cornerRadius: 16)
                .fill(colorInfo.color)
                .frame(width: 150)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .shadow(radius: 4)
                .onTapGesture { location in
                    copyToClipboard(swiftCodeString, at: location)
                }
            
            // Color Information
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Swift Code:")
                        .font(.headline)
                    Text(swiftCodeString)
                        .font(.system(.body, design: .monospaced))
                        .padding(4)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(4)
                        .onTapGesture { location in
                            copyToClipboard(swiftCodeString, at: location)
                        }
                }
                
                let rgba = colorInfo.color.getRGBA()
                HStack {
                    Text("RGB:")
                        .font(.headline)
                    Text(String(format: "%.2f, %.2f, %.2f, %.2f",
                         rgba.red, rgba.green, rgba.blue, rgba.alpha))
                        .font(.system(.body, design: .monospaced))
                        .padding(4)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(4)
                        .onTapGesture { location in
                            copyToClipboard(rgbString, at: location)
                        }
                }
                
                HStack {
                    Text("Hex:")
                        .font(.headline)
                    Text(colorInfo.color.toHex())
                        .font(.system(.body, design: .monospaced))
                        .padding(4)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(4)
                        .onTapGesture { location in
                            copyToClipboard(colorInfo.color.toHex(), at: location)
                        }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .overlay {
            if let message = toastMessage, let location = toastLocation {
                ToastView(message: message, color: colorInfo.color)
                    .position(x: location.x, y: location.y - 30)
                    .transition(.opacity)
            }
        }
    }
}

extension ColorDetails {
    private func copyToClipboard(_ text: String, at location: CGPoint) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
        
        withAnimation {
            toastMessage = "Copied!"
            toastLocation = location
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                toastMessage = nil
                toastLocation = nil
            }
        }
    }
}

struct MaterialsView: View {
    @Binding var materialItems: [MaterialInfo]
    @State private var gradientStart = UnitPoint(x: 0, y: 0)
    @State private var gradientEnd = UnitPoint(x: 1, y: 1)
    @State private var isAnimating = true
    @State private var animationTask: Task<Void, Never>?
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.blue, .purple, .red, .orange],
                startPoint: gradientStart,
                endPoint: gradientEnd
            )
            .ignoresSafeArea()
            .onChange(of: isAnimating) { oldValue, newValue in
                if newValue {
                    animate()
                } else {
                    animationTask?.cancel()
                }
            }
            
            VStack {
                Button(action: { isAnimating.toggle() }) {
                    Image(systemName: isAnimating ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
                .padding()
                
                Spacer()
            }
            
            ForEach($materialItems) { $item in
                MaterialItemView(materialInfo: item)
                    .position(item.position)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                $item.position.wrappedValue = value.location
                            }
                    )
            }
        }
        .onAppear {
            if isAnimating {
                animate()
            }
        }
        .onDisappear {
            animationTask?.cancel()
        }
    }
    
    private func animate() {
        animationTask = Task {
            while !Task.isCancelled {
                withAnimation(.linear(duration: 5.0)) {
                    gradientStart = UnitPoint(x: 1, y: 1)
                    gradientEnd = UnitPoint(x: 0, y: 0)
                }
                try? await Task.sleep(nanoseconds: 5_000_000_000)
                
                if Task.isCancelled { break }
                
                withAnimation(.linear(duration: 5.0)) {
                    gradientStart = UnitPoint(x: 0, y: 0)
                    gradientEnd = UnitPoint(x: 1, y: 1)
                }
                try? await Task.sleep(nanoseconds: 5_000_000_000)
            }
        }
    }
}

// Material Item View
struct MaterialItemView: View {
    let materialInfo: MaterialInfo
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(materialInfo.material)
                .frame(width: 200, height: 120)
            
            Text(materialInfo.name)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .padding(8)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.white.opacity(0.3), lineWidth: 1)
        )
        .shadow(radius: 4)
    }
}

// Keep the Color extension for RGB and Hex conversion
extension Color {
    func getRGBA() -> (red: Double, green: Double, blue: Double, alpha: Double) {
        let nsColor = NSColor(self)
        let cgColor = nsColor.cgColor
        let components = cgColor.components ?? [0, 0, 0, 1]
        
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        let alpha = components.count > 3 ? components[3] : 1.0
        
        return (red, green, blue, alpha)
    }
    
    func toHex() -> String {
        let rgba = getRGBA()
        return String(
            format: "#%02X%02X%02X",
            Int(rgba.red * 255),
            Int(rgba.green * 255),
            Int(rgba.blue * 255)
        )
    }
}

#Preview {
    ContentView()
}
