import SwiftUI

struct SavedColorsView: View {
    
    @StateObject private var viewModel = SavedColorsViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                PastelStripeBackground()
                    .ignoresSafeArea()
                
                List {
                    ForEach(viewModel.savedColors) { color in
                        HStack(spacing: 16) {
                            Rectangle()
                                .fill(Color(hex: color.colorCode) ?? .gray)
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(color.colorName)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                
                                Text(color.colorCode)
                                    .font(.caption)
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(.vertical, 6)
                        .listRowBackground(Color.clear)
                    }
                    .onDelete(perform: viewModel.deleteColor)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Saved Colors")
            .task {
                await viewModel.fetchSavedColors()
            }
        }
    }
}

#Preview {
    SavedColorsView()
}
