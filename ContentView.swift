import SwiftUI

struct ContentView: View {
    @State private var selectedColor: Color? = nil
    let colors: [Color] = [.blue, .yellow, .purple, .red, .green, .orange, .pink, .gray, .black, .white, .brown, .cyan, .mint, .indigo, .teal, .ultraThinMaterial, .ultraThickMaterial]

    var body: some View {
        let columns = [
            GridItem(.adaptive(minimum: 50))
        ]

        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(colors, id: \.self) { color in
                Rectangle()
                    .fill(color)
                    .frame(width: selectedColor == color ? 100 : 50, height: selectedColor == color ? 100 : 50)
                    .onTapGesture {
                        withAnimation {
                            selectedColor = selectedColor == color ? nil : color
                        }
                    }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
