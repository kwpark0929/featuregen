import Foundation

let args = CommandLine.arguments
guard args.count > 1 else {
    print("❌ Feature 이름을 입력하세요. 예: featuregen LoginFeature")
    exit(1)
}

let feature = args[1]
let featurePath = "Features/\(feature)/"

try? FileManager.default.createDirectory(atPath: featurePath, withIntermediateDirectories: true)
let viewFile = featurePath + "\(feature)View.swift"
let viewContent = """
import SwiftUI

struct \(feature)View: View {
    var body: some View {
        Text("Hello, \(feature)!")
    }
}
"""
try? viewContent.write(toFile: viewFile, atomically: true, encoding: .utf8)

print("✅ \(feature) 생성 완료!")
