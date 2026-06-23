import SwiftUI
import SwiftData

@main
struct EMPIREApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: RunRecord.self)
    }
}

/// 起動スプラッシュ → タイトルへの遷移を司るルート。
private struct RootView: View {
    @State private var showTitle = false

    var body: some View {
        ZStack {
            if showTitle {
                TitleView()
                    .transition(.opacity)
            } else {
                SplashView { withAnimation(.easeInOut(duration: 0.6)) { showTitle = true } }
                    .transition(.opacity)
            }
        }
    }
}
