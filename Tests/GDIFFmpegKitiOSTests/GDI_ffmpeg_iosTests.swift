//
//  GDI_ffmpeg_iosTests.swift
//  GDI-ffmpeg-iosTests
//
//  Created by Grant Davis on 1/21/22.
//

import XCTest
@testable import GDI_ffmpeg_ios

class GDI_ffmpeg_iosTests: XCTestCase {

    func testProbe() async throws {
        let url = URL(string: "https://grantdavisinteractive.com/rss/test-silence-02.mp3")!
        let output = try await FFProbe.run(input: url, options: [
            .printFormat(.json),
            .showFormat,
            .showChapters,
            .hideBanner,
            .logLevel(.quiet)
        ])
        XCTAssertEqual("", output)
    }
}
