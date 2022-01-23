//
//  FFProbe+JSON.swift
//  
//
//  Created by Grant Davis on 1/22/22.
//

import Foundation


public extension FFProbe {

    enum JSONError: LocalizedError {
        case failedToGenerateDataFromOutput

        public var errorDescription: String? {
            switch self {
            case .failedToGenerateDataFromOutput:
                return "The JSON could not be generated because the output from ffprobe could not be converted to Data."
            }
        }
    }

    static let defaultDecoder: JSONDecoder = JSONDecoder()

    static func json<JSONObject: Decodable>(url: URL, options: [Option], decoder: JSONDecoder = defaultDecoder) throws -> JSONObject {
        var commandOptions: [Option] = [
            .printFormat(.json),
            .hideBanner,
            .logLevel(.quiet)
        ]
        commandOptions.append(contentsOf: options)

        let outputString = try FFProbe.execute(input: url, options: commandOptions)

        guard let outputData = outputString.data(using: .utf8) else {
            throw JSONError.failedToGenerateDataFromOutput
        }

        let output = try decoder.decode(JSONObject.self, from: outputData)
        return output
    }
}
