import SwiftUI

/// NEW GAME のフロー。まず社名を入力させ、確定したらゲーム本編へ。
struct NewGameView: View {
    @AppStorage("companyName") private var savedName = ""
    @State private var name = ""
    @State private var started = false
    @FocusState private var focused: Bool
    @Environment(\.dismiss) private var dismiss

    private let suggestions = ["未来重工", "サクラ商事", "ネオ・テック", "帝国フーズ", "ホクト物産", "ゼニガメ製作所"]

    var body: some View {
        if started {
            GameView(companyName: name.trimmingCharacters(in: .whitespaces))
        } else {
            entry
        }
    }

    private var entry: some View {
        ZStack {
            LinearGradient(colors: [Pal.navy, Color(red: 0.06, green: 0.06, blue: 0.12)],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 18) {
                Spacer()

                EndingArt(name: "trophy")
                    .frame(width: 120, height: 120)
                    .opacity(0.9)

                Text("会社を設立する")
                    .font(.system(size: 24, weight: .black))
                    .foregroundStyle(.white)
                Text("あなたが率いる会社の名前を決めましょう。")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.white.opacity(0.6))

                // 入力欄
                HStack {
                    Image(systemName: "building.2.fill").foregroundStyle(Pal.gold)
                    TextField("", text: $name, prompt: Text("社名を入力").foregroundStyle(.white.opacity(0.35)))
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                        .focused($focused)
                        .submitLabel(.done)
                        .onSubmit(start)
                }
                .padding(.horizontal, 18).padding(.vertical, 14)
                .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.08)))
                .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(Pal.gold.opacity(0.4), lineWidth: 1))
                .padding(.horizontal, 36)

                // 候補
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 96), spacing: 8)], spacing: 8) {
                    ForEach(suggestions, id: \.self) { s in
                        Button { name = s } label: {
                            Text(s)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(.white.opacity(0.8))
                                .padding(.horizontal, 12).padding(.vertical, 7)
                                .background(Capsule().fill(Color.white.opacity(0.08)))
                        }
                    }
                }
                .padding(.horizontal, 36)

                Spacer()

                Button(action: start) {
                    Text("この社名で始める")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(Pal.navy)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Capsule().fill(canStart ? Pal.gold : Pal.gold.opacity(0.4)))
                }
                .disabled(!canStart)
                .padding(.horizontal, 40)

                Button("もどる") { dismiss() }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white.opacity(0.5))
                    .padding(.bottom, 30)
            }
        }
        .onAppear {
            if name.isEmpty { name = savedName }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { focused = true }
        }
    }

    private var canStart: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private func start() {
        guard canStart else { return }
        savedName = name.trimmingCharacters(in: .whitespaces)
        focused = false
        withAnimation(.easeInOut(duration: 0.3)) { started = true }
    }
}
