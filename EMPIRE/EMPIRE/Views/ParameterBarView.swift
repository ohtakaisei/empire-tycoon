import SwiftUI

/// 上部の4パラメータ表示。危険域は赤く点滅し、スワイプ中は変化予測をハイライト。
/// アイコンを押している間だけ、そのステータスの名称と説明をツールチップ表示する。
struct ParameterBarView: View {
    let params: Parameters
    let game: GameState
    /// スワイプ中に変化するパラメータ（プレビュー強調用）。
    let highlighted: Set<ParamKey>

    @State private var pulse = false
    @State private var pressed: ParamKey? = nil

    var body: some View {
        ZStack(alignment: .top) {
            HStack(spacing: 0) {
                ForEach(ParamKey.allCases, id: \.self) { key in
                    gauge(key)
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in if pressed != key { pressed = key } }
                                .onEnded { _ in pressed = nil }
                        )
                }
            }

            if let key = pressed {
                tooltip(key)
                    .offset(y: -6)
                    .transition(.opacity.combined(with: .scale(scale: 0.9, anchor: .top)))
                    .zIndex(1)
            }
        }
        .animation(.easeOut(duration: 0.15), value: pressed)
        .onAppear { pulse = true }
        .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: pulse)
    }

    private func tooltip(_ key: ParamKey) -> some View {
        VStack(spacing: 3) {
            Text(key.fullName)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.white)
            Text(key.desc)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.white.opacity(0.75))
                .multilineTextAlignment(.center)
            if key == .money {
                Text("現在の資金: \(Money.capital(point: params[.money]))")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(Pal.gold)
                    .padding(.top, 1)
            }
        }
        .padding(.horizontal, 14).padding(.vertical, 10)
        .frame(maxWidth: 260)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.92))
                .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(key.color.opacity(0.6), lineWidth: 1))
        )
        .shadow(color: .black.opacity(0.5), radius: 8, y: 4)
    }

    private func gauge(_ key: ParamKey) -> some View {
        let value = params[key]
        let danger = game.isDanger(key)
        let isHi = highlighted.contains(key)

        return VStack(spacing: 5) {
            ZStack {
                Circle()
                    .fill(key.color.opacity(danger ? (pulse ? 0.9 : 0.3) : 0.22))
                    .frame(width: 38, height: 38)
                Image(systemName: key.icon)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(danger ? Color.red : key.color)
            }
            .overlay(Circle().stroke(isHi ? Color.white : (pressed == key ? key.color : .clear), lineWidth: 2))
            .scaleEffect(isHi || pressed == key ? 1.12 : 1)
            .animation(.spring(response: 0.25), value: isHi)

            // ゲージ
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.white.opacity(0.12))
                    Capsule()
                        .fill(danger ? Color.red : key.color)
                        .frame(width: geo.size.width * CGFloat(value) / 100)
                }
            }
            .frame(height: 5)
            .padding(.horizontal, 8)

            // 数値（資金だけ円換算）
            Text(key == .money ? Money.capital(point: value) : "\(value)")
                .font(.system(size: key == .money ? 10 : 11, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.7))
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
    }
}
