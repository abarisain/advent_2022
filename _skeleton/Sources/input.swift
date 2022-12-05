//
//  File.swift
//  
//
//  Created by Arnaud Barisain-Monrose on 02/12/2022.
//

import Foundation

var useSampleInput = false

func makeSourceDataURL() -> URL {
    let sourcePath = #file
    let rootDir = sourcePath.split(separator: "/Sources")[0]
    let inputFile = useSampleInput ? "sample_input.txt" : "input.txt"
    let path = "file://\(rootDir)/\(inputFile)"
    return URL(string: path)!
}

func getChallengeInput() -> String {
    return try! String(contentsOf: makeSourceDataURL(), encoding: .utf8)
}

let input = getChallengeInput()
