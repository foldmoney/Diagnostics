//
//  LogsTrimmer.swift
//
//
//  Created by Sabesh Bharathi on 13/06/24.
//

import Foundation

struct LogsTrimmer {
    let numberOfLinesToTrim: Int

    func trim(data: inout Data) {
        guard let logs = String(data: data, encoding: .utf8) else {
            return
        }

        // Define the regular expression pattern
        let pattern = "<p class=\"system\"><span class=\"log-date\">(.*?)</span></p>"

        // Create a regular expression object
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return
        }

        // Find all matches in the input string
        let matches = regex
            .matches(
                in: logs,
                range: NSRange(location: 0, length: logs.utf16.count)
            )
            .prefix(numberOfLinesToTrim)

        guard let firstMatch = matches.first, let lastMatch = matches.last else {
            return
        }

        let range = NSRange(
            location: firstMatch.range.location,
            length: lastMatch.range.upperBound - firstMatch.range.location
        )
        guard let range = Range(range, in: logs) else {
            return
        }

        let trimmedLogs = logs.replacingCharacters(in: range, with: "")
        data = Data(trimmedLogs.utf8)
    }
}
