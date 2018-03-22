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
import SwiftLintFramework

public struct OpenApi {

    public init () {

    }

    public func run() {

        let lc = LintCommand()
        /*let benchmarkOption = Option(key: "benchmark", defaultValue: false,
                                usage: "save benchmarks to benchmark_files.txt " +
            "and benchmark_rules.txt")*/
        let arguments: ArgumentParser = ArgumentParser.init(["-- benchmark"])
        let lintOption = LintOptions.evaluate(.arguments(arguments))
        let command =  try? lc.run(lintOption.dematerialize())
        print("did finish")
        do {
            try print(command?.dematerialize() ?? " something wrong ")

        } catch {
//            print("exceptionn: \(exception)())")
            print("error done")
        }
       /*
        let registry = CommandRegistry<CommandantError<()>>()
            registry.register(LintCommand())

        //registry.register(command)
        registry.main(defaultVerb: LintCommand().verb) { error in
            print("error here: \(error)")
               queuedPrintError(String(describing: error))
        }*/
    }
}
