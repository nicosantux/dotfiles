import CoreLocation
import CoreWLAN
import Foundation

func fail(_ message: String) -> Never {
  FileHandle.standardError.write(Data((message + "\n").utf8))
  exit(1)
}

final class AuthorizationWaiter: NSObject, CLLocationManagerDelegate {
  private let manager = CLLocationManager()
  private var done = false

  func run() {
    manager.delegate = self
    if manager.authorizationStatus == .notDetermined {
      manager.requestWhenInUseAuthorization()
    }

    let deadline = Date().addingTimeInterval(120)
    while !done && Date() < deadline {
      RunLoop.main.run(until: Date().addingTimeInterval(0.2))
    }
  }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    if manager.authorizationStatus != .notDetermined {
      done = true
    }
  }
}

func scan(_ interface: CWInterface) {
  let networks: Set<CWNetwork>
  do {
    networks = try interface.scanForNetworks(withName: nil)
  } catch {
    fail("Scan failed: \(error.localizedDescription)")
  }

  let profiles = interface.configuration()?.networkProfiles.array as? [CWNetworkProfile] ?? []
  let knownSSIDs = Set(profiles.compactMap(\.ssid))
  let currentSSID = interface.ssid()

  var strongest: [String: CWNetwork] = [:]
  for network in networks {
    guard let ssid = network.ssid, !ssid.isEmpty else { continue }
    if let existing = strongest[ssid], existing.rssiValue >= network.rssiValue { continue }
    strongest[ssid] = network
  }

  for network in strongest.values.sorted(by: { $0.rssiValue > $1.rssiValue }) {
    let ssid = network.ssid!
    let security = network.supportsSecurity(.none) ? "open" : "secure"
    let known = knownSSIDs.contains(ssid) ? 1 : 0
    let current = ssid == currentSSID ? 1 : 0
    print([ssid, String(network.rssiValue), security, String(known), String(current)].joined(separator: "\t"))
  }
}

/// Prints `joined`, `password_required` or `failed: <reason>`. Exit codes do not survive
/// the LaunchServices round trip, so the result is reported on stdout instead.
func connect(_ interface: CWInterface, ssid: String, readPassword: Bool) {
  guard
    let candidates = try? interface.scanForNetworks(withName: ssid),
    let network = candidates.max(by: { $0.rssiValue < $1.rssiValue })
  else {
    print("failed: network not found")
    return
  }

  let isOpen = network.supportsSecurity(.none)
  var password = readPassword ? readLine(strippingNewline: true) : nil

  if password == nil, !isOpen {
    var stored: NSString?
    guard
      let ssidData = network.ssidData,
      CWKeychainFindWiFiPassword(.system, ssidData, &stored) == errSecSuccess
    else {
      print("password_required")
      return
    }
    password = stored as String?
  }

  do {
    try interface.associate(to: network, password: password)
    print("joined")
  } catch {
    print(isOpen ? "failed: \(error.localizedDescription)" : "password_required")
  }
}

let usage = """
  Usage:
    wifi-helper                                 request Location access
    wifi-helper current                         print the current SSID
    wifi-helper scan                            print ssid, rssi, open|secure, known, current (tab separated)
    wifi-helper connect <ssid> [--password-stdin]
  """

let arguments = Array(CommandLine.arguments.dropFirst())

guard let command = arguments.first else {
  let waiter = AuthorizationWaiter()
  waiter.run()
  exit(0)
}

guard let interface = CWWiFiClient.shared().interface() else {
  fail("No Wi-Fi interface found")
}

switch command {
case "current":
  print(interface.ssid() ?? "")
case "scan":
  scan(interface)
case "connect" where arguments.count >= 2:
  connect(interface, ssid: arguments[1], readPassword: arguments.contains("--password-stdin"))
default:
  fail(usage)
}
