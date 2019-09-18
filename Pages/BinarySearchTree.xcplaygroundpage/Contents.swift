//: [Previous](@previous)

import Foundation

// MARK: - Binary Search Tree - O(log n)
var sortedArray = [2, 4, 5, 6, 7, 9, 10, 13, 14, 16, 22, 25]

//func searchBinaryTree(for key: Int, in array: [Int]) -> Bool {
//    let minIndex = 0
//    let maxIndex = array.count - 1
//    let midIndex = maxIndex / 2
//    let midValue = array[midIndex]
//
//    print(array)
//
//    if key > array[maxIndex] || key < array[minIndex] {
//        return false
//    } else if key > midValue {
//        let slice = Array(array[midIndex + 1...maxIndex])
//        return searchBinaryTree(for: key, in: slice)
//    } else if key < midValue {
//        let slice = Array(array[minIndex...midIndex - 1])
//        return searchBinaryTree(for: key, in: slice)
//    } else if key == midValue {
//        return true
//    }
//    return false
//}
//searchBinaryTree(for: 8, in: sortedArray)

func existsInArray(_ numbers: [Int], _ k: Int) -> Bool {
    guard !numbers.isEmpty else { return false }
    
    let minIndex = 0
    let maxIndex = numbers.count - 1
    let midIndex = maxIndex / 2
    let midValue = numbers[midIndex]
    
    if k > numbers[maxIndex] || k < numbers[minIndex] {
        return false
    } else if k > midValue {
        let slice = Array(numbers[midIndex + 1...maxIndex])
        return existsInArray(slice, k)
    } else if k < midValue {
        let slice = Array(numbers[minIndex...midIndex - 1])
        return existsInArray(slice, k)
    } else if k == midValue {
        return true
    }
    return false
}

existsInArray(Array(1...1000000), 7)

//: [Next](@next)



