//: [Previous](@previous)

import Foundation

// // MARK: - STACK DATA STRUCTURES (LIFO DS)
// Everyday stack objects:
// • Books
// • Pancakes
// • Paper
// • Cash

// Like these examples, Stacks are similar as data structs. LIFO (last-in-first-out) -> Remove the top element first

// Core Operations:
// • Push -> Add an item to the top of the stack
// • Pop -> Removing the top element from a stack

// Example Uses:
// • iOS navigation controller -> push and pop view controllers on and off the stack
// • Memory allocation uses stacks at architectural level
// • Search and conquor algorythms

// Stacks are crucial to problems that search trees and graphs. Imagine finding your way through a maze. Each time you come to a decision point of left, right or straight, you can push all possible decisions onto your stack. When you hit a dead end, simply backtrack by popping from the stack and continuing until you escape or hit another dead end.”

// “Key Points:
// Despite being so simple, the stack is a key data structure for many problems. The only two essential operations for the stack are the push method for adding elements and the pop method for removing elements.

struct Stack<Element> {
    
    /// Stores the stack elements. An array is a solid storage type, as append and popLast are O(1) functions and when reversed, can function as push and pop.
    private var storage: [Element] = []
    init(){}
    init(_ elements: [Element]) {
        storage = elements
    }
    
    var isEmpty: Bool {
        return peek() == nil
    }
    
    /// O(1) -> Peeks at the top element in the stack, without mutating it
    func peek() -> Element? {
        return storage.last
    }
    
    /// O(1) -> Pushes an element to the top of the stack
    mutating func push(_ element: Element) {
        storage.append(element)
    }
    
    /// O(1) -> Pops an element from the top of the stack
    mutating func pop() -> Element? {
        return storage.popLast()
    }
}

extension Stack: CustomStringConvertible {
    var description: String {
        let topDivider = "----top----\n"
        let bottomDivider = "\n----bottom----"
        
        let stackElements = storage
            .map{"\($0)"}
            .reversed()
            .joined(separator: "\n")
        
        return topDivider + stackElements + bottomDivider
    }
}

extension Stack: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Element...) {
        storage = elements
    }
}

// MARK: - EXAMPLES
var stack = Stack<Int>()
stack.push(1)
stack.push(2)
stack.push(3)
stack.push(4)
print(stack)

if let poppedElement = stack.pop() {
    assert(4 == poppedElement)
    print("Popped: \(poppedElement)")
}
print("Peek: \(stack.peek() as Any)\n")

let array = ["A", "B", "C", "D"]
var stack₁ = Stack(array)
print("Init Stack from Array:\n")
print("Before Pop: \(stack₁)\n")
print("Element Popped: \(String(describing: stack₁.pop()))\n")
print("After Pop: \(stack₁)\n")

var stack₃: Stack = [1.0, 2.0, 3.0, 4.0, 5.0]
print("Init Stack from Array Literal:\n")
print("Before Pop: \(stack₃)\n")
print("Element Popped: \(String(describing: stack₃.pop()))\n")
print("After Pop: \(stack₃)\n")

// MARK: - CHALLENGES

// Linked List Data Structure for Challenges
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

// Challenge 1
// Print a linked list in reverse without using recursion. Given a linked list, print the nodes in reverse order. You should not use recursion to solve this problem.

var linkedList = LinkedList<Int>()
linkedList.append(1)
linkedList.append(2)
linkedList.append(3)
linkedList.append(4)
print("Challenge₁:\n")
print("Linked List: \(linkedList)\n")

func reverseList(_ list: LinkedList<Int>) {
    let array = Array(list)
    var stack = Stack(array)
    print("Stack Print & Pop:")
    while !stack.isEmpty {
        print(stack.pop()!)
    }
}
reverseList(linkedList)

// Challenge 2
// Check for balanced parentheses. Given a string, check if there are ( and ) characters, and return true if the parentheses in the string are balanced. For example:
// h((e))llo(world)() // balanced parentheses
// (hello world // unbalanced parentheses

func checkForBalancedParentheses(in string: String) -> Bool {
    var stack = Stack<Character>()
    for character in string {
        if character == "(" {
            stack.push(character)

        } else if character == ")" {
            guard !stack.isEmpty else { return false }
            stack.pop()
        }
    }
    if stack.isEmpty {
        return true
    }
    return false
}
print("\nChallenge₂")
print(checkForBalancedParentheses(in: "((test))"))
print(checkForBalancedParentheses(in: "(test))"))
print(checkForBalancedParentheses(in: ")(test)("))

//: [Next](@next)
