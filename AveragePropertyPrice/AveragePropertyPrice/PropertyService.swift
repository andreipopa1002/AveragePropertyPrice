import Foundation
import NetworkingS

struct PropertiesModel: Decodable {
    let properties: [Property]
}

struct Property: Decodable, Equatable {
    let price: Int
}

protocol PropertyServiceInterface {
    func fetchProperties(completion: @escaping ((Result<[Property], Error>) -> ()))
}

protocol DecoderInterface: AnyObject {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}
extension JSONDecoder: DecoderInterface {}


final class PropertyService {
    private let client: NetworkServiceInterface
    private let decoder: DecoderInterface

    init(client: NetworkServiceInterface, decoder: DecoderInterface) {
        self.client = client
        self.decoder = decoder
    }

}

extension PropertyService: PropertyServiceInterface {
    func fetchProperties(completion: @escaping ((Result<[Property], Error>) -> ())) {
        let request = URLRequest(
            url: URL(
                string: "https://raw.githubusercontent.com/rightmove/Code-Challenge-iOS/master/properties.json"
            )!
        )

        fetchProperties(request: request, completion: completion)
    }
}

private extension PropertyService {
    func fetchProperties(request: URLRequest, completion: @escaping ((Result<[Property], Error>) -> ())) {
        client.fetch(request: request) { [weak self] result in
            switch result {
            case .success(let tuple):
                self?.handleSuccess(tuple: tuple, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func handleSuccess(
        tuple:(data: Data?, response: URLResponse?),
        completion: @escaping ((Result<[Property], Error>) -> ())
    ) {
        guard let data = tuple.data else {
            return completion(.success([]))
        }

        let model = try? self.decoder.decode(PropertiesModel.self, from: data)
        completion(.success(model?.properties ?? []))
    }
}
