//: [Previous](@previous)

/*
 
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
 
*/



//: [Next](@next)
