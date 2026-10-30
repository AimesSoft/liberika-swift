[中文](README.zh.md) | [English](README.md) | 日本語

# liberika for Swift

[liberika](https://github.com/AimesSoft/liberika) メディアエンジンのネイティブ Swift SDK です。macOS、iOS、tvOS 向けの Swift API と Metal ベースのビューを提供します。ビルド済みネイティブランタイムは Swift Package Manager が自動的にダウンロードするため、アプリ側に Rust、FFmpeg、CocoaPods、Flutter は不要です。

## 動作要件

- macOS 11 以降
- iOS 13 以降
- tvOS 13 以降
- Xcode 15 以降

## インストール

Xcode で **File > Add Package Dependencies** を選び、次の URL を入力します。

```text
https://github.com/AimesSoft/liberika-swift
```

バージョン `0.3.0` 以降を選択し、ターゲットに `Erika` プロダクトを追加します。

## UIKit / AppKit

```swift
import Erika

let player = try ErikaPlayer()
let videoView = ErikaVideoView(frame: container.bounds)
videoView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
videoView.player = player
container.addSubview(videoView)

try player.open("https://example.com/video.mp4")
try player.play()
```

`ErikaVideoView` は `CAMetalLayer` を所有し、ネイティブビューと drawable のサイズを同期して、presenter のレンダーループを駆動します。

## SwiftUI

```swift
import Erika
import SwiftUI

struct PlayerScreen: View {
    let player: ErikaPlayer

    var body: some View {
        ErikaPlayerView(player: player)
            .task {
                try? player.open("https://example.com/video.mp4")
                try? player.play()
            }
    }
}
```

`ErikaPlayer` はメインアクターで作成・使用します。`pollEvent()` で再生、位置、バッファリング、トラック、デコーダー、出力の変更を取得します。

## 利用可能な API

- ローカルファイルと HTTP(S) ストリームのオープン、カスタムヘッダー、先読みの制御
- 再生、一時停止、停止、シーク、再生速度、音量
- 音声・字幕トラックの列挙と選択、ビットレート / フレームレートのメタデータ
- 外部字幕、字幕の拡大率とスタイル、メモリ上のフォント登録
- Bilibili XML / JSON の弾幕トラック、オフセット、フィルタリング、配置設定
- SDR、Apple EDR、extended-linear、自動出力モード
- packed-alpha 映像出力と ArtCNN 輝度超解像モード
- 再生、デコーダー、出力、アップスケーラー、リソースの統計
- 合成済み RGBA フレームのキャプチャ
- UIKit、AppKit、SwiftUI の動画ビュー

低レベルの `invoke(_:arguments:)` API を使うと、Swift ラッパーの更新を待たずに新しい liberika presenter コマンドにアクセスできます。

## ライセンス

Swift ラッパーは MPL-2.0 で提供されます。バイナリターゲットには liberika と静的リンクされたネイティブ依存が含まれます。それぞれのライセンスは `THIRD_PARTY_NOTICES.md` と liberika のリリースに含まれる通知を参照してください。
