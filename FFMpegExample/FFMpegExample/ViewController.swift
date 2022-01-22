//
//  ViewController.swift
//  FFMpegExample
//
//  Created by Grant Davis on 1/22/22.
//

import UIKit
import GDIFFmpegKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        Task {
            let url = URL(string: "https://auphonic.com/media/blog/auphonic_chapters_demo.mp3")!

            do {
                let output = try await FFProbe.run(input: url, options: [
                    .printFormat(.json),
                    .showFormat,
                    .showChapters,
                    .hideBanner,
                    .logLevel(.quiet)
                ])

                print(output)
            }
            catch {
                print("Failed to probe with error: " + error.localizedDescription)
            }
        }
    }
}

