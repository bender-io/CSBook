//: [Previous](@previous)

import Foundation

// MARK: - Heaps

// raywenderlich.com/586-swift-algorithm-club-heap-and-priority-queue-data-structure

// Two Heap Models:
// • maxheaps: Elements with a higher value represent higher priority.
// • minheaps: Elements with a lower value represent higher priority.

// Before a new level can be added, all the existing levels must be full. Whenever we add nodes to a heap, we add them in the leftmost possible position in the incomplete level. Whenever we remove nodes from a heap, we remove the rightmost node from the lowest level.

// Removing:
// The heap is useful as a priority queue because the root node of the tree contains the element with the highest priority in the heap. To remove the root node, we swap the root node with the last node in the heap. Then we remove it. Then, we compare the new root node to each of its children, and swap it with whichever child has the highest priority.

// Adding:
// First we add the new element at the left-most position in the incomplete level of the heap. Then we compare the priority of the new element to its parent, and if it has a higher priority, we sift up. We keep sifting up until the new element has a lower priority than its parent, or it becomes the root of the heap.

// Note: This array isn’t sorted. As you may have noticed from the above diagrams, the only relationships between nodes that the heap cares about are that parents have a higher priority than their children. The heap doesn’t care which of the left child and right child have higher priority. A node which is closer to the root node isn’t always of higher priority than a node which is further away.

// "Magic Formulas" - Uses Integer Division, so fractions round down
// • Left Child: (2 * currentIndex) + 1
// • Right Child: (2 * currentIndex) + 2
// • Parent Node: (currentIndex - 1) / 2

struct Heap<Element> {
    
    var elements: [Element]
    let priorityFunction: (Element, Element) -> Bool
    var isEmpty: Bool {
        return elements.isEmpty
    }
    var count: Int {
        return elements.count
    }
    
    /// Returns the root value of the heap
    func peek() -> Element? {
        return elements.first
    }
    
    /// Returns true if node is the root index
    func isRoot(_ index: Int) -> Bool {
        return (index == 0)
    }
    
    /// Returns the index of the left child node
    func leftChildIndex(of index: Int) -> Int {
        return (2 * index) + 1
    }
    
    /// Returns the index of the right child node
    func rightChildIndex(of index: Int) -> Int {
        return (2 * index) + 2
    }
    
    /// Returns the index of the parent node
    func parentIndex(of index: Int) -> Int {
        return (index - 1) / 2
    }
    
    /// Returns true if the first element has higher priority
    func isHigherPriority(at firstIndex: Int, than secondIndex: Int) -> Bool {
        return priorityFunction(elements[firstIndex], elements[secondIndex])
    }
    
    /// Determines if the child index is higher priority than its parent node
    func highestPriorityIndex(of parentIndex: Int, and childIndex: Int) -> Int {
        guard childIndex < count && isHigherPriority(at: childIndex, than: parentIndex)
            else { return parentIndex }
        
        return childIndex
    }
    
    /// Determines which of the three indices have the highest priority (parent, left child, right child)
    func highestPriorityIndex(for parent: Int) -> Int {
        return highestPriorityIndex(of: highestPriorityIndex(
            of: parent, and: leftChildIndex(of: parent)), and: rightChildIndex(of: parent))
    }
    
    /// Swaps the firstIndex with the secondIndex
    mutating func swapElement(at firstIndex: Int, with secondIndex: Int) {
        guard firstIndex != secondIndex else { return }
        elements.swapAt(firstIndex, secondIndex)
    }
    
    /// Performs heap sift to re-order indices based on highest priority
    mutating func siftUp(elementAtIndex index: Int) {
        let parent = parentIndex(of: index)
        guard !isRoot(index), isHigherPriority(at: index, than: parent) else { return }
        swapElement(at: index, with: parent)
        siftUp(elementAtIndex: parent)
    }
    
    /// Appends (enqueue's) an element
    mutating func enqueue(_ element: Element) {
        elements.append(element)
        siftUp(elementAtIndex: count - 1)
    }
}

//: [Next](@next)
