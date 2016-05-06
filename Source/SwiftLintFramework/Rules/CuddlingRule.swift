//
//  CuddlingRule.swift
//  SwiftLint
//
//  Created by Chris Dillard on 3/24/16.
//  Copyright © 2016 Realm. All rights reserved.
//

import Foundation
import SourceKittenFramework

public struct CuddlingRule: CorrectableRule, ConfigurationProviderRule {

    public var configuration = SeverityConfiguration(.Warning)

    public init() {}

    public static let description = RuleDescription(
        identifier: "no_cuddling",
        name: "No Cuddling",
        description: " " +
        "No Cuddled else or catch",
        triggeringExamples: [
            "} else if {",
            "} else {",
            "} catch {",
            "\"}else{\"",
            "struct A { let catchphrase: Int }\nlet a = A(\n catchphrase: 0\n)",
            "struct A { let `catch`: Int }\nlet a = A(\n `catch`: 0\n)"
        ],
        nonTriggeringExamples : [
            "↓}else if {",
            "↓}  else {",
            "↓}\ncatch {",
            "↓}\n\t  catch {"
        ],
        corrections: [
            "}\n else {\n": "} else {\n",
            "} else if {\n": "}\n   else if {\n",
            "} catch {\n": "}\n catch {\n",
        ]
    )

    public func validateFile(file: File) -> [StyleViolation] {
        return violationRangesInFile(file, withPattern: pattern).flatMap { range in
            return StyleViolation(ruleDescription: self.dynamicType.description,
                severity: configuration.severity,
                location: Location(file: file, characterOffset: range.location))
        }
    }

    public func correctFile(file: File) -> [Correction] {
        let matches = violationRangesInFile(file, withPattern: pattern)
        guard !matches.isEmpty else { return [] }

        let regularExpression = regex(pattern)
        let description = self.dynamicType.description
        var corrections = [Correction]()
        var contents = file.contents
        for range in matches.reverse() {
            let violator = (contents as NSString).substringWithRange(range) as String
            let leadingSpaces = violator.leadingWhitespace()
            let isElseIf = violator.containsString("else if")
            contents = regularExpression.stringByReplacingMatchesInString(contents,
                                                                          options: [], range: range, withTemplate: "\(leadingSpaces)}\n\(leadingSpaces)$1 \(isElseIf ? "" : "{")")
            let location = Location(file: file, characterOffset: range.location)
            corrections.append(Correction(ruleDescription: description, location: location))
        }
        file.write(contents)

        return corrections
    }

    // MARK: - Private

    private let pattern = "(?:[ ]*)\\}(?:[^\\n]*|[ ]*)\\b(else|catch|else\\sif)\\b(?:[ ]*)\\b((?:[ ]*)|\\{)"

    private func violationRangesInFile(file: File, withPattern pattern: String) -> [NSRange] {
        return file.matchPattern(pattern).filter { range, syntaxKinds in
            return syntaxKinds.startsWith([.Keyword])
            }.flatMap { $0.0 }
    }
}

extension String {

    private func leadingCharactersInSet(characterSet: NSCharacterSet) -> String {
        var count = 0
        for char in utf16.lazy {
            if !characterSet.characterIsMember(char) {
                break
            }

            count += 1
        }
        let char = Character(" ")
        let string = String(count: count, repeatedValue: char)

        return string
    }

    private func leadingWhitespace() -> String {
        return leadingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
}
