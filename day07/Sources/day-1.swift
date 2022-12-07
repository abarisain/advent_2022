import Foundation

enum Command {
    case ls(results: [String])
    case cd(path: String)
}

struct File {
    let name: String
    let size: Int
}

class Directory {
    let parent: Directory?
    let name: String
    var subdirectories: [Directory]
    var files: [File]
    
    init(name: String, parent: Directory?) {
        self.parent = parent
        self.name = name
        self.subdirectories = []
        self.files = []
    }
    
    func updateFromLs(_ directoryEntries: [String]) {
        for entry in directoryEntries {
            let split = entry.split(separator: " ").map { String($0) }
            if split[0] == "dir" {
                let dirname = split[1]
                if findSubdirectory(name: dirname) == nil {
                    subdirectories.append(Directory(name: dirname, parent: self))
                }
            } else {
                let filename = split[1]
                // Updating files isn't supported yet
                if findFile(name: filename) == nil {
                    files.append(File(name: filename, size: Int(split[0])!))
                }
            }
        }
    }
    
    func findSubdirectory(name: String) -> Directory? {
        return subdirectories.first(where: { $0.name == name })
    }
    
    func findFile(name: String) -> File? {
        return files.first(where: { $0.name == name })
    }
    
    func computeTotalSize() -> Int {
        let subdirectorySizes = subdirectories.map { $0.computeTotalSize() }.reduce(0, +)
        let fileSizes = files.map { $0.size }.reduce(0, +)
        
        return subdirectorySizes + fileSizes
    }
}

//fatalError("Trying to move into an non existent subdirectory: should we lazily create it?")

class VirtualMachine {
    var rootDirectory: Directory
    var currentPath: [Directory]
    
    init() {
        self.rootDirectory = Directory(name: "", parent: nil)
        self.currentPath = [rootDirectory]
    }
    
    func replayCommandHistory(_ commands: [Command]) {
        for command in commands {
            switch command {
                case let .cd(path):
                    changedir(to: path)
                case let .ls(directoryEntries):
                    updateCurrentDirectory(directoryEntries: directoryEntries)
            }
        }
    }
    
    func changedir(to: String) {
        defer {
            print("Changing directory: \(currentPathString)")
        }
        
        if to == "/" {
            self.currentPath = [rootDirectory]
            return
        }
        
        if to == ".." {
            self.currentPath.removeLast()
            return
        }
        
        let targetDir = currentPath.last!.findSubdirectory(name: to)
        
        guard let targetDir else {
            fatalError("Could not find subdirectory \(to)")
        }
        
        self.currentPath.append(targetDir)
    }
    
    func updateCurrentDirectory(directoryEntries: [String]) {
        currentPath.last?.updateFromLs(directoryEntries)
    }
    
    var currentPathString: String {
        return "/\(currentPath.dropFirst().map { $0.name }.joined(separator: "/"))"
    }
}

func parseHistoryEntry(_ rawHistoryEntry: String) -> Command {
    let split = rawHistoryEntry.split(separator: "\n").map { String($0) }
    let rawCommand = split[0]
    
    if rawCommand.starts(with: "ls") {
        return Command.ls(results: Array(split.dropFirst()))
    }
    
    if rawCommand.starts(with: "cd ") {
        return Command.cd(path: String(rawCommand.split(separator: " ")[1]))
    }
    
    fatalError("Unknown command: \(rawCommand)")
}

func run1() {
    useSampleInput = false
    print("1:")
    
    // Drop first: we start at / so we hardcoded it
    let historyEntries = input.split(separator: "\n$ ").dropFirst().map { parseHistoryEntry(String($0)) }
    
    let vm = VirtualMachine()
    vm.replayCommandHistory(historyEntries)
    
    
    let totalSize = vm.rootDirectory.computeTotalSize()
    
    print("Total size: \(totalSize)")
    
    var allDirSizes = [Int]()
    
    func reportDirectorySizes(_ directory: Directory) {
        allDirSizes.append(directory.computeTotalSize())
        directory.subdirectories.forEach(reportDirectorySizes(_:))
    }
    reportDirectorySizes(vm.rootDirectory)
    
    let result = allDirSizes.filter { $0 <= 100000 }.reduce(0, +)
    
    print("Result: \(result)")
    
    print("Done")
}
