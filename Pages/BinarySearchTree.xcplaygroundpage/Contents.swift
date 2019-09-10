//: [Previous](@previous)

import UIKit

// MARK: - Binary Search Tree - O(log n)
var sortedArray = [2, 4, 5, 6, 7, 9, 10, 13, 14, 16, 22, 25]

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
searchBinaryTree(for: 8, in: sortedArray)

//: [Next](@next)
