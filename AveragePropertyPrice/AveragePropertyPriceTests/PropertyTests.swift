import XCTest
@testable import AveragePropertyPrice

final class PropertyTests: XCTestCase {

    func test_WhenDecode_then9Prices() {
        let model = try? JSONDecoder().decode(PropertiesModel.self, from: json.data(using: .utf8)!)
        XCTAssertEqual(model?.properties.flatMap{ $0},
                       [Property(price: 1000000),
                        Property(price: 100000),
                        Property(price: 225000),
                        Property(price: 150000),
                        Property(price: 222250),
                        Property(price: 750000),
                        Property(price: 125000),
                        Property(price: 545444),
                        Property(price: 574833)
                       ]
        )
    }

    private let json = """
{
  "properties" : [
    {
      "id": 1,
      "price": 1000000,
      "bedrooms": 7,
      "bathrooms":2,
      "number": "12",
      "address": "Richard Lane",
      "region": "London",
      "postcode": "W1F 3FT",
      "propertyType": "DETACHED"
    },
    {
      "id": 2,
      "price": 100000,
      "bedrooms": 2,
      "bathrooms":1,
      "number": "22",
      "address": "Brick Road",
      "region": "Sheffield",
      "postcode": "SH1 1AW",
      "propertyType": "TERRACED"
    },
    {
      "id": 3,
      "price": 225000,
      "bedrooms": 5,
      "bathrooms":0,
      "number": "40",
      "address": "Yellow Lane",
      "region": "Manchester",
      "postcode": "MA12 3ZY",
      "propertyType": "DETACHED"
    },
    {
      "id": 4,
      "price": 150000,
      "bedrooms": 1,
      "bathrooms":1,
      "number": "3B",
      "address": "Red Admiral Court",
      "region": "Essex",
      "postcode": "RM2 6ET",
      "propertyType": "FLAT"
    },
    {
      "id": 5,
      "price": 222250,
      "bedrooms": 3,
      "bathrooms":1,
      "number": "36",
      "address": "Country House",
      "region": "Winchester",
      "postcode": "WI3 9TT",
      "propertyType": "DETACHED"
    },
    {
      "id": 6,
      "price": 750000,
      "bedrooms": 10,
      "bathrooms":4,
      "number": "",
      "address": "Country House",
      "region": "Surrey",
      "postcode": "GU13 9DD",
      "propertyType": "SEMI_DETACHED"
    },
    {
      "id": 7,
      "price": 125000,
      "bedrooms": 2,
      "bathrooms":2,
      "number": "44",
      "address": "New Road",
      "region": "London",
      "postcode": "W1F 4DQ",
      "propertyType": "SEMI_DETACHED"
    },
    {
      "id": 8,
      "price": 545444,
      "bedrooms": 4,
      "bathrooms":1,
      "number": "55",
      "address": "Straight Road",
      "region": "Sheffield",
      "postcode": "SH1 8FG",
      "propertyType": "TERRACED"
    },
    {
      "id": 9,
      "price": 574833,
      "bedrooms": 4,
      "bathrooms":3,
      "number": "23",
      "address": "Curved Lane",
      "region": "Manchester",
      "postcode": "MA12 3AS",
      "propertyType": "DETACHED"
    }
  ]
}
"""
}
