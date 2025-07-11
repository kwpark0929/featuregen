import Foundation

func getAuthorName() -> String {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/git")
    process.arguments = ["config", "user.name"]

    let pipe = Pipe()
    process.standardOutput = pipe
    try? process.run()
    process.waitUntilExit()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    return String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "AUTHOR"
}

func getCurrentDate() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
    return formatter.string(from: Date())
}

func getProjectName() -> String {
    let currentPath = FileManager.default.currentDirectoryPath
    if let items = try? FileManager.default.contentsOfDirectory(atPath: currentPath) {
        if let xcodeproj = items.first(where: { $0.hasSuffix(".xcodeproj") }) {
            return xcodeproj.replacingOccurrences(of: ".xcodeproj", with: "")
        }
    }
    return "PROJECT_NAME"
}

func replacePlaceholders(in filePath: String, featureName: String) -> String? {
    guard let content = try? String(contentsOfFile: filePath) else { return nil }

    let author = getAuthorName()
    let date = getCurrentDate()
    let project = getProjectName()

    return content
        .replacingOccurrences(of: "SampleFeature", with: featureName)
        .replacingOccurrences(of: "SampleView", with: "\(featureName)View")
        .replacingOccurrences(of: "SampleState", with: "\(featureName)State")
        .replacingOccurrences(of: "SampleReducer", with: "\(featureName)Reducer")
        .replacingOccurrences(of: "SampleAction", with: "\(featureName)Action")
        .replacingOccurrences(of: "AUTHOR", with: author)
        .replacingOccurrences(of: "DATE", with: date)
        .replacingOccurrences(of: "PROJECT_NAME", with: project)
}

func copyAndReplaceTemplateFiles(from templateDir: String, to destinationDir: String, featureName: String) {
    let fileNames = ["SampleAction.txt", "SampleReducer.txt", "SampleState.txt", "SampleView.txt"]
    for fileName in fileNames {
        let templatePath = "\(templateDir)/\(fileName)"
        guard let newContent = replacePlaceholders(in: templatePath, featureName: featureName) else { continue }

        var newFileName = fileName.replacingOccurrences(of: "Sample", with: featureName)
        newFileName = fileName.replacingOccurrences(of: "txt", with: "swift")
        
        let newFilePath = "\(destinationDir)/\(newFileName)"
        try? newContent.write(toFile: newFilePath, atomically: true, encoding: .utf8)
    }
}

let args = CommandLine.arguments
guard args.count > 1 else {
    print("❌ Feature 이름을 입력하세요. 예: featuregen LoginFeature")
    exit(1)
}

let feature = args[1]
let currentPath = FileManager.default.currentDirectoryPath
let templateDir = "\(currentPath)/Sources/SampleFeature"
let featurePath = "\(currentPath)/Features/\(feature)"

try? FileManager.default.createDirectory(atPath: featurePath, withIntermediateDirectories: true)
copyAndReplaceTemplateFiles(from: templateDir, to: featurePath, featureName: feature)

print("✅ \(feature) 생성 완료!")
