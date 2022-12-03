//
//  File.swift
//  
//
//  Created by Arnaud Barisain-Monrose on 02/12/2022.
//

import Foundation

func makeSourceDataURL() -> URL {
    let sourcePath = #file
    let rootDir = sourcePath.split(separator: "/Sources")[0]
    let path = "file://\(rootDir)/input.txt"
    return URL(string: path)!
}

func getChallengeInput() -> String {
    return try! String(contentsOf: makeSourceDataURL(), encoding: .utf8)
}

let input = getChallengeInput()
