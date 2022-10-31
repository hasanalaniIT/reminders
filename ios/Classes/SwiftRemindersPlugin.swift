import Flutter

public class SwiftRemindersPlugin: NSObject, FlutterPlugin {

  let reminders = Reminders()

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "reminders", binaryMessenger: registrar.messenger())
    let instance = SwiftRemindersPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {

      case "getPlatformVersion":
        result("iOS " + UIDevice.current.systemVersion)

      case "hasAccess":
        result(self.reminders.hasAccess)

      case "getDefaultList":
        result(self.reminders.getDefaultList())

      case "getAllLists":
        result(self.reminders.getAllLists())

      case "getAllReminders":
        result(self.reminders.getAllReminders())

      case "getRemindersInList":
        if let args = call.arguments as? [String: String] {
          if let id = args["id"] {
            self.reminders.getRemindersInList(id) { (reminders) in 
              result(reminders)
            }
          }
        }

      case "createReminder":
        if let args = call.arguments as? [String: Any] {
          if let reminder = args["reminder"] as? [String: Any] {
            self.reminders.createReminder(reminder) { (error) in 
              result(error)
            }
          }
        }

      default:
        result(FlutterMethodNotImplemented)
    }
  }
}
