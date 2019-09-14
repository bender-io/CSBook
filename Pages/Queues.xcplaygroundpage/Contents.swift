//: [Previous](@previous)

import Foundation

// MARK: - Doubly Linked List for Queue Exercise
public class Node<T> {
    
    public var value: T
    public var next: Node<T>?
    public var previous: Node<T>?
    
    public init(value: T) {
        self.value = value
    }
}
extension Node: CustomStringConvertible {
    
    public var description: String {
        return String(describing: value)
    }
}
public class DoublyLinkedList<T> {
    
    private var head: Node<T>?
    private var tail: Node<T>?
    
    public init(){}
    
    public var isEmpty: Bool {
        return head == nil
    }
    
    public var first: Node<T>? {
        return head
    }
    
    public func append(_ value: T) {
        let newNode = Node(value: value)
        
        guard let tailNode = tail else {
            head = newNode
            tail = newNode
            return
        }
        
        newNode.previous = tailNode
        tailNode.next = newNode
        tail = newNode
    }
    
    public func remove(_ node: Node<T>) -> T {
        let prev = node.previous
        let next = node.next
        
        if let prev = prev {
            prev.next = next
        } else {
            head = next
        }
        
        next?.previous = prev
        
        if next == nil {
            tail = prev
        }
        
        node.previous = nil
        node.next = nil
        
        return node.value
    }
}
extension DoublyLinkedList: CustomStringConvertible {
    
    public var description: String {
        var string = ""
        var current = head
        while let node = current {
            string.append("\(node.value) -> ")
            current = node.next
        }
        return string + "end"
    }
}
public class LinkedListIterator<T>: IteratorProtocol {
    
    private var current: Node<T>?
    
    init(node: Node<T>?) {
        current = node
    }
    
    public func next() -> Node<T>? {
        defer { current = current?.next }
        return current
    }
}
extension DoublyLinkedList: Sequence {
    
    public func makeIterator() -> LinkedListIterator<T> {
        return LinkedListIterator(node: head)
    }
}


// MARK: - QUEUES:
// • Queues use FIFO or first-in first-out ordering, meaning the first element that was added will always be the first to be removed. Queues are handy when you need to maintain the order of your elements to process later.

// COMMON OPERATIONS:
// • Enqueue: Insert an element at the back of the queue. Returns true if the operation was successful (get in back line)
// • Dequeue: Remove the element at the front of the queue and return it (complete and exit front of line)
// • isEmpty: Checks if the queue is empty
// • Peek: Return the element at the front of the queue without removing it

// NOTES
// • The queue only cares about removal from the front and insertion at the back. You don’t really need to know what the contents are in between. If you did, you would probably just use an array.

// DIFFERENT QUEUE OPTIONS:

// From Array:
// + Easy to setup ; O(1) for enqueue operations
// - O(n) for dequeue operations
// • O(n) space complexity - however bulk allocation is much faster than Linked List allocation below

// From DoublyLinkedList:
// + O(1) for enqueue & dequeue operations. Nodes don't need to shift and simply point to the next node in memory for O(1) dequeue
// - O(n) space complexity - high memory overhead for dynamic memory allocation & each node needs additional forward and backward referenceing in memory
// - Harder to setup (need to add DoublyLinkedList struct & Node class first)

// • Using a ring buffer
// • Using two stacks

public protocol Queue {
    /// The generic protocol type
    associatedtype Element
    /// Insert an element at the back of the queue & returns true if the operation was successful
    mutating func enqueue(_ element: Element) -> Bool
    /// Remove the element at the front of the queue and return it
    mutating func dequeue() -> Element?
    /// Checks if the queue is empty
    var isEmpty: Bool { get }
    /// Return the element at the front of the queue without removing it
    var peek: Element? { get }
}

public struct QueueArray<T>: Queue {
    private var array: [T] = []
    public init(){}
    
    /// O(1) - Checks to see if queue is empty
    public var isEmpty: Bool {
        return array.isEmpty
    }
    
    /// O(1) - Return the element at the front of the queue without removing it
    public var peek: T? {
        return array.first
    }
    
    /// Amortized O(1) - Insert an element at the back of the queue & returns true if the operation was successful
    public mutating func enqueue(_ element: T) -> Bool {
        array.append(element)
        return true
    }
    
    /// O(n) - Remove the element at the front of the queue and return it. This is a linear operation, because all elements in the array must shift one index towards the front after the element is dequeued.
    public mutating func dequeue() -> T? {
        return isEmpty ? nil : array.removeFirst()
    }
}

extension QueueArray: CustomStringConvertible {
    public var description: String {
        return String(describing: array)
    }
}

public class QueueLinkedList<T>: Queue {
    private var list = DoublyLinkedList<T>()
    public init(){}
    
    /// O(1) - Checks to see if queue is empty
    public var isEmpty: Bool {
        return list.isEmpty
    }
    
    /// O(1) - Return the element at the front of the queue without removing it
    public var peek: T? {
        return list.first?.value
    }
    
    /// Time: O(1) ; Space: O(n) - Insert an element at the back of the queue & returns true if the operation was successful. Behind the scenes, the doubly linked list will update its tail node’s previous and next references to the new node.
    public func enqueue(_ element: QueueLinkedList<T>.Element) -> Bool {
        list.append(element)
        return true
    }
    
    /// O(1) - Remove the element at the front of the queue and return it
    public func dequeue() -> T? {
        guard !list.isEmpty, let element = list.first else { return nil }
        return list.remove(element)
    }
}

extension QueueLinkedList: CustomStringConvertible {
    public var description: String {
        return String(describing: list)
    }
}

// EXAMPLES:
// 1. From Array:
var queue = QueueArray<String>()
queue.enqueue("Brian")
queue.enqueue("Daniel")
queue.enqueue("Allison")
queue.enqueue("Gabi")
print("Starting Queue: \(queue)")
print("Adding Dana to Enqueue")
queue.enqueue("Dana")
print("After Enqueue: \(queue)")
print("Removing \(queue.dequeue()!) from queue")
print("After Dequeue: \(queue)")
print("Front of queue peek: \(queue.peek!)")



//: [Next](@next)
