//
//  GenPaletteView.swift
//  AuroraAR
//
//  Created by Evan Vink on 2025-11-21.
//

import SwiftUI

struct GenPaletteView: View {
    
    @StateObject private var viewModel = PaletteViewModel()
    
    var body: some View {
        
            
            NavigationView {
                ZStack{
                    PastelStripeBackground()
                    
                    VStack(spacing: 20) {
                        
                        Button {
                            viewModel.fetchPalette()
                        } label: {
                            Text("Generate Palette")
                        }
                        
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(alignment: .center, spacing: 20) {
                                ForEach(viewModel.palette, id: \.hex) { color in
                                    VStack {
                                        Rectangle()
                                            .fill(Color(hex: color.hex) ?? .gray)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 100)
                                            .cornerRadius(10)
                                        
                                        Text(color.name)
                                            .font(.headline)
                                        
                                        Text(color.hex)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .padding()
                        }
                        
                        Spacer()
                    }
                }
            
        }
           
    }
}

#Preview {
    GenPaletteView()
}
