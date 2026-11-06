import CErika
import Erika
import XCTest

final class ErikaTests: XCTestCase {
    func testDefaultConfiguration() {
        let configuration = ErikaPlayer.Configuration()
        XCTAssertEqual(configuration.outputMode, .automatic)
        XCTAssertEqual(configuration.edrHeadroom, 1)
        XCTAssertEqual(configuration.upscaler, .off)
        XCTAssertEqual(configuration.videoAlphaMode, .opaque)
    }

    func testHeadroomIsClamped() {
        let configuration = ErikaPlayer.Configuration(edrHeadroom: 0.5)
        XCTAssertEqual(configuration.edrHeadroom, 1)
    }

    func testPublicEnumValuesMatchABI() {
        XCTAssertEqual(ErikaPlaybackState.playing.rawValue, 3)
        XCTAssertEqual(ErikaEventKind.error.rawValue, 9)
        XCTAssertEqual(ErikaUpscaler.artCNNC4F16DS.rawValue, 3)
        XCTAssertEqual(ErikaVideoAlphaMode.opaque.rawValue, 0)
        XCTAssertEqual(ErikaVideoAlphaMode.packedAlphaRight.rawValue, 1)
        XCTAssertEqual(ErikaSubtitleOverride.all.rawValue, 0x9FC)
    }

    func testOpenOptionsDefaultsAndHeaders() {
        let options = ErikaOpenOptions(
            httpHeaders: ["X-Test": "ok"],
            httpReadAheadBytes: 2 * 1024 * 1024,
            httpBackBufferBytes: 16 * 1024 * 1024
        )
        XCTAssertEqual(options.httpHeaders["X-Test"], "ok")
        XCTAssertEqual(options.httpReadAheadBytes, 2 * 1024 * 1024)
        XCTAssertEqual(options.httpBackBufferBytes, 16 * 1024 * 1024)
    }

    func testLegacyPlaybackEventJSONRemainsDecodable() throws {
        let data = Data(#"{"kind":1}"#.utf8)
        let event = try JSONDecoder().decode(ErikaPlaybackEvent.self, from: data)
        XCTAssertEqual(event.kind, .stateChanged)
        XCTAssertEqual(event.state, .idle)
        XCTAssertNil(event.decoder)
        XCTAssertNil(event.audio)
    }

    func testNaturalEndEventDecodesAndMatchesNativeKind() throws {
        // This is the shape returned by erika_presenter_poll_event_json.
        let event = try JSONDecoder().decode(ErikaPlaybackEvent.self, from: Data(#"{"kind":14,"state":5}"#.utf8))
        XCTAssertEqual(event.kind, .ended)
        XCTAssertEqual(event.state, .stopped)
        XCTAssertEqual(ErikaEventKind(rawValue: Int32(CErika.ErikaEventKind_Ended.rawValue)), .ended)
    }

    func testUpscalerModesMatchNativeABI() {
        let cases: [(ErikaUpscaler, Int32)] = [
            (.off, Int32(ErikaLumaUpscalerMode_Off.rawValue)),
            (.artCNNC4F16, Int32(ErikaLumaUpscalerMode_ArtCnnC4F16.rawValue)),
            (.artCNNC4F32, Int32(ErikaLumaUpscalerMode_ArtCnnC4F32.rawValue)),
            (.artCNNC4F16DS, Int32(ErikaLumaUpscalerMode_ArtCnnC4F16Ds.rawValue)),
            (.artCNNC4F16DN, Int32(ErikaLumaUpscalerMode_ArtCnnC4F16Dn.rawValue)),
            (.artCNNC4F32DS, Int32(ErikaLumaUpscalerMode_ArtCnnC4F32Ds.rawValue)),
            (.artCNNC4F32DN, Int32(ErikaLumaUpscalerMode_ArtCnnC4F32Dn.rawValue)),
            (.artCNNR8F64, Int32(ErikaLumaUpscalerMode_ArtCnnR8F64.rawValue)),
            (.anime4kS, Int32(ErikaLumaUpscalerMode_Anime4kS.rawValue)),
            (.anime4kM, Int32(ErikaLumaUpscalerMode_Anime4kM.rawValue)),
            (.anime4kL, Int32(ErikaLumaUpscalerMode_Anime4kL.rawValue)),
            (.anime4kVL, Int32(ErikaLumaUpscalerMode_Anime4kVl.rawValue)),
            (.anime4kUL, Int32(ErikaLumaUpscalerMode_Anime4kUl.rawValue)),
            (.anime4kDenoiseS, Int32(ErikaLumaUpscalerMode_Anime4kDenoiseS.rawValue)),
            (.anime4kDenoiseM, Int32(ErikaLumaUpscalerMode_Anime4kDenoiseM.rawValue)),
            (.anime4kDenoiseL, Int32(ErikaLumaUpscalerMode_Anime4kDenoiseL.rawValue)),
            (.anime4kDenoiseVL, Int32(ErikaLumaUpscalerMode_Anime4kDenoiseVl.rawValue)),
            (.anime4kDenoiseUL, Int32(ErikaLumaUpscalerMode_Anime4kDenoiseUl.rawValue)),
            (.fsr1, Int32(ErikaLumaUpscalerMode_Fsr1.rawValue)),
            (.platformVideo, Int32(ErikaLumaUpscalerMode_PlatformVideo.rawValue)),
            (.metalFXSpatial, Int32(ErikaLumaUpscalerMode_MetalFxSpatial.rawValue)),
            (.custom, Int32(ErikaLumaUpscalerMode_Custom.rawValue)),
        ]
        XCTAssertEqual(Set(cases.map { $0.0 }), Set(ErikaUpscaler.allCases))
        for (mode, nativeValue) in cases {
            XCTAssertEqual(mode.rawValue, nativeValue, "\(mode)")
        }
    }

    func testLegacyTrackJSONRemainsDecodable() throws {
        let data = Data(#"{"id":7,"kind":2,"source":0}"#.utf8)
        let track = try JSONDecoder().decode(ErikaTrack.self, from: data)
        XCTAssertEqual(track.id, 7)
        XCTAssertEqual(track.kind, .subtitle)
        XCTAssertEqual(track.bitRate, 0)
        XCTAssertNil(track.framesPerSecond)
    }
}
