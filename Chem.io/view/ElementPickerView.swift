import SwiftUI

struct ElementPickerView: View {
    @Environment(\.dismiss) private var dismiss
    var viewModel: SandboxViewModel
    
    let columns = [GridItem(.adaptive(minimum: 80, maximum: 100))]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(Element.allCases) { element in
                        Button {
                            viewModel.spawnElement(element)
                        } label: {
                            ElementGridItem(element: element)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationTitle("Elements")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
}

struct ElementGridItem: View {
    let element: Element
    
    var body: some View {
        ZStack {
            Circle()
                .fill(element.swiftUIColor.gradient)
                .frame(width: 80, height: 80)
                .shadow(radius: 2)
            
            // Atomic Number (top-left)
            VStack {
                HStack {
                    Text("\(element.atomicNumber)")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(textColor)
                        .padding(.top, 14)
                        .padding(.leading, 14)
                    Spacer()
                }
                Spacer()
            }
            
            // Symbol (center)
            Text(element.symbol)
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(textColor)
            
            // Name (bottom)
            VStack {
                Spacer()
                Text(element.name)
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundColor(textColor)
                    .padding(.bottom, 12)
            }
        }
        .frame(width: 80, height: 80)
    }
    
    var textColor: Color {
        // use dark text for light-colored elements
        let lightElements: [Element] = [.hydrogen, .helium, .beryllium, .neon, .fluorine, .lithium]
        if lightElements.contains(element) {
            return .black.opacity(0.8)
        } else {
            return .white
        }
    }
}
