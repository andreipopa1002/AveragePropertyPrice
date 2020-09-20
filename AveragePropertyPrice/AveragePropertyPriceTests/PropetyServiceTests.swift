import XCTest
@testable import AveragePropertyPrice
import NetworkingS

final class PropetyServiceTests: XCTestCase {
    private var service: PropertyService!
    private var mockedClient: MockClient!

    override func setUpWithError() throws {
        mockedClient = MockClient()
        service = PropertyService(client: mockedClient)
    }

    override func tearDownWithError() throws {
        mockedClient = nil
        service = nil
    }

    func test_WhenFetchProperties_ThenClientFetchRequest() {
        service.fetchProperties(completion: {_ in})
        let expectedAbsoluteUrl = URL(
            string: "https://raw.githubusercontent.com/rightmove/Code-Challenge-iOS/master/properties.json"
        )!

        XCTAssertEqual(
            mockedClient.spyFetchRequest.map {$0.url?.absoluteURL},
            [expectedAbsoluteUrl]
        )
    }

    func test_GivenClientSuccess_nilModel_WhenFetchProperties_ThenSuccessPropertiesEmpty() {
        var capturedProperties: [Property]?

        service.fetchProperties { result in
            if case .success(let properties) = result {
                capturedProperties = properties
            }
        }
        mockedClient.spyCompletion?(.success((model: nil, response: nil)))

        XCTAssertEqual(capturedProperties, [])
    }

    func testGivenClientSuccess_withModel_WhenFetchProperties_ThenSuccessSameProperties() {
        var capturedProperties: [Property]?

        service.fetchProperties { result in
            if case .success(let properties) = result {
                capturedProperties = properties
            }
        }
        mockedClient.spyCompletion?(.success((model: [Property(price: 0), Property(price: 2)], response: nil)))

        XCTAssertEqual(
            capturedProperties,
            [Property(price: 0), Property(price: 2)]
        )
    }

    func test_GivenClientFailureAnyError_WhenFetchProperties_ThenFailure() {
        var capturedError: Error?

        service.fetchProperties { result in
            if case .failure(let error) = result {
                capturedError = error
            }
        }
        mockedClient.spyCompletion?(.failure(AuthorizedServiceError.unauthorized))

        XCTAssertNotNil(capturedError)
    }
}

private class MockClient: DecodingServiceInterface {
    private(set) var spyFetchRequest = [URLRequest]()
    private var completion: Any?

    func fetch<DecodableModel>(request: URLRequest, completion: @escaping DecodingServiceCompletion<DecodableModel>) where DecodableModel : Decodable {
        spyFetchRequest.append(request)
        self.completion = completion
    }

    var spyCompletion: DecodingServiceCompletion<[Property]>? {
        return completion as? DecodingServiceCompletion<[Property]>
    }
}
