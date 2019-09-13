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
class Node<Value> {
    var value: Value
    var next: Node?
    
    init(value: Value, next: Node? = nil) {
        self.value = value
        self.next = next
    }
}

extension Node: CustomStringConvertible {
    var description: String {
        guard let next = next else { return "\(value)" }
        
        return "\(value) -> " + String(describing: next) + " "
    }
}

// MARK: - LinkedList
struct LinkedList<Value> {
    var head: Node<Value>?
    var tail: Node<Value>?
    init(){}
    
    var isEmpty: Bool {
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
    mutating func push(_ value: Value) {
        copyNodes()
        head = Node(value: value, next: head)
        if tail == nil {
            tail = head
        }
    }
    
    /// O(1) - Checks to see if the linked list is empty. If true, uses push method above. If false, inits a new value right after the current tail position. Finally, the tail is re-assigned to the new value.
    mutating func append(_ value: Value) {
        copyNodes()
        guard !isEmpty else { push(value) ; return }
        
        tail!.next = Node(value: value)
        tail = tail!.next
    }
    
    /// O(n) - A simple search algorythm to find the node that you want to insert at (after)
    func findNode(at index: Int) -> Node<Value>? {
        var currentNode = head
        var currentIndex = 0
        
        while currentIndex < index {
            currentNode = currentNode!.next
            currentIndex += 1
        }
        return currentNode
    }
    
    /// O(1) - If the node value == the tail, uses the append method above. Otherwise, simply links the new node with the rest of the list and returns the new node
    mutating func insert(_ value: Value, after node: Node<Value>) -> Node<Value> {
        copyNodes()
        guard tail !== node else { append(value) ;  return tail! }
        
        node.next = Node(value: value, next: node.next)
        return node.next!
    }
    
    // MARK: - REMOVING VALUES
    // The defer scope will trigger once an event in the next scope is called (ie: return head?.value)
    /// O(1) - Returns the 1st element in the linked list and then sets the head equal to the next node value (popping the current head)
    mutating func pop() -> Value? {
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
    mutating func removeLast() -> Value? {
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
    mutating func remove(after node: Node<Value>) -> Value? {
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
    var description: String {
        guard let head = head else { return "Empty List"}
        
        return String(describing: head)
    }
}

extension LinkedList: Collection {
    
    struct Index: Comparable {
        
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
    var startIndex: Index {
        return Index(node: head)
    }
    
    /// The node following the tail defines the end index
    var endIndex: Index {
        return Index(node: tail?.next)
    }
    
    /// We want to traverse the index by 1 node
    func index(after i: Index) -> Index {
        return Index(node: i.node?.next)
    }
    
    /// Subscript is used to map an Index to the value in the collection. Since we have a custom index, we can refer to a value and find the index in now O(1)
    subscript(position: Index) -> Value {
        return position.node!.value
    }
}

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
print("\nTesting for copy-on-write:\nnewList: \(cowList)\noldList:\(newList)")

//: [Next](@next)
