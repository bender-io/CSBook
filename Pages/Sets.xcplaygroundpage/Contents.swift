//: [Previous](@previous)

import Foundation

// MARK: - SETS
var sampleSetOne = Set([1,2,3,4,5,6])
var sampleSetTwo = Set([1,4,7,12,13,14])

// UNION
let union = sampleSetOne.union(sampleSetTwo)

// INTERSECTION
let intersection = sampleSetOne.intersection(sampleSetTwo)

// SYMMETRIC DIFFERENCE
let symmetricDifference = sampleSetOne.symmetricDifference(sampleSetTwo)

// NO APPEND - ONLY INSERT
for num in symmetricDifference {
    sampleSetOne.insert(num)
}
sampleSetOne

//: [Next](@next)
