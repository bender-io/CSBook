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
    
    // MARK: - ADDING VALUES
    /// O(1) - Creates a new head node and pushes the current head node down the chain. If the tail is empty (ie: the linked list was previously empty), the node also assigns itself to the tail node.
    mutating func push(_ value: Value) {
        head = Node(value: value, next: head)
        if tail == nil {
            tail = head
        }
    }
    
    /// O(1) - Checks to see if the linked list is empty. If true, uses push method above. If false, inits a new value right after the current tail position. Finally, the tail is re-assigned to the new value.
    mutating func append(_ value: Value) {
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
    
    // @discardableResult lets callers ignore the return value of this method without the compiler jumping up and down
    /// O(1) - If the node value == the tail, uses the append method above. Otherwise, simply links the new node with the rest of the list and returns the new node
    @discardableResult
    mutating func insert(_ value: Value, after node: Node<Value>) -> Node<Value> {
        guard tail !== node else { append(value) ;  return tail! }
        
        node.next = Node(value: value, next: node.next)
        return node.next!
    }
    
    // MARK: - REMOVING VALUES
    // The defer scope will trigger once an event in the next scope is called (ie: return head?.value)
    /// O(1) - Returns the 1st element in the linked list and then sets the head equal to the next node value (popping the current head)
    @discardableResult
    mutating func pop() -> Value? {
        defer {
            head = head?.next
            if isEmpty {
                tail = nil
            }
        }
        return head?.value
    }
}

extension LinkedList: CustomStringConvertible {
    var description: String {
        guard let head = head else { return "Empty List"}
        
        return String(describing: head)
    }
}

var list = LinkedList<Int>()

// Push (ie: head-first insertion)
list.push(3)
list.push(2)
list.push(1)
list.push(0)
print("After pushing elements: \(list)")

// Append (ie: tail-end insertion)
list.append(99)
list.append(100)
print("After appending elements: \(list)")

// Insert O(n + 1) -> O(n)
var insertNode = list.findNode(at: 1)!
insertNode = list.insert(12, after: insertNode)
insertNode = list.insert(24, after: insertNode)
print("After inserting elements: \(list)")

// Pop (ie: remove 1st element)
let poppedValue = list.pop()
print("After popping element: \(list)")
print("Element popped: \(poppedValue)")



//: [Next](@next)
