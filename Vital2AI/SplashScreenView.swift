import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var opacity = 0.0
    @State private var size = 0.7

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if isActive {
                ContentView()
            } else {
                VStack(spacing: 24) {
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120)
                        .scaleEffect(size)
                        .opacity(opacity)

                    VStack(spacing: 8) {
                        Text("Vital2AI")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)

                        Text("app_tagline")
                            .font(.system(size: 12, weight: .semibold))
                            .tracking(2.0)
                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                    }
                    .opacity(opacity)
                }
                .onAppear {
                    withAnimation(.easeOut(duration: 1.2)) {
                        self.size = 1.0
                        self.opacity = 1.0
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            self.isActive = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
