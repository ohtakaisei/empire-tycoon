# EMPIRE 帝国経営録

二択スワイプで企業を率いる、Reigns 風の経営シミュレーション（iOS / SwiftUI + SwiftData）。

創業の一杯のコーヒーから始まり、**創業期 → シード期 → 成長期 → 拡大期 → 成熟期 → 帝国期** の全6章（各30ターン）を、左右の決断で生き抜く。過去の選択が遠い未来に響き、業態ルートと経営方針が結末を変える。

## 特徴
- 📖 **章立ての長編ストーリー**（全6章・計180ターン）
- ☕ **原点から選ぶ業態ルート**（カフェ / 抽出機器 / アプリ / ハード）
- 🔀 **過去の選択が未来を決める因果アーク**（サーガフラグ）
- 🏁 **状況で変わる多彩な結末**（20種）
- 💾 **いつでもセーブ＆再開**
- 🎨 全イラストは SwiftUI Canvas によるコード描画（画像アセット不使用）

## 構成
- `EMPIRE/` — Xcode プロジェクト（iOS 17+ / SwiftUI / SwiftData）
- `EMPIRE/EMPIRE/Resources/cards.json` — カードデータ（データ駆動）
- `EMPIRE/EMPIRE/Resources/endings.json` — 結末データ
- `docs/` — GitHub Pages（プライバシーポリシー・利用規約・紹介ページ・ストア提出資料）

## ビルド
```sh
cd EMPIRE
xcodebuild -project EMPIRE.xcodeproj -target EMPIRE -sdk iphonesimulator -configuration Debug build
```

## 法務
- [プライバシーポリシー](https://ohtakaisei.github.io/empire-tycoon/privacy.html)
- [利用規約](https://ohtakaisei.github.io/empire-tycoon/terms.html)

created by Kaisei
