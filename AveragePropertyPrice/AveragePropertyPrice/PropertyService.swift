import Foundation
import NetworkingS

struct Property: Decodable, Equatable {
    let price: Int
}

protocol PropertyServiceInterface {
    func fetchProperties(completion: @escaping ((Result<[Property], Error>) -> ()))
}

final class PropertyService {
    private let client: DecodingServiceInterface

    init(client: DecodingServiceInterface) {
        self.client = client
    }

}

extension PropertyService: PropertyServiceInterface {
    func fetchProperties(completion: @escaping ((Result<[Property], Error>) -> ())) {
        let request = URLRequest(
            url: URL(
                string: "https://raw.githubusercontent.com/rightmove/Code-Challenge-iOS/master/properties.json"
            )!
        )

        fetchProperties(request: request) { result in
            switch result {
            case .success((let model, _)):
                completion(.success(model ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

private extension PropertyService {
    func fetchProperties(request: URLRequest, completion: @escaping DecodingServiceCompletion<[Property]>) {
        client.fetch(request: request, completion: completion)
    }
}
