# EMPIRE / 帝国経営録

スワイプ式・大規模分岐型 経営ジレンマゲーム（要件定義書 Phase 1〜3「縦の一本」）。
Reigns の意思決定構造を企業経営テーマに置き換えた iOS アプリ。

- Platform: iOS 17+ / SwiftUI + SwiftData
- 外部ゲームエンジン不使用・**データ駆動**（ロジックとコンテンツを分離）

## 遊び方

カードを **左右にスワイプ** して二択を決断する。各決定は4つの基幹パラメータに影響し、
いずれかが **0 または 100** に達するとゲームオーバー。30ターン生き延びれば「栄光の引退」。

- **会社名はプレイ開始時にユーザーが入力**（候補チップ/自由入力）。カード文中の `{社名}` トークンに反映され、上部・結末にも表示。
- カードは **386枚**。日常ジレンマ＋**分岐する長編アーク**を多数収録（創業者サーガ、ドローン事業の盛衰、不祥事と再生、お家騒動、宿敵サーガ、内部告発ヒーロー、業界激変、海外帝国、密着ドキュメンタリー、運命の大博打…）。左右の選択で別の物語へ枝分かれし、良い結末/悪い結末/どんでん返しへ。**175枚が連鎖（nextCardId）** を持ち、伏線回収フラグで過去の選択が未来に響く。
- **資金は円換算表示**（1pt=100万円、資金50=¥5,000万）。ただし金額は基本伏せて緊張感を演出し、**本文が金額に言及するカード（または `showCost:true`）でだけ** 選択肢に「資金 ±¥X万」を開示。
- 上部ステータスを **押している間だけ** 名称と説明をツールチップ表示。

| パラメータ | 0で | 100で |
|---|---|---|
| 💰 資金 | 倒産 | 放漫経営の末路 |
| 😊 従業員満足 | 大量離職 | ぬるま湯の崩壊 |
| 📈 市場シェア | 市場淘汰 | 独占規制 |
| ⭐ ブランド評判 | 信用失墜・炎上 | ブランドの呪縛 |

## ビルドと実行

```bash
# シミュレータ向けビルド
xcodebuild -project EMPIRE.xcodeproj -target EMPIRE -sdk iphonesimulator \
  -configuration Debug CONFIGURATION_BUILD_DIR="$PWD/build/Products" \
  CODE_SIGNING_ALLOWED=NO build

# 起動中シミュレータにインストール・起動
xcrun simctl install booted build/Products/EMPIRE.app
xcrun simctl launch booted com.example.EMPIRE
```

Xcode で `EMPIRE.xcodeproj` を開いて ▶ でも実行可。

## 構成

```
EMPIRE/
  EMPIREApp.swift          アプリ入口（@main, SwiftData コンテナ）
  Models/
    Parameters.swift       4パラメータ（ParamKey, Parameters）
    Card.swift             カード/選択肢/出現条件の Codable 定義
    Ending.swift           9種のエンディング定義
    RunRecord.swift        SwiftData モデル（プレイ記録）
  Engine/                  ★中身をハードコードしない汎用エンジン
    CardLoader.swift       cards.json のロード
    CardSelector.swift     requires 条件評価 + 重み付き抽選
    GameState.swift        @Observable 進行状態（choose/連鎖/判定/リスタート）
  Views/
    TitleView / NewGameView(社名入力) / GameView / CardView / ParameterBarView / EndingView
    Art/                   ★コードで描くイラスト（SwiftUI Canvas）
      Palette.swift        共通パレット & 描画ヘルパー
      SceneArt.swift       カード絵27種（bank/factory/lawsuit/robot/rocket/casino…）
      EndingArt.swift      エンディング絵
      CharacterAvatar.swift 発話キャラのアバター
  Resources/
    cards.json             ★コンテンツ。ここを増やすだけでゲームが拡張する
```

## カードの追加（コードを触らずに拡張）

`Resources/cards.json` に1要素追加するだけ。画像は `art` キーで `SceneArt` の描画名を指定
（未知名は汎用書類を描画するので未対応の絵でも動作する）。

```json
{
  "id": "fin_loan_001",
  "category": "finance",
  "art": "bank",
  "speaker": "銀行担当・佐田",
  "speakerImage": "char_banker_sada",
  "text": "5,000万円の融資をご提案できます。",
  "requires": { "minTurn": 5, "params": { "money": { "max": 40 } }, "flags": ["..."], "notFlags": ["..."] },
  "choices": {
    "left":  { "label": "断る",   "effects": { "money": -3, "reputation": 4 }, "setFlags": ["declined_loan"], "nextCardId": null },
    "right": { "label": "受ける", "effects": { "money": 22, "reputation": -4 }, "setFlags": ["has_debt"], "nextCardId": "fin_loan_repay_001" }
  },
  "weight": 12,
  "once": true
}
```

- `requires`: 出現条件（ターン/パラメータ範囲/必要フラグ/除外フラグ）。省略可。
- `nextCardId`: 指定で次ターンに強制出現＝連鎖イベント（例: 融資→返済）。
- `setFlags`: 立てたフラグが将来カードの出現条件になる（伏線回収）。
- `once`: true で1ラン1回限り。

## イラストについて

すべて画像ファイルではなく **SwiftUI の Canvas でコード描画**（フラットな幾何スタイル）。
将来 Asset Catalog の画像へ差し替える場合も、`art` / `speakerImage` の命名規約をキーに後付け可能。
```
