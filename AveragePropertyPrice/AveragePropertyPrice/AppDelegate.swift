import UIKit
import NetworkingS

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let client = ClientFactory(session: URLSession.shared).networkService()
        let service = PropertyService(client: client, decoder: JSONDecoder())
        let interactor = Interactor(service: service)
        let presenter = Presenter(interactor: interactor)
        viewController.presenter = presenter
        presenter.view = viewController
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        return true
    }
}

