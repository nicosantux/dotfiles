import Foundation

/// Runs blueutil as a child process so macOS attributes its Bluetooth access to this app.
/// Prints the exit status on the first line, followed by blueutil's stdout. Exit codes do not
/// survive the LaunchServices round trip, so the status is reported on stdout instead.
let candidates = ["/opt/homebrew/bin/blueutil", "/usr/local/bin/blueutil"]

func report(_ status: Int32, _ output: Data = Data()) -> Never {
  FileHandle.standardOutput.write(Data("\(status)\n".utf8) + output)
  exit(0)
}

guard let blueutil = candidates.first(where: FileManager.default.isExecutableFile(atPath:)) else {
  report(127)
}

let output = Pipe()
let process = Process()
process.executableURL = URL(fileURLWithPath: blueutil)
process.arguments = Array(CommandLine.arguments.dropFirst())
process.standardOutput = output

do {
  try process.run()
} catch {
  report(126)
}

let data = output.fileHandleForReading.readDataToEndOfFile()
process.waitUntilExit()

report(process.terminationStatus, data)
