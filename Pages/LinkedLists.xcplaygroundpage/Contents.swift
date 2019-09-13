//: [Previous](@previous)

import Foundation

// LINKED LISTS
// • Collection of values (chain of nodes)
// • Linear, unidirectional sequence

// Nodes:
// • Hold a value
// • Hold a reference to the next node. A nil value represents the end of the list.

// + PROS:
// • Constant time insertions and removal from the front of the list
// • Reliable performance characteristics

// Collection Protocols:
// A linked list can earn two qualifications from the Swift collection protocols.
// • First, since a linked list is a chain of nodes, adopting the Sequence protocol makes sense.
// • Second, since the chain of nodes is a finite sequence, it makes sense to adopt the Collection protocol.
// • A collection type is a finite sequence and provides nondestructive sequential access.
// • A Swift Collection also allows for access via a subscript, which is a fancy term for saying an index can be mapped to a value in the collection (ie: array[5])

// Key Points:
// • Linked lists are linear and unidirectional. As soon as you move a reference from one node to another, you can't go back.
// • Linked lists have a O(1) time complexity for head first insertions. Arrays have O(n) time complexity for head-first insertions.
// • Conforming to Swift collection protocols such as Sequence and Collection offers a host of helpful methods for few requirements.
// • Copy-on-write behavior lets you achieve value semantics.

// MARK: - Node
public class Node<Value> {
    var value: Value
    var next: Node?
    
    public init(value: Value, next: Node? = nil) {
        self.value = value
        self.next = next
    }
}

extension Node: CustomStringConvertible {
    public var description: String {
        guard let next = next else { return "\(value)" }
        
        return "\(value) -> " + String(describing: next) + " "
    }
}

// MARK: - LinkedList
public struct LinkedList<Value> {
    var head: Node<Value>?
    var tail: Node<Value>?
    init(){}
    
    public var isEmpty: Bool {
        return head == nil
    }
    
    /// First checks to see if node is the only allocated reference in memory. If true, it exits the function. If false, makes a copy-on-write (COW) that replaces the existing nodes of your linked list with newly allocated ones with the same value
    private mutating func copyNodes() {
        guard !isKnownUniquelyReferenced(&head) else { return }
        guard var oldNode = head else { return }
        
        head = Node(value: oldNode.value)
        var newNode = head
        
        while let nextOldNode = oldNode.next {
            newNode!.next = Node(value: nextOldNode.value)
            newNode = newNode!.next
            oldNode = nextOldNode
        }
        
        tail = newNode
    }
    
    // MARK: - ADDING VALUES
    /// O(1) - Creates a new head node and pushes the current head node down the chain. If the tail is empty (ie: the linked list was previously empty), the node also assigns itself to the tail node.
    public mutating func push(_ value: Value) {
        copyNodes()
        head = Node(value: value, next: head)
        if tail == nil {
            tail = head
        }
    }
    
    /// O(1) - Checks to see if the linked list is empty. If true, uses push method above. If false, inits a new value right after the current tail position. Finally, the tail is re-assigned to the new value.
    public mutating func append(_ value: Value) {
        copyNodes()
        guard !isEmpty else { push(value) ; return }
        
        tail!.next = Node(value: value)
        tail = tail!.next
    }
    
    /// O(n) - A simple search algorythm to find the node that you want to insert at (after)
    public func findNode(at index: Int) -> Node<Value>? {
        var currentNode = head
        var currentIndex = 0
        
        while currentIndex < index {
            currentNode = currentNode!.next
            currentIndex += 1
        }
        return currentNode
    }
    
    /// O(1) - If the node value == the tail, uses the append method above. Otherwise, simply links the new node with the rest of the list and returns the new node
    public mutating func insert(_ value: Value, after node: Node<Value>) -> Node<Value> {
        copyNodes()
        guard tail !== node else { append(value) ;  return tail! }
        
        node.next = Node(value: value, next: node.next)
        return node.next!
    }
    
