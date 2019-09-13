//: [Previous](@previous)

import Foundation

/*

 // MARK: - BUILT IN DATA STRUCTURES (SWIFT)
 
 ARRAY: General Purpose, Generic Collection (ie: container for generics)
 • Ordered
 • Random Access Collection - (ie: has O(1) access time to indices -- people[0])

 Insert Location Choices:
 • Append is O(1)
 • Insert at [0] (ie: people.insert("Brian", at: 0)) would be the lengthiest insert O(n)
 
 Capacity:
 • If array is at max capacity and there is an insert or appends, then the array's elements are copied O(n) and put into a new array that is 2x in capacity. Also known as Amortized Time O(x)
 
 DICTIONARY: Generic Colection, Key-Value Pairs
 - Negatives:
 • Unordered
 • Cannot insert at specific indices
 • Key type must be Hashable (protocol)
 
 + Positives
 • Can traverse through dict, but in an unordered way. This order, while not defined, will be the same every time it is traversed until the collection is changed (mutated)
 • Inserts are always O(1)
 • Lookup operations are always O(1)
 
 
 // MARK: - COLLECTION PROTOCOLS
 
 • Tier 1, Sequence: A sequence type provides sequential access to its elements. This axiom comes with a caveat: Using the sequential access may destructively consume the elements.
 
 • Tier 2, Collection: A collection type is a sequence type that provides additional guarantees. A collection type is finite and allows for repeated nondestructive sequential access.
 
 • Tier 3, BidirectionalColllection: A collection type can be a bidirectional collection type if it, as the name suggests, can allow for bidirectional travel up and down the sequence. This isn’t possible for the linked list, since you can only go from the head to the tail, but not the other way around.
 
 • Tier 4, RandomAccessCollection: A bidirectional collection type can be a random access collection type if it can guarantee that accessing an element at a particular index will take just as long as access an element at any other index. This is not possible for the linked list, since accessing a node near the front of the list is substantially quicker than one that is further down the list.
*/



//: [Next](@next)
