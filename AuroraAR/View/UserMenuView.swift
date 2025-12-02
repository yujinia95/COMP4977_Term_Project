import SwiftUI

struct UserMenuView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            PastelStripeBackground()
                .ignoresSafeArea()

            VStack {
                Spacer()   // push content downward

                VStack(spacing: AppTheme.vSpacing) {

                    // TITLE (Left aligned)
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Menu")
                            .font(.largeTitle.weight(.bold))
                            .foregroundStyle(.black.opacity(0.9))
                        Text("Pick an option")
                            .foregroundStyle(.black.opacity(0.6))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(10)

                    // BUTTONS
                    NavigationLink {
                        CameraColorPickerView()
                    } label: {
                        Label("AR Color", systemImage: "camera.viewfinder")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(FilledButtonStyle())
                    
                    NavigationLink {
                        ARSurfaceView()
                    } label: {
                        Label("Place on Surface", systemImage: "table.furniture")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(OutlineButtonStyle())

                    NavigationLink {
                        SavedColorsView()
                    } label: {
                        Label("Saved Colors", systemImage: "paintpalette")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(OutlineButtonStyle())
                 
                    NavigationLink {
                        GenPaletteView()
                    } label: {
                        Label("Generate Palette", systemImage: "paintbrush.pointed")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(OutlineButtonStyle())

                    Button {
                        appState.logout()
                    } label: {
                        Label("Log out", systemImage: "rectangle.portrait.and.arrow.right")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(OutlineButtonStyle())
                    .tint(.red)
                    .foregroundStyle(.red.opacity(0.9))
                }
                .padding(AppTheme.hPadding)

                Spacer()   
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}


#Preview("Menu • Light") {
    NavigationStack { UserMenuView() }
}