    // MARK: - REMOVING VALUES
    // The defer scope will trigger once an event in the next scope is called (ie: return head?.value)
    /// O(1) - Returns the 1st element in the linked list and then sets the head equal to the next node value (popping the current head)
    public mutating func pop() -> Value? {
        copyNodes()
        defer {
            head = head?.next
            if isEmpty {
                tail = nil
            }
        }
        return head?.value
    }
    
    /// If the linked list is empty, returns nil. If the linked list has only one value, use the pop method above. Otherwise, traverses through the linked list, until the current.next node is nil. Finally, removes the last node and assigns the previous node to the tail value.
    public mutating func removeLast() -> Value? {
        copyNodes()
        guard let head = head else { return nil }
        guard head.next != nil else { return pop() }
        
        var prev = head
        var current = head
        
        while let next = current.next {
            prev = current
            current = next
        }
        prev.next = nil
        tail = prev
        return current.value
    }
    
    /// Takes in a node and returns the node value for the following node. This triggers the defer scope to remove the following node. Finally, if the node being removed is also the tail, the tail is set to the new "last" node value.
    public mutating func remove(after node: Node<Value>) -> Value? {
        copyNodes()
        defer {
            if node.next === tail {
                tail = node
            }
            node.next = node.next?.next
        }
        return node.next?.value
    }
}

extension LinkedList: CustomStringConvertible {
    public var description: String {
        guard let head = head else { return "Empty List"}
        
        return String(describing: head)
    }
}

extension LinkedList: Collection {
    
    public struct Index: Comparable {
        
        var node: Node<Value>?
        
        static public func ==(lhs: Index, rhs: Index) -> Bool {
            switch (lhs.node, rhs.node) {
            case let (left?, right?):
                return left.next === right.next
            case (nil, nil):
                return true
            default:
                return false
            }
        }
        
        static public func <(lhs: Index, rhs: Index) -> Bool {
            guard lhs != rhs else {
                return false
            }
            let nodes = sequence(first: lhs.node) { $0?.next }
            return nodes.contains { $0 === rhs.node }
        }
    }
    
    /// The head node defines the start index
    public var startIndex: Index {
        return Index(node: head)
    }
    
    /// The node following the tail defines the end index
    public var endIndex: Index {
        return Index(node: tail?.next)
    }
    
    /// We want to traverse the index by 1 node
    public func index(after i: Index) -> Index {
        return Index(node: i.node?.next)
    }
    
    /// Subscript is used to map an Index to the value in the collection. Since we have a custom index, we can refer to a value and find the index in now O(1)
    public subscript(position: Index) -> Value {
        return position.node!.value
    }
}

// MARK: - EXAMPLES

var list = LinkedList<Int>()

// Push (ie: head-first insertion) -> O(1)
list.push(3)
list.push(2)
list.push(1)
list.push(0)
print("After pushing elements: \(list)\n")

// Append (ie: tail-end insertion) -> O(1)
list.append(99)
list.append(100)
print("After appending elements: \(list)\n")

// Insert -> O(1), but needs the index value... findNode -> O(n)
var insertNode = list.findNode(at: 1)!
insertNode = list.insert(12, after: insertNode)
insertNode = list.insert(24, after: insertNode)
print("After inserting elements: \(list)\n")

// Pop (ie: remove 1st element) -> O(1)
let poppedValue = list.pop()
print("After popping element: \(list)")
print("Element popped: \(String(describing: poppedValue))\n")

// Remove Last -> O(n)
let removeLast = list.removeLast()
print("After removing last element: \(list)")
print("Element removed: \(String(describing: removeLast))\n")

// Remove After -> O(1), but needs the index value... findNode -> O(n)
let index = 1
let node = list.findNode(at: index - 1)!
let removeAfter = list.remove(after: node)
print("After removeAfter method: \(list)")
print("Node removed: \(String(describing: removeAfter))\n")

/// Collection Methods
var newList = LinkedList<Int>()
for n in 0...9 {
    newList.append(n)
}
print("New collection list: \(newList)")
print("Start Index: \(newList[newList.startIndex])")
print("Array containing first 2 element \(Array(newList.prefix(2)))")
print("Array containing last 2 element \(Array(newList.suffix(2)))")
let sum = newList.reduce(0, +)
print("Sum of all values: \(sum)\n")

