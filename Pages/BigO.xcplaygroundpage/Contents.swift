
import Foundation

// MARK: - BIG O
var array = [1, 3, 5, 7, 8, 9]

// O(1): Constant Time - Indexing
array.append(102)
array.popLast()
array.randomElement()

// 0(log n): Logarithmic Time - Binary Search Tree & Binomial Heap
func searchBinaryTree(for key: Int, in array: [Int]) -> Bool {
    let minIndex = 0
    let maxIndex = array.count - 1
    let midIndex = maxIndex / 2
    let midValue = array[midIndex]
    
    print(array)
    
    if key > array[maxIndex] || key < array[minIndex] {
        return false
    } else if key > midValue {
        let slice = Array(array[midIndex + 1...maxIndex])
        return searchBinaryTree(for: key, in: slice)
    } else if key < midValue {
        let slice = Array(array[minIndex...midIndex - 1])
        return searchBinaryTree(for: key, in: slice)
    } else if key == midValue {
        return true
    }
    return false
}
searchBinaryTree(for: 9, in: array)

// O(n): Linear Time - For-In Loops
array.contains(3)
array.remove(at: 3)
array.removeAll()
array.max()
array.reverse()

// O(n log n): Linearithmic Time - Comparison Sort, Heapsort & Merge Sort
array.sorted()

// O(n²): Quadratic Time - Nested For-In Loops
for n in array {
    for m in array {
        if m > n {
            print(m + n)
        }
    }
}

// O(2ⁿ): Exponential Time - Recursive Functions

// O(n!): Factorial Time - Oops, this really should not happen

// O(x): Amortized Time - Describes a situation where a worst case can occur, but then it won't happen again for a while
// (Ex: when appending to an array - usually an O(1) operation - if the array is full, then the class will need to create a new array with double capacity O(n))
