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
                        .font(.title3.weight(.semibold))
                        .frame(maxWidth: 330)
                        .padding(.vertical, 14)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                                .stroke(.black.opacity(0.15), lineWidth: 1)
                        )
                        .background(.white.opacity(0.6))
                        .foregroundStyle(.black.opacity(0.85))
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius, style: .continuous))
                        
                        
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
                                            .foregroundColor(.black)
                                        
                                        Text(color.hex)
                                            .font(.caption)
                                            .foregroundColor(.black)
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
