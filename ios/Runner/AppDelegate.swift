import Flutter
import UIKit
import AppIntents

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}

@available(iOS 16.0, *)
struct AddExpenseIntent: AppIntent {
    static var title: LocalizedStringResource = "Add Expense"
    static var openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult {
        if let url = URL(string: "expenseflow://add-transaction?type=expense") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        return .result()
    }
}

@available(iOS 16.0, *)
struct AddIncomeIntent: AppIntent {
    static var title: LocalizedStringResource = "Add Income"
    static var openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult {
        if let url = URL(string: "expenseflow://add-transaction?type=income") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        return .result()
    }
}

@available(iOS 16.0, *)
struct AddTransferIntent: AppIntent {
    static var title: LocalizedStringResource = "Add Transfer"
    static var openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult {
        if let url = URL(string: "expenseflow://add-transaction?type=transfer") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        return .result()
    }
}

@available(iOS 16.0, *)
struct ExpenseFlowShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        return [
            AppShortcut(
                intent: AddExpenseIntent(),
                phrases: [
                    "Add expense in \(.applicationName)",
                    "New expense in \(.applicationName)"
                ],
                shortTitle: "Add Expense",
                systemImageName: "plus.circle"
            ),
            AppShortcut(
                intent: AddIncomeIntent(),
                phrases: [
                    "Add income in \(.applicationName)",
                    "New income in \(.applicationName)"
                ],
                shortTitle: "Add Income",
                systemImageName: "arrow.down.circle"
            ),
            AppShortcut(
                intent: AddTransferIntent(),
                phrases: [
                    "Add transfer in \(.applicationName)",
                    "New transfer in \(.applicationName)"
                ],
                shortTitle: "Add Transfer",
                systemImageName: "arrow.left.and.right.circle"
            )
        ]
    }
}
