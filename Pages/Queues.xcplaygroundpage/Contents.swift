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

// MARK: - Ring Buffer for Queue Exercise
public struct RingBuffer<T> {
    
    private var array: [T?]
    private var readIndex = 0
    private var writeIndex = 0
    
    public init(count: Int) {
        array = Array<T?>(repeating: nil, count: count)
    }
    
    public var first: T? {
        return array[readIndex]
    }
    
    public mutating func write(_ element: T) -> Bool {
        if !isFull {
            array[writeIndex % array.count] = element
            writeIndex += 1
            return true
        } else {
            return false
        }
    }
    
    public mutating func read() -> T? {
        if !isEmpty {
            let element = array[readIndex % array.count]
            readIndex += 1
            return element
        } else {
            return nil
        }
    }
    
    private var availableSpaceForReading: Int {
        return writeIndex - readIndex
    }
    
    public var isEmpty: Bool {
        return availableSpaceForReading == 0
    }
    
    private var availableSpaceForWriting: Int {
        return array.count - availableSpaceForReading
    }
    
    public var isFull: Bool {
        return availableSpaceForWriting == 0
    }
}
extension RingBuffer: CustomStringConvertible {
    public var description: String {
        let values = (0..<availableSpaceForReading).map {
            String(describing: array[($0 + readIndex) % array.count]!)
        }
        return "[" + values.joined(separator: ", ") + "]"
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

// From Doubly Linked List:
// + O(1) for enqueue & dequeue operations. Nodes don't need to shift and simply point to the next node in memory for O(1) dequeue
// - O(n) space complexity - high memory overhead for dynamic memory allocation & each node needs additional forward and backward referenceing in memory
// - Harder to setup (need to add DoublyLinkedList struct & Node class first)

// From Ring Buffer:
// A ring buffer, also known as a circular buffer, is a fixed-size array. This data structure strategically wraps around to the beginning when there are no more items to remove at the end.

// From Two Stacks:
// • Whenever you enqueue an element, it goes in the right stack.
// • When you need to dequeue an element, you reverse the right stack and place it in the left stack so that you can retrieve the elements using FIFO order.
// Note: Yes, reversing the contents of an array is an O(n) operation. The overall dequeue cost is still amortized O(1). Imagine having a large number of items in both the left and right stack. If you dequeue all of the elements, first it will remove all of the elements from the left stack, then reverse-copy the right stack only once, and then continue removing elements off the left stack.
// KEY POINTS:
// • Queue takes a FIFO strategy, an element added first must also be removed first.
// • Enqueue inserts an element to the back of the queue.
// • Dequeue removes the element at the front of the queue.
// • Elements in an array are laid out in contiguous memory blocks, whereas elements in a linked list are more scattered with potential for cache misses.
// • Ring-buffer-queue based implementation is good for queues with a fixed size.
// • Compared to other data structures, leveraging two stacks improves the dequeue(_:) time complexity to amortized O(1) operation.
// • Double-stack implementation beats out Linked-list in terms of spacial locality.

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

// MARK: - ARRAY
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

// MARK: - LINKED LIST
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

// MARK: - RING BUFFER
public struct QueueRingBuffer<T>: Queue {
    private var ringBuffer: RingBuffer<T>
    
    /// Inits a ring buffer object with a fixed size
    ///
    /// - Parameter count: the size of the ring buffer
    public init(count: Int) {
        ringBuffer = RingBuffer<T>(count: count)
    }
    
    /// O(1) - Checks to see if queue is empty
    public var isEmpty: Bool {
        return ringBuffer.isEmpty
    }
    
    /// O(1) - Return the element at the front of the queue without removing it
    public var peek: T? {
        return ringBuffer.first
    }
    
    /// O(1) - Enqueues the element and increments the write pointer by one
    public mutating func enqueue(_ element: T) -> Bool {
        return ringBuffer.write(element)
    }
    
    /// O(1) - Checks if the queue is empty and, if so, returns nil. If not, it returns an item from the front of the buffer & increments the read pointer by one.
    public mutating func dequeue() -> T? {
        return isEmpty ? nil : ringBuffer.read()
    }
}

// MARK: - DOUBLE-STACK
public struct QueueStacks<T>: Queue {
    /// Used to perform dequeues from the stack [newest...oldest] - removeLast for deque
    private var leftStack: [T] = []
    /// Used to perform enqueues from the stack [oldest...newest] - append(element) for enqueue
    private var rightStack: [T] = []
    public init(){}
    
    /// O(1) - Checks to see if both stacks are empty
    public var isEmpty: Bool {
        return leftStack.isEmpty && rightStack.isEmpty
    }
    
    /// O(1) - Returns the element at the front of the queue without removing it
    public var peek: T? {
        return !leftStack.isEmpty ? leftStack.last : rightStack.first
    }
    
    /// O(1) - Pushes to the stack by appending to the right stack array [oldest...newest] -> enqueue
    public mutating func enqueue(_ element: T) -> Bool {
        rightStack.append(element)
        return true
    }
    
    /// Amortized O(1) - Removes the last value in the left stack array [newest...oldest] -> dequeue. If the left stack is empty, first adds the elements from the right stack in reversed order - O(n) operation - and clears the right stack.
    public mutating func dequeue() -> T? {
        if leftStack.isEmpty {
            leftStack = rightStack.reversed()
            rightStack.removeAll()
        }
        return leftStack.popLast()
    }
}

// EXAMPLES:
// 1. From Array:
var arrayQueue = QueueArray<String>()
arrayQueue.enqueue("Brian")
arrayQueue.enqueue("Daniel")
arrayQueue.enqueue("Allison")
arrayQueue.enqueue("Gabi")
print("Array Queue:\n• Starting Queue: \(arrayQueue)")
print("• Adding Dana to Enqueue")
arrayQueue.enqueue("Dana")
print("• After Enqueue: \(arrayQueue)")
print("• Removing \(arrayQueue.dequeue()!) from queue")
print("• After Dequeue: \(arrayQueue)")
print("• Front of queue peek: \(arrayQueue.peek!)\n")

// 2. From Doubly Linked List:
var queueLinkedList = QueueLinkedList<String>()
queueLinkedList.enqueue("Brian")
queueLinkedList.enqueue("Daniel")
queueLinkedList.enqueue("Hersh")
print("Linked List Queue:\n• Starting Queue: \(queueLinkedList)")
queueLinkedList.enqueue("Mike")
print("• Adding Mike to Enqueue")
print("• After Enqueue: \(queueLinkedList)")
print("• Removing \(queueLinkedList.dequeue()!) from queue")
print("• After Dequeue: \(queueLinkedList)")
print("• Front of queue peek: \(queueLinkedList.peek!)\n")

// 3. From Ring Buffer:
var queueBuffer = QueueRingBuffer<String>(count: 4)
queueBuffer.enqueue("Brian")
queueBuffer.enqueue("Daniel")
queueBuffer.enqueue("Hersh")
print("Ring Buffer Queue:\n• Starting Queue: \(queueBuffer)")
queueBuffer.enqueue("Mike")
print("• Adding Mike to Enqueue")
queueBuffer.enqueue("Brent")
print("• Adding Brent to Enqueue -> Queue is full!")
print("• Full Queue: \(queueBuffer)")
print("• After Enqueue: \(queueBuffer)")
print("• Removing \(queueBuffer.dequeue()!) from queue")
print("• After Dequeue: \(queueBuffer)")
print("• Front of queue peek: \(queueBuffer.peek!)\n")

// 4. Double Stack:
var queueStacks = QueueStacks<String>()
queueStacks.enqueue("Brian")
queueStacks.enqueue("Daniel")
queueStacks.enqueue("Hersh")
print("Double Stacks Queue:\n• Starting Queue: \(queueStacks)")
queueStacks.enqueue("Mike")
queueStacks.enqueue("Brent")
print("• Adding Mike & Brent to Enqueue")
print("• O(1) Enqueue: \(queueStacks)")
print("• Removing \(queueStacks.dequeue()!) from queue")
print("• O(n) Dequeue: \(queueStacks)")
print("• Removing \(queueStacks.dequeue()!) from queue")
print("• O(1) Dequeue: \(queueStacks)")
print("• Front of queue peek: \(queueStacks.peek!)")

// MARK: - CHALLENGES
// Challenge 1.
// Explain the difference between a stack and a queue. Provide two real-life examples for each data structure.

// Stacks:
// • Use LIFO - last in, first out - operations, meaning you can only push and pop objects from the top of the stack.
// • Example₁ - Pancakes represent stacks. You add more to the top and remove to eat from the top of the stack.
// • Example₂ - NavigationControllers are stacks and push new ViewControllers to the top of the stack, or pop ViewControllers off the top of the stack to navigate.
// • Example₃ - A clip of amunition represents a stack. You load and unload bullets from the top of the stack.

// Queues:
// • Use FIFO - first in, first out - operations, meaning you enqueue new objects to the back and dequeue the oldest objects from the front.
// • Example₁ - Lines represent queues. If you arrive at a line, you enqueue to the back. When you get through the line, you dequeue out the front.
// • Example₂ - A customer support queue represents queues, as they help (dequeue) customers in the order that they called in (enqueued)

// Challenge 2.
// Given the following queue: SWIFT
// Provide step-by-step diagrams showing how the following series of commands affects the queue:
// 1. enqueue("R")
// 2. enqueue("O")
// 3. dequeue()
// 4. enqueue("C")
// 5. dequeue()
// 6. dequeue()
// 7. enqueue("K")

// Array:
// Start: [S, W, I, F, T]
// 1. [S, W, I, F, T, R]
// 2. [S, W, I, F, T, R, O]
// 3. [W, I, F, T, R, O]
// 4. [W, I, F, T, R, O, C]
// 5. [I, F, T, R, O, C]
// 6. [F, T, R, O, C]
// 7. [F, T, R, O, C, K]

// LinkedList:
// Start: S <-> W <-> I <-> F <-> T
// 1. S <-> W <-> I <-> F <-> T <-> R
// 2. S <-> W <-> I <-> F <-> T <-> R <-> O
// 3. W <-> I <-> F <-> T <-> R <-> O
// 4. W <-> I <-> F <-> T <-> R <-> O <-> C
// 5. I <-> F <-> T <-> R <-> O <-> C
// 6. F <-> T <-> R <-> O <-> C
// 7. F <-> T <-> R <-> O <-> C <-> K

// Ring Buffer Count(5):
// Start: [S, W, I, F, T]
// 1. [S, W, I, F, T]
// 2. [S, W, I, F, T]
// 3. [W, I, F, T, _]
// 4. [W, I, F, T, C]
// 5. [I, F, T, C, _]
// 6. [F, T, C, _, _]
// 6. [F, T, C, K, _]

// Stacks:
// Start: LeftStack[] , RightStack[S, W, I, F, T]
// 1. LeftStack[] , RightStack[S, W, I, F, T, R]
// 2. LeftStack[] , RightStack[S, W, I, F, T, R, O]
// 3. LeftStack[O, R, T, F, I, W] , RightStack[]
// 4. LeftStack[O, R, T, F, I, W] , RightStack[C]
// 5. LeftStack[O, R, T, F, I] , RightStack[C]
// 6. LeftStack[O, R, T, F] , RightStack[C]
// 7. LeftStack[O, R, T, F] , RightStack[C, K]

// Challenge 3.
// Imagine that you are playing a game of Monopoly with your friends. The problem is that everyone always forget whose turn it is! Create a Monopoly organizer that always tells you whose turn it is:

protocol BoardGameManager {
    associatedtype Player
    mutating func nextPlayer() -> Player?
}

public struct PlayerTurns<Player>: BoardGameManager {
    /// Used to perform dequeues from the stack [newest...oldest] - removeLast for deque
    private var leftStack: [Player] = []
    /// Used to perform enqueues from the stack [oldest...newest] - append(element) for enqueue
    private var rightStack: [Player] = []
    public init(){}
    
    /// O(1) - Checks to see if both stacks are empty
    public var isEmpty: Bool {
        return leftStack.isEmpty && rightStack.isEmpty
    }
    
    /// O(1) - Returns the element at the front of the queue without removing it
    public var peek: Player? {
        return !leftStack.isEmpty ? leftStack.last : rightStack.first
    }
    
    /// O(1) - Pushes to the stack by appending to the right stack array [oldest...newest] - append(element) for enqueue
    public mutating func enqueue(_ element: Player) -> Bool {
        rightStack.append(element)
        return true
    }
    
    /// Amortized O(1) - Removes the last value in the left stack array [newest...oldest] - removeLast for dequeue. If the left stack is empty, first adds the elements from the right stack in reversed order - O(n) operation - and clears the right stack.
    public mutating func dequeue() -> Player? {
        if leftStack.isEmpty {
            leftStack = rightStack.reversed()
            rightStack.removeAll()
        }
        return leftStack.popLast()
    }
    
    /// Amortized O(1) - Dequeues the most recent player from the front, then enqueues them to the back
    public mutating func nextPlayer() -> Player? {
        if leftStack.isEmpty {
            leftStack = rightStack.reversed()
            rightStack.removeAll()
        }
        guard let player = leftStack.popLast() else { return nil }
        rightStack.append(player)
        return player
    }
}

var players = PlayerTurns<String>()
players.enqueue("Brian")
players.enqueue("Gabi")
players.enqueue("Nate")
players.enqueue("James")
print("\nChallenge Three:\nTurn Order:\n\(players)")
print("Round 1:\n\(players.nextPlayer()!)")
print(players.nextPlayer()!)
print(players.nextPlayer()!)
print(players.nextPlayer()!)
print("Round 2:\n\(players.nextPlayer()!)")
print(players.nextPlayer()!)
print(players.nextPlayer()!)
print(players.nextPlayer()!)



//: [Next](@next)
