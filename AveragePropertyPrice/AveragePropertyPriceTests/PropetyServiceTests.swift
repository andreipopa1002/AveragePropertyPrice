import XCTest
@testable import AveragePropertyPrice
import NetworkingS

final class PropetyServiceTests: XCTestCase {
    private var service: PropertyService!
    private var mockedClient: MockClient!
    private var mockedDecoder: MockDecoder!

    override func setUpWithError() throws {
        mockedClient = MockClient()
        mockedDecoder = MockDecoder()
        service = PropertyService(client: mockedClient, decoder: mockedDecoder)
    }

    override func tearDownWithError() throws {
        mockedClient = nil
        mockedDecoder = nil
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

    func test_GivenClientSuccess_nilData_WhenFetchProperties_ThenSuccessPropertiesEmpty() {
        var capturedProperties: [Property]?

        service.fetchProperties { result in
            if case .success(let properties) = result {
                capturedProperties = properties
            }
        }
        mockedClient.spyCompletion?(.success((data: nil, response: nil)))

        XCTAssertEqual(capturedProperties, [])
    }

    func test_GivenClientSuccess_withData_WhenFetchProperties_ThenDecoderReceivesData() {
        service.fetchProperties { result in }
        let stubbedData = Data()
        mockedClient.spyCompletion?(.success((data: stubbedData, response: nil)))

        XCTAssertEqual(
            mockedDecoder.spyData,
            [stubbedData]
        )
    }

    func test_GivenClientSuccess_DecodingFailure_WhenFetchProperties_ThenSuccessEmptyProperties() {
        var capturedProperties: [Property]? = nil

        service.fetchProperties { result in
            if case .success(let properties) = result {
                capturedProperties = properties
            }
        }
        mockedDecoder.shouldThrow = true
        mockedClient.spyCompletion?(.success((data: Data(), response: nil)))

        XCTAssertEqual(capturedProperties, [])
    }

    func test_GivenSuccess_DecodingSuccess_WhenFetchProperties_ThenSuccessWithPropertie() {
        var capturedProperties: [Property]? = nil

        service.fetchProperties { result in
            if case .success(let properties) = result {
                capturedProperties = properties
            }
        }

        let expectedProperty = Property(price: 123)
        mockedDecoder.stubbedModel = PropertiesModel(properties: [expectedProperty])
        mockedClient.spyCompletion?(.success((data: Data(), response: nil)))

        XCTAssertEqual(capturedProperties, [expectedProperty])
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

private class MockClient: NetworkServiceInterface {
    private(set) var spyFetchRequest = [URLRequest]()
    private(set) var spyCompletion: NetworkServiceCompletion?

    func fetch(request: URLRequest, completion: @escaping NetworkServiceCompletion) {
        spyFetchRequest.append(request)
        spyCompletion = completion
    }
}

private class MockDecoder: DecoderInterface {
    private(set) var spyData = [Data]()
    var shouldThrow = false
    var stubbedModel = PropertiesModel(properties: [Property(price: 1)])

    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        spyData.append(data)
        guard shouldThrow == false else {
            throw DummyError()
        }

        return stubbedModel as! T
    }
}
