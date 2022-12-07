import Foundation

func run2() {
    useSampleInput = false
    print("2:")
    
    // Drop first: we start at / so we hardcoded it
    let historyEntries = input.split(separator: "\n$ ").dropFirst().map { parseHistoryEntry(String($0)) }
    
    let vm = VirtualMachine()
    vm.replayCommandHistory(historyEntries)
    
    let diskSize = 70000000
    let wantedFreeSpace = 30000000
    let usedSpace = vm.rootDirectory.computeTotalSize()
    let availableSpace = diskSize - usedSpace
    let needToFree = wantedFreeSpace - availableSpace
    print("used space: \(usedSpace), available space: \(availableSpace), need to free: \(needToFree)")
    
    var allDirSizes = [Int]()
    
    func reportDirectorySizes(_ directory: Directory) {
        allDirSizes.append(directory.computeTotalSize())
        directory.subdirectories.forEach(reportDirectorySizes(_:))
    }
    reportDirectorySizes(vm.rootDirectory)
    
    let eligibleFolders = allDirSizes.filter { $0 > needToFree }.sorted(by: <)
    let result = eligibleFolders.first!
    
    print("Result: \(result)")
    
    
    print("Done")
}
