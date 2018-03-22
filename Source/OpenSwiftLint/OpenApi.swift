//
//  OpenApi.swift
//  swiftlint
//
//  Created by Łukasz Szpyrka on 21/03/2018.
//  Copyright © 2018 Realm. All rights reserved.
//

import Foundation
import Commandant
import swiftlint

public struct OpenApi {

    public init () {

    }

    public func run() {

        let lc = LintCommand()
        let arguments: ArgumentParser = ArgumentParser.init(["-- benchmark"])
        let lintOption = LintOptions.evaluate(.arguments(arguments))
        let command =  try? lc.run(lintOption.dematerialize())
        print("did finish")
        do {
            try command?.dematerialize()
        } catch {
            print("error done")
        }

    }
}
