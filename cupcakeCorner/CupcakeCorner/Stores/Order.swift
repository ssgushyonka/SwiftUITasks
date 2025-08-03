import SwiftUI

@Observable
class Order : Codable {
    enum CodingKeys : String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _name = "name"
        case _city = "city"
        case _streetAddress = "streetAddress"
        case _zip = "zip"
    }
    
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    
    init() {
        self.name = UserDefaults.standard.string(forKey: "userRealName") ?? ""
        self.streetAddress = UserDefaults.standard.string(forKey: "userStreetAddress") ?? ""
        self.city = UserDefaults.standard.string(forKey: "userCity") ?? ""
        self.zip = UserDefaults.standard.string(forKey: "userZip") ?? ""
    }
    
    func isInvalidField(_ field : String) -> Bool {
        if (field.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
            return true
        }
        return false
    }
    
    var hasValidAddress : Bool {
        if (isInvalidField(name) || isInvalidField(streetAddress) || isInvalidField(city) || isInvalidField(zip)) {
            return false
        }
        return true
    }
    
    var cost : Decimal {
        var baseCost : Decimal = Decimal(quantity) * 2
        baseCost += Decimal(type) / 2 //Complicated cakes cost more.
        if extraFrosting {
            baseCost += 1
        }
        if addSprinkles {
            baseCost += 0.5
        }
        return baseCost
    }
    
    func saveUserInfoLocally() {
        UserDefaults.standard.set(self.streetAddress, forKey: "userStreetAddress")
        UserDefaults.standard.set(self.name, forKey: "userRealName")
        UserDefaults.standard.set(self.city, forKey: "userCity")
        UserDefaults.standard.set(self.zip, forKey: "userZip")
    }
}
