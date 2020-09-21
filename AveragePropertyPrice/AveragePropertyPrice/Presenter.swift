import Foundation
import UIKit

protocol PresenterInterface {
    func onViewDidLoad()
}

protocol PresenterOutputInterface: AnyObject {
    func showAverage(attributedString: NSAttributedString)
}

final class Presenter {
    private let interactor: InteractorInterface
    weak var view: PresenterOutputInterface?

    init(interactor: InteractorInterface) {
        self.interactor = interactor
    }
}

extension Presenter: PresenterInterface {
    func onViewDidLoad() {
        interactor.fetchAveragePropertyValue { [weak self] result in
            switch result {
            case .success(let averageValue):
                self?.updateViewOnTheMainThread(averageValue: averageValue)
            case .failure(_): break
            }
        }
    }
}

private extension Presenter {
    func updateViewOnTheMainThread(averageValue: Decimal) {
        DispatchQueue.main.async {
            self.view?.showAverage(attributedString: self.style(averageValue: averageValue))
        }
    }

    func style(averageValue: (Decimal)) -> NSAttributedString {
        var attributes = [NSAttributedString.Key: AnyObject]()
        attributes[.font] = UIFont.systemFont(ofSize: 14.0)
        attributes[.foregroundColor] = UIColor(named: "FontColor")
        
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        attributes[.paragraphStyle] = style

        return NSAttributedString(string: "\(averageValue)", attributes: attributes)
    }
}
