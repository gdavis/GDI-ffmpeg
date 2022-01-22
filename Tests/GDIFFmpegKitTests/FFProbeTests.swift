//
//  FFProbeTests.swift
//  GDIFFmpegKitTests
//
//  Created by Grant Davis on 1/21/22.
//

import XCTest
@testable import GDIFFmpegKit

class FFProbeTests: XCTestCase {

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
