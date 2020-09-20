import UIKit

protocol ViewInterface {
}

class ViewController: UIViewController {
    var presenter: PresenterInterface?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension ViewController: ViewInterface { }


