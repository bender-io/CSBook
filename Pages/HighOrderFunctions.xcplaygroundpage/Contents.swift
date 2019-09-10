//: [Previous](@previous)

import UIKit

// MARK: - ARRAY METHODS
struct Device {
    var type: String
    var price: Float
    var color: String?
}

var iMacPro = Device(type: "iMac Pro", price: 4999.00, color: "Space Grey")
var iPhone6 = Device(type: "iPhone", price: 799.00, color: "White")
var iPhone7 = Device(type: "iPhone", price: 899.00, color: "Black")
var iPad = Device(type: "iPad", price: 999.00, color: "Black")
var usediPad = Device(type: "iPad", price: 400.00, color: nil)
var devices = [iMacPro, iPhone6, iPhone7, iPad, usediPad]

// FILTER
let filterByiPhone = devices.filter({ $0.type == "iPhone" })
filterByiPhone

// MAP
let mapByCanadianPrice = devices.map({ $0.price * 1.2 })
mapByCanadianPrice

// COMPACT MAP
let compactMapByColor = devices.compactMap({ $0.color })
compactMapByColor

// REDUCE
let reduceToTotalCanadianPrice: Float = mapByCanadianPrice.reduce(0.0, +)
reduceToTotalCanadianPrice

// SORT
devices.sort(by: { $0.price > $1.price })
devices

// SORTED
let sortedByLeastExpensive = devices.sorted(by: { $0.price < $1.price })
sortedByLeastExpensive

// CONTAINS
let containsColorYellow = devices.contains(where: { $0.color == "Yellow" })
containsColorYellow

// MAX
let maxPrice = devices.max(by: { $0.price < $1.price })
maxPrice

// MIN
let minPrice = devices.min(by: { $0.price > $1.price })
minPrice

// REMOVE ALL WHERE
devices.removeAll(where: { $0.color == nil })
devices


// MARK: - CHARACTER & STRING METHODS
let sampleString = "-email: brian@brianhersh.dev phone: 303.875.5731-"

// TRIM
let trimmedString = sampleString.trimmingCharacters(in: .init(charactersIn: "-"))
print(trimmedString)

// SPLIT
let splitString = trimmedString.split(whereSeparator: { $0.isPunctuation || $0.isWhitespace })
print(splitString)

// SORT
let sortedString = trimmedString.sorted(by: { $0 > $1 })
sortedString

//: [Next](@next)
