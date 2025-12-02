

import Foundation
import Combine
import SwiftUI




@MainActor
class SavedColorsViewModel: ObservableObject {
    @Published var savedColors: [ColorRequest] = []
    @Published var colors: [ColorRequest] = []

    @Published var isLoading = false
    @Published var errorMessage: String?
    
    var uiColors: [UIColor] {
        colors.compactMap { UIColor(hex: $0.colorCode )}
    }
    
    
    func fetchSavedColors() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let colors = try await ColorService.shared.GetColors()
            self.savedColors = colors
            self.colors = colors
        } catch {

            errorMessage = error.localizedDescription
            
            print("Error fetching colors:", error)
        }
        isLoading = false
    }
    
    func deleteColor(at offsets: IndexSet) {
        for index in offsets {
            let colorId = savedColors[index].colorId
            
            Task {
                try await ColorService.shared.DeleteColor(colorId: colorId)
            }
        }
        
        savedColors.remove(atOffsets: offsets)
    }
    
}
