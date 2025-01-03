import SwiftUI

// Define structures to hold our color and material information
struct ColorInfo: Identifiable {
    let id = UUID()
    let color: Color
    let name: String
}

struct MaterialInfo: Identifiable {
    let id = UUID()
    let material: Material
    let name: String
}

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var selectedColorInfo: ColorInfo?
    @State private var showingDetail = false
    
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
    
    // Define all available materials
    let materialItems: [MaterialInfo] = [
        MaterialInfo(material: .ultraThinMaterial, name: "Ultra Thin Material"),
        MaterialInfo(material: .thinMaterial, name: "Thin Material"),
        MaterialInfo(material: .regularMaterial, name: "Regular Material"),
        MaterialInfo(material: .thickMaterial, name: "Thick Material"),
        MaterialInfo(material: .ultraThickMaterial, name: "Ultra Thick Material")
    ]
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Colors Tab
            ColorsGridView(colorItems: colorItems,
                          selectedColorInfo: $selectedColorInfo,
                          showingDetail: $showingDetail)
                .tabItem {
                    Label("Colors", systemImage: "paintpalette")
                }
                .tag(0)
            
            // Materials Tab
            MaterialsGridView(materialItems: materialItems)
                .tabItem {
                    Label("Materials", systemImage: "circle.grid.cross")
                }
                .tag(1)
        }
        .sheet(item: $selectedColorInfo) { colorInfo in
            ColorDetailView(colorInfo: colorInfo)
        }
    }
}

// Color Grid View
struct ColorsGridView: View {
    let colorItems: [ColorInfo]
    @Binding var selectedColorInfo: ColorInfo?
    @Binding var showingDetail: Bool
    
    let columns = Array(repeating: GridItem(.adaptive(minimum: 100), spacing: 16), count: 4)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(colorItems) { colorInfo in
                    ColorItemView(colorInfo: colorInfo)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedColorInfo = colorInfo
                                showingDetail = true
                            }
                        }
                }
            }
            .padding()
        }
    }
}

// Material Grid View
struct MaterialsGridView: View {
    let materialItems: [MaterialInfo]
    let columns = Array(repeating: GridItem(.adaptive(minimum: 150), spacing: 16), count: 3)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(materialItems) { materialInfo in
                    MaterialItemView(materialInfo: materialInfo)
                }
            }
            .padding()
        }
    }
}

// Color Item View
struct ColorItemView: View {
    let colorInfo: ColorInfo
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(colorInfo.color)
                .frame(height: 100)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .shadow(radius: 2)
            
            Text(colorInfo.name)
                .font(.caption)
                .foregroundColor(.primary)
        }
    }
}

// Material Item View
struct MaterialItemView: View {
    let materialInfo: MaterialInfo
    
    var body: some View {
        VStack {
            ZStack {
                // Checkerboard background to better show transparency
                CheckerboardBackground()
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(materialInfo.material)
                    .frame(height: 100)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .shadow(radius: 2)
            
            Text(materialInfo.name)
                .font(.caption)
                .foregroundColor(.primary)
        }
    }
}

// Checkerboard Background for Materials
struct CheckerboardBackground: View {
    var body: some View {
        Canvas { context, size in
            let tileSize: CGFloat = 10
            for row in 0...Int(size.height/tileSize) {
                for col in 0...Int(size.width/tileSize) {
                    let rect = CGRect(x: CGFloat(col) * tileSize,
                                    y: CGFloat(row) * tileSize,
                                    width: tileSize,
                                    height: tileSize)
                    
                    context.fill(
                        Path(rect),
                        with: .color((row + col).isMultiple(of: 2) ? .gray.opacity(0.2) : .white)
                    )
                }
            }
        }
    }
}

// Color Detail View
struct ColorDetailView: View {
    let colorInfo: ColorInfo
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            RoundedRectangle(cornerRadius: 16)
                .fill(colorInfo.color)
                .frame(height: 200)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .shadow(radius: 4)
            
            Text(colorInfo.name)
                .font(.title)
                .bold()
            
            // Add color information here (RGB values, etc. if needed)
            
            Button("Close") {
                dismiss()
            }
            .buttonStyle(.bordered)
            .padding()
        }
        .padding()
        .frame(minWidth: 300, minHeight: 400)
    }
}

#Preview {
    ContentView()
}
