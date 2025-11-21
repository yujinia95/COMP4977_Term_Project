import SwiftUI

struct PastelStripeBackground: View {
    private let colors: [Color] = [.pastelPink, .pastelPeach, .pastelMint, .pastelBlue]

    var body: some View {
        GeometryReader { geo in

            Color.pastelPeach
                .ignoresSafeArea()


            let maxSide = max(geo.size.width, geo.size.height)

            VStack(spacing: 0) {

                ForEach(0..<12, id: \.self) { i in
                    colors[i % colors.count]
                        .frame(height: maxSide / 4)
                }
            }
            .frame(width: maxSide * 2.2, height: maxSide * 2.2)
            .rotationEffect(.degrees(-18))
            .position(x: geo.size.width / 2, y: geo.size.height / 2)
            .ignoresSafeArea()
        }
    }
}
