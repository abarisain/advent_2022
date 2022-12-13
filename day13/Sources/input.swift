//
//  File.swift
//  
//
//  Created by Arnaud Barisain-Monrose on 02/12/2022.
//

import Foundation

var useSampleInput = false {
    didSet {
        input = getChallengeInput()
    }
}

func makeSourceDataURL() -> URL {
    let sourcePath = #file
    let rootDir = sourcePath.split(separator: "Sources")[0]
    let inputFile = useSampleInput ? "sample_input.txt" : "input.txt"
    let path = "\(rootDir)/\(inputFile)"
    return URL(fileURLWithPath: path)
}

func getChallengeInput() -> String {
    return try! String(contentsOf: makeSourceDataURL(), encoding: .utf8)
}

var input = getChallengeInput()
