import UIKit

class ViewController: UIViewController {
    var presenter: PresenterInterface?
    @IBOutlet var responseLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.onViewDidLoad()
    }
}

extension ViewController: PresenterOutput {
    func showAverage(attributedString: NSAttributedString) {
        responseLabel.attributedText = attributedString
    }
}


