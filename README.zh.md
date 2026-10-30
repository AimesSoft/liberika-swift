中文 | [English](README.md) | [日本語](README.ja.md)

# liberika Swift SDK

[liberika](https://github.com/AimesSoft/liberika) 媒体引擎的原生 Swift SDK，提供适用于 macOS、iOS 和 tvOS 的 Swift API 与 Metal 视图。Swift Package Manager 会自动下载预编译运行时，接入应用不需要安装 Rust、FFmpeg、CocoaPods 或 Flutter。

## 要求

- macOS 11 或更高版本
- iOS 13 或更高版本
- tvOS 13 或更高版本
- Xcode 15 或更高版本

## 安装

在 Xcode 中选择 **File > Add Package Dependencies**，输入：

```text
https://github.com/AimesSoft/liberika-swift
```

选择 `0.3.0` 或更高版本，并将 `Erika` product 加入应用 target。

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

`ErikaVideoView` 管理 `CAMetalLayer`，同步 drawable 与原生视图的尺寸，并驱动 presenter 的渲染循环。

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

在主 actor 上创建和使用 `ErikaPlayer`。调用 `pollEvent()` 获取播放、位置、缓冲、轨道、解码器和输出变化。

## 可用 API

- 打开本地文件和 HTTP(S) 流，设置自定义请求头和预读
- 播放、暂停、停止、seek、播放速度和音量
- 发现和选择音轨与字幕轨道，读取码率和帧率元数据
- 外挂字幕、字幕缩放与样式、内存字体注册
- Bilibili XML / JSON 弹幕轨道、偏移、过滤和布局配置
- SDR、Apple EDR、extended-linear 和自动输出模式
- packed-alpha 视频输出和 ArtCNN 亮度超分模式
- 播放、解码器、输出、放大器和资源统计
- 捕获合成后的 RGBA 帧
- UIKit、AppKit 和 SwiftUI 视频视图

较低层的 `invoke(_:arguments:)` API 可以访问新的 liberika presenter 命令，无需立即更新 Swift 封装。

## 许可证

Swift 封装使用 MPL-2.0。二进制 target 包含 liberika 及静态链接的原生依赖；它们的许可证见 `THIRD_PARTY_NOTICES.md` 和 liberika Release 内的声明。
