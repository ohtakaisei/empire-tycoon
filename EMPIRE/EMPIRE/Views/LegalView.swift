import SwiftUI

/// 公開中の法務ページURL。
enum LegalLinks {
    static let privacy = URL(string: "https://ohtakaisei.github.io/empire-tycoon/privacy.html")!
    static let terms   = URL(string: "https://ohtakaisei.github.io/empire-tycoon/terms.html")!
}

/// プライバシーポリシー / 利用規約をアプリ内で表示するシート。
/// オフラインでも読めるよう本文を同梱し、Web版へのリンクも置く。
struct LegalView: View {
    enum Tab: String, CaseIterable { case privacy = "プライバシーポリシー", terms = "利用規約" }
    @State var tab: Tab = .privacy
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("", selection: $tab) {
                    ForEach(Tab.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
                .padding(16)

                ScrollView {
                    Text(tab == .privacy ? Self.privacyText : Self.termsText)
                        .font(.system(size: 14))
                        .foregroundStyle(.white.opacity(0.85))
                        .lineSpacing(5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 8)

                    Button {
                        openURL(tab == .privacy ? LegalLinks.privacy : LegalLinks.terms)
                    } label: {
                        Label("Web版を開く", systemImage: "safari")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .padding(.vertical, 18)
                }
            }
            .background(Pal.navy.ignoresSafeArea())
            .navigationTitle("規約・プライバシー")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("閉じる") { dismiss() }
                }
            }
        }
        .tint(Pal.gold)
    }

    static let privacyText = """
    EMPIRE 帝国経営録 — プライバシーポリシー
    最終更新日：2026年6月23日

    本アプリは、利用者の個人情報を一切収集しません。ゲームの進行データはすべてお使いの端末内にのみ保存され、外部に送信されることはありません。

    ■ 収集する情報
    氏名・メールアドレス・位置情報・連絡先・端末識別子などの個人情報は収集・送信しません。アカウント登録やログインも不要です。

    ■ 端末内に保存されるデータ
    ・ゲームの進行状況／中断セーブ（会社名・パラメータ・章の進行など）
    ・プレイ記録（到達ターン数・結末などの統計）
    これらは本アプリをアンインストールすると端末から削除されます。

    ■ 第三者提供・解析・広告
    第三者へのデータ提供は行いません。解析ツール・広告SDK・トラッキング技術は使用せず、ネットワーク通信も行いません。

    ■ お問い合わせ
    開発者：Kaisei
    メール：kakuseipeterjacson0620@gmail.com
    """

    static let termsText = """
    EMPIRE 帝国経営録 — 利用規約
    最終更新日：2026年6月23日

    本規約は、開発者 Kaisei（当方）が提供する本アプリの利用条件を定めます。利用者は本アプリの利用により本規約に同意したものとみなされます。

    ■ ライセンス
    本アプリを個人的・非商業的に利用する、譲渡不能・非独占的な権利を許諾します。本アプリおよびコンテンツの知的財産権は当方に帰属します。

    ■ 禁止事項
    複製・改変・リバースエンジニアリング、無断転載・再配布・販売、法令や公序良俗に反する行為。

    ■ 免責事項
    本アプリは「現状有姿」で提供され、いかなる保証も行いません。本作はフィクションであり、登場する企業・人物・出来事は架空のものです。経営・投資・法務の助言を構成しません。

    ■ 責任の制限
    本アプリの利用または利用不能から生じる損害（データ消失を含む）について、適用法令が許す範囲で責任を負いません。

    ■ 準拠法
    本規約は日本法に準拠します。

    ■ Apple について
    App Store 経由の場合、Apple標準のエンドユーザー使用許諾契約（EULA）が併せて適用されます。

    ■ お問い合わせ
    メール：kakuseipeterjacson0620@gmail.com
    """
}
