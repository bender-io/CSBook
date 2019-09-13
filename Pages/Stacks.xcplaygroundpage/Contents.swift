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

//: [Next](@next)
