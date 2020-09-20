import Foundation
import UIKit

protocol PresenterInterface {
    func onViewDidLoad()
}

protocol PresenterOutput: AnyObject {
    func showAverage(attributedString: NSAttributedString)
}

final class Presenter {
    private let interactor: InteractorInterface
    weak var view: PresenterOutput?

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
        attributes[.foregroundColor] = #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.2156862745, alpha: 1)
        
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        attributes[.paragraphStyle] = style

        return NSAttributedString(string: "\(averageValue)", attributes: attributes)
    }
}