// Single reference count to newList
print("Is uniquely referenced: \(isKnownUniquelyReferenced(&newList.head))")
var cowList = newList
// Multiple reference counts to newList
print("Is uniquely referenced: \(isKnownUniquelyReferenced(&newList.head))")
cowList.append(100)
print("\nTesting for copy-on-write:\ncowList: \(cowList)\noldList:\(newList)\n")


// MARK: - CHALLENGES

// Challenge 1: Create a function that prints out the elements of a linked list in reverse order
// Given a linked list, print the nodes in reverse order. For example:
// 1 -> 2 -> 3 -> nil
// should print:
// 3
// 2
// 1

func reverse(_ list: LinkedList<Int>) -> LinkedList<Int> {
    var reverseList = LinkedList<Int>()
    for n in list {
        reverseList.push(n)
    }
    return reverseList
}
print("Challenge₁:")
print(reverse(newList))


// Challenge 2: Create a function that returns the middle node of a linked list
// Given a linked list, find the middle node of the list. For example:
// “1 -> 2 -> 3 -> 4 -> nil
// middle is 3
//1 -> 2 -> 3 -> nil
// middle is 2”

func findMiddleNode(in list: LinkedList<Int>) -> Int? {
    var count = 0
    for _ in list {
        count += 1
    }
    let middleIndex = (count / 2)
    var spliceIndex = Array(list.prefix(middleIndex))
    let middleNode = spliceIndex.popLast()
    
    return middleNode
}
print("\nChallenge₂:")
print("Linked List: \(list)\nMiddleNode: \(String(describing: findMiddleNode(in: list)))")

// Challenge 3: Create a function that reverses a linked list
// To reverse a list is to manipulate the nodes so that the nodes of the list are linked in the other direction. For example:
// before
// 1 -> 2 -> 3 -> nil
//
// after
// 3 -> 2 -> 1 -> nil

func reverse₁(_ list: LinkedList<Int>) -> LinkedList<Int> {
    var reverseList = LinkedList<Int>()
    for n in list {
        reverseList.push(n)
    }
    return reverseList
}
print("\nChallenge₃")
print(reverse₁(newList))

// Challenge 4: Create a function that takes two sorted linked lists and merges them into a single sorted linked list
// Your goal is to return a new linked list that contains the nodes from two lists in sorted order. You may assume the sort order is in ascending order. For example:
// list1
// 1 -> 4 -> 10 -> 11

// list2
// -1 -> 2 -> 3 -> 6

// merged list
// -1 -> 1 -> 2 -> 3 -> 4 -> 6 -> 10 -> 11

// TODO: - Finish This Challenge
func combineLists(_ list₁: LinkedList<Int>, _ list₂: LinkedList<Int>) -> LinkedList<Int> {
    guard !list₁.isEmpty else { return list₂ }
    guard !list₂.isEmpty else { return list₁ }
    
//    var currentLeft = list₁.head
//    var currentRight = list₂.head
    
    return list₂
}

// Challenge 5: Create a function that removes all occurrences of a specific element from a linked list
// Given a linked list, remove all nodes that match a particular value. The implementation is similar to the remove(at:) method that you implemented for the linked list. For example:
// original list
//1 -> 3 -> 3 -> 3 -> 4

// list after removing all occurrences of 3
// 1 -> 4

func removeAllInstances(of element: Int, in list: LinkedList<Int>) -> LinkedList<Int> {
    var list₂ = LinkedList<Int>()
    
    for n in list {
        if n != element {
            list₂.append(n)
        }
    }
    return list₂
}
var listChallenge₅ = LinkedList<Int>()
let removeValue = 3
listChallenge₅.append(1)
listChallenge₅.append(2)
listChallenge₅.append(3)
listChallenge₅.append(3)
listChallenge₅.append(4)

print("\nChallenge₅")
print("Before remove all \(removeValue)s: \(listChallenge₅)")
listChallenge₅ = removeAllInstances(of: removeValue, in: listChallenge₅)
print("After remove all \(removeValue)s: \(listChallenge₅)")

//: [Next](@next)
