import RealmSwift
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let realmURL = Realm.Configuration.defaultConfiguration.fileURL
        print("Realm file path: \(realmURL?.absoluteString ?? "Not available")")

        let config = Realm.Configuration(
            schemaVersion: 6,
            migrationBlock: { _, oldSchemaVersion in
                if oldSchemaVersion < 6 {}
            }
        )

        Realm.Configuration.defaultConfiguration = config

        do {
            let realm = try Realm()

            realm.beginWrite()

            try realm.commitWrite()
        } catch {
            print("Error initializing Realm: \(error)")
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}
