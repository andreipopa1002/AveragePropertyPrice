import XCTest
@testable import AveragePropertyPrice

final class PresenterTests: XCTestCase {
    private var presenter: Presenter!
    private var mockedInteractor: MockInteractor!
    private var mockedPresenterOutput: MockPresenterOutput!

    override func setUpWithError() throws {
        mockedInteractor = MockInteractor()
        presenter = Presenter(interactor: mockedInteractor)
        mockedPresenterOutput = MockPresenterOutput()
        presenter.view = mockedPresenterOutput
    }

    override func tearDownWithError() throws {
        mockedInteractor = nil
        mockedPresenterOutput = nil
        presenter = nil
    }

    func test_ViewIsWeak() {
        var view: MockPresenterOutput? = MockPresenterOutput()
        presenter.view = view
        view = nil
        XCTAssertNil(presenter.view)
    }

    func test_WhenOnViewDidLoad_ThenInteractorFetchAveragePropertyValue() {
        presenter.onViewDidLoad()
        XCTAssertEqual(mockedInteractor.callCount, 1)
    }

    func test_GivenInteractorSuccess_WhenShowAverage_ThenStringIsDecimalFromInteractor() {
        mockedPresenterOutput.expectation = expectation(description: "main thread")
        presenter.onViewDidLoad()
        mockedInteractor.spyCompletion?(.success(Decimal.zero))

        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertEqual(self.mockedPresenterOutput.spyAverage.map {$0.string}, ["0"])
        }
    }

    func test_GivenInteractorSuccess_WhenShowAverage_ThenStringHasFontSize() {
        mockedPresenterOutput.expectation = expectation(description: "main thread")
        presenter.onViewDidLoad()
        mockedInteractor.spyCompletion?(.success(Decimal.zero))

        waitForExpectations(timeout: 0.1) { _ in
            let attributes = self.mockedPresenterOutput.spyAverage.map{
                $0.attributes(at: 0, effectiveRange: nil)
            }
            XCTAssertEqual(
                attributes.compactMap{$0[NSAttributedString.Key.font]} as? [UIFont],
                [UIFont.systemFont(ofSize: 14.0)]
            )
        }
    }

    func test_GivenInteractorSuccess_WhenShowAverage_ThenStringHasForegroungColor() {
        mockedPresenterOutput.expectation = expectation(description: "main thread")
        presenter.onViewDidLoad()
        mockedInteractor.spyCompletion?(.success(Decimal.zero))

        waitForExpectations(timeout: 0.1) { _ in
            let attributes = self.mockedPresenterOutput.spyAverage.map{
                $0.attributes(at: 0, effectiveRange: nil)
            }
            let colors = attributes.compactMap{$0[NSAttributedString.Key.foregroundColor]} as? [UIColor]
            colors?.forEach {
                XCTAssertTrue(
                    $0.isEqualTo(UIColor(named: "FontColor")!)
                )
            }
        }
    }

    func test_GivenInteractorSuccess_WhenShowAverage_ThenStringHasStyle() {
        mockedPresenterOutput.expectation = expectation(description: "main thread")
        presenter.onViewDidLoad()
        mockedInteractor.spyCompletion?(.success(Decimal.zero))

        waitForExpectations(timeout: 0.1) { _ in
            let attributes = self.mockedPresenterOutput.spyAverage.map{
                $0.attributes(at: 0, effectiveRange: nil)
            }
            let paragraphs = attributes.compactMap{$0[NSAttributedString.Key.paragraphStyle]} as? [NSMutableParagraphStyle]
            paragraphs?.forEach {
                XCTAssertEqual($0.alignment, .center)
            }
        }
    }

}

private class MockInteractor: InteractorInterface {
    private(set) var callCount = 0
    private(set) var spyCompletion: ((Result<Decimal, Error>) -> ())?

    func fetchAveragePropertyValue(completion: @escaping (Result<Decimal, Error>) -> ()) {
        callCount += 1
        spyCompletion = completion
    }
}

private class MockPresenterOutput: PresenterOutputInterface {
    var expectation: XCTestExpectation?
    private(set) var spyAverage = [NSAttributedString]()

    func showAverage(attributedString: NSAttributedString) {
        spyAverage.append(attributedString)
        expectation?.fulfill()
    }
}

extension UIColor {
    func isEqualTo(_ color: UIColor) -> Bool {
        var red1: CGFloat = 0, green1: CGFloat = 0, blue1: CGFloat = 0, alpha1: CGFloat = 0
        getRed(&red1, green:&green1, blue:&blue1, alpha:&alpha1)

        var red2: CGFloat = 0, green2: CGFloat = 0, blue2: CGFloat = 0, alpha2: CGFloat = 0
        color.getRed(&red2, green:&green2, blue:&blue2, alpha:&alpha2)

        return red1 == red2 && green1 == green2 && blue1 == blue2 && alpha1 == alpha2
    }
}
