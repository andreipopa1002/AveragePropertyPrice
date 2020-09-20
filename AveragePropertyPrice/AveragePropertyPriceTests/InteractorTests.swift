import XCTest
@testable import AveragePropertyPrice

final class InteractorTests: XCTestCase {
    private var interactor: Interactor!
    private var mockedService: MockService!

    override func setUpWithError() throws {
        mockedService = MockService()
        interactor = Interactor(service: mockedService)
    }

    override func tearDownWithError() throws {
        mockedService = nil
        interactor = nil
    }

    func test_GivenServiceSuccess_EmptyProperties_WhenFetchAveragePropertyValue_Then0() {
        var capturedAverage: Decimal?

        interactor.fetchAveragePropertyValue { result in
            if case .success(let average) = result {
                capturedAverage = average
            }
        }
        mockedService.spyCompletion?(.success([]))

        XCTAssertEqual(capturedAverage, Decimal.zero)
    }

    func test_GivenServiceSuccess_3Properties_WhenFetchAveragePropertyValue_ThenAverage() {
        var capturedAverage: Decimal = Decimal(-100)

        interactor.fetchAveragePropertyValue { result in
            if case .success(let average) = result {
                capturedAverage = average
            }
        }
        mockedService.spyCompletion?(.success(
                                        [Property(price: 1),
                                         Property(price: 4),
                                         Property(price: 2)]
                                    )
        )

        let expectedAverage = Decimal(7) / Decimal(3)
        XCTAssertEqual(capturedAverage, Decimal(7) / Decimal(3))
    }

}

private class MockService: PropertyServiceInterface {
    private(set) var spyCompletion: ((Result<[Property], Error>) -> ())?

    func fetchProperties(completion: @escaping ((Result<[Property], Error>) -> ())) {
        spyCompletion = completion
    }
}
