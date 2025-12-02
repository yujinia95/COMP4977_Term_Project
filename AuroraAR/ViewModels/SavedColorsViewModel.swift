

import Foundation
import Combine
import SwiftUI




@MainActor
class SavedColorsViewModel: ObservableObject {
    @Published var savedColors: [ColorRequest] = []
    
    func fetchSavedColors() async {
        do {
            let colors = try await ColorService.shared.GetColors()
            self.savedColors = colors
        } catch {
            print("Error fetching colors:", error)
        }
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
