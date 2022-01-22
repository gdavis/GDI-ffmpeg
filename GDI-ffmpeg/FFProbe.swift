//
//  FFMProbe.swift
//  GDI-ffmpeg
//
//  Created by Grant Davis on 1/21/22.
//

import Foundation
import ffmpegkit

// ffprobe https://rss.art19.com/episodes/6dc9aa36-830d-49f3-83a4-5e60957d780d.mp3 -hide_banner -print_format json -show_format -v panic -show_chapters
public struct FFProbe {

    public enum Option {
        case hideBanner
        case printFormat(PrintFormat)
        case showFormat
        case showChapters
        case logLevel(LogLevel)

        public enum PrintFormat: String {
            case json, csv, flat, ini, xml
        }

        public enum LogLevel: String {
            case quiet, panic, fatal, error, warning, info, verbose, debug, trace
        }

        var string: String {
            switch self {
            case .hideBanner:
                return "-hide_banner"

            case .printFormat(let format):
                return "-print_format \(format.rawValue)"

            case .showFormat:
                return "-show_format"

            case .showChapters:
                return "-show_chapters"

            case .logLevel(let level):
                return "-loglevel \(level.rawValue)"
            }
        }
    }

    public enum ProbeError: Error {
        case invalidSession
        case commandFailed(ReturnCode)
    }


    public static func run(input: URL, options: [Option]) async throws -> String {

        let json: String = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<String, Error>) in
            let inputCommand = "-i " + input.absoluteString

            var commandStrings = options.map { $0.string }
            commandStrings.append(inputCommand)

            let command = commandStrings.joined(separator: " ")

            FFprobeKit.executeAsync(command) { session in
                guard let session = session else {
                    continuation.resume(throwing: ProbeError.invalidSession)
                    return
                }

                let returnCode: ReturnCode = session.getReturnCode()

                if returnCode.isValueSuccess(), let output = session.getOutput() {
                    continuation.resume(returning: output)
                }
                else {
                    continuation.resume(throwing: ProbeError.commandFailed(returnCode))
                }
            }
        }

        return json
    }
}
