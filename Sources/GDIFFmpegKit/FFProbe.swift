//
//  FFMProbe.swift
//  GDI-ffmpeg
//
//  Created by Grant Davis on 1/21/22.
//

import Foundation
import ffmpegkit


/// Swift wrapper of ffprobe that aims to add the benefits of Swift, such as type checking and async/await support.
///
/// This does not include all options, and is strictly built to handle my current needs for interacting with ffprobe.
public struct FFProbe {

    public enum Option {
        case hideBanner
        case printFormat(PrintFormat)
        case showFormat
        case showChapters
        case showStreams
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

            case .showStreams:
                return "-show_streams"

            case .logLevel(let level):
                return "-loglevel \(level.rawValue)"
            }
        }
    }

    public enum ProbeError: LocalizedError {
        case invalidSession
        case commandFailed(ReturnCode)

        public var errorDescription: String? {
            switch self {
            case .invalidSession:
                return "A session could not created for the command."

            case .commandFailed(let returnCode):
                return "Command failed with return code: \(returnCode.getValue())"
            }
        }
    }

    /// Asynchronously executes a command to ffprobe.
    ///
    /// - Parameters:
    ///   - input: The URL to probe.
    ///   - options: The options provided to ffprobe.
    /// - Returns: The output generated from the ffprobe command.
    public static func run(input: URL, options: [Option]) async throws -> String {
        let json: String = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<String, Error>) in
            let command = command(input: input, options: options)

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

    /// Synchronously executes a command to ffprobe.
    ///
    /// - Parameters:
    ///   - input: The URL to probe.
    ///   - options: The options provided to ffprobe.
    /// - Returns: The output generated from the ffprobe command.
    public static func execute(input: URL, options: [Option]) throws -> String {
        let command = command(input: input, options: options)

        guard let session = FFprobeKit.execute(command) else {
            throw ProbeError.invalidSession
        }

        let returnCode: ReturnCode = session.getReturnCode()

        if returnCode.isValueSuccess(), let output = session.getOutput() {
            return output
        }
        else {
            throw ProbeError.commandFailed(returnCode)
        }
    }

    /// Generates an ffprobe command with a given input URL and options.
    ///
    /// - Parameters:
    ///   - input: The URL to probe.
    ///   - options: The options to provide to ffprobe.
    /// - Returns: A string defining the command for ffprobe combining the provided input and options.
    internal static func command(input: URL, options: [Option]) -> String {
        let inputCommand: String

        if input.isFileURL {
            inputCommand = "-i '\(input.path)'"
        }
        else {
            inputCommand = "-i " + input.absoluteString
        }

        var commandStrings = options.map { $0.string }
        commandStrings.append(inputCommand)

        let command = commandStrings.joined(separator: " ")
        return command
    }
}
