import Foundation

protocol InteractorInterface {
    func fetchAveragePropertyValue(completion: @escaping (Result<Decimal, Error>)->())
}

final class Interactor {
    private let service: PropertyServiceInterface

    init(service: PropertyServiceInterface) {
        self.service = service
    }

}

extension Interactor: InteractorInterface {
    func fetchAveragePropertyValue(completion: @escaping (Result<Decimal, Error>) -> ()) {
        service.fetchProperties { result in
            switch result {
            case .success(let properties):
                guard properties.count != 0 else { return completion(.success(0))}

                let averageValue = properties.reduce(Decimal.zero) { $0 + Decimal($1.price)} / Decimal(properties.count)
                completion(.success(averageValue))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
