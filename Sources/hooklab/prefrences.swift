import Foundation
import Vapor

#if os(Linux)
  let platform = "linux"
#elseif os(MacOS)
  let platform = "macos"
#elseif os(Windows)
  let platform = "windows"
#else
  let platform = "unknown"
#endif

func getXDGConfigDir() -> URL {
  let homeDir = FileManager.default.homeDirectoryForCurrentUser

  if let xdgConfigHome = ProcessInfo.processInfo.environment["XDG_CONFIG_HOME"],
    !xdgConfigHome.isEmpty
  {
    return URL(fileURLWithPath: xdgConfigHome, isDirectory: true)
  } else {
    return homeDir.appendingPathComponent(".config", isDirectory: true)
  }
}

func getAppSupportDir() -> URL {
  let paths = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
  if let supportPath = paths.first {
    return supportPath
  }
  return getXDGConfigDir()
}

public func prefrencesPath(_ app: Application) -> URL {
  let confDir =
    switch platform {
    case "linux":
      getXDGConfigDir()
    case "macos":
      getAppSupportDir()
    case "windows":
      getAppSupportDir()
    default:
      getXDGConfigDir()
    }

  if let overridePath = ProcessInfo.processInfo.environment["VAPOR_DB_PATH"] {
    app.logger.info("Overriding settings path \(overridePath)")
    return URL(fileURLWithPath: overridePath, isDirectory: true)
  }

  app.logger.info("settings path \(confDir)")

  return confDir
}
