//: [Previous](@previous)

import Foundation

// Helper function
public func example(of description: String, action: () -> Void) {
    print("---Example of: \(description)---")
    action()
    print()
}
// Queue Stacks Struct forEachLevelOrder() method
public struct Queue<T> {
    
    private var leftStack: [T] = []
    private var rightStack: [T] = []
    
    public init() {}
    
    public var isEmpty: Bool {
        return leftStack.isEmpty && rightStack.isEmpty
    }
    
    public var peek: T? {
        return !leftStack.isEmpty ? leftStack.last : rightStack.first
    }
    
    @discardableResult public mutating func enqueue(_ element: T) -> Bool {
        rightStack.append(element)
        return true
    }
    
    public mutating func dequeue() -> T? {
        if leftStack.isEmpty {
            leftStack = rightStack.reversed()
            rightStack.removeAll()
        }
        return leftStack.popLast()
    }
}

// MARK: - TREES GENERAL

// The tree is a data structure of profound importance. It is used to tackle many recurring challenges in software development, such as:
// • Representing hierarchical relationships.
// • Managing sorted data.
// • Facilitating fast lookup operations.

// Depth-First Traversal:
// • A technique that starts at the root and visits nodes as deep as it can before backtracking.

// Level-Order Traversal:
// • A technique that visits each node of the tree based on the depth of the nodes.

// KEY POINTS
// • Trees share some similarities to linked lists, but, whereas linked-list nodes may only link to one other node, a tree node can link to infinitely many nodes.
// • Be comfortable with the tree terminology such as parent, child, leaf and root. Many of these terms are common tongue for fellow programmers and will be used to help explain other tree structures.
// • Traversals, such as depth-first and level-order traversals, aren't specific to the general tree. They work on other trees as well, although their implementation will be slightly different based on how the tree is structured.

/// Each node is responsible for a value and holds references to all its children using an array.
public class TreeNode<T> {
    
    public var value: T
    public var children: [TreeNode] = []
    
    public init(_ value: T) {
        self.value = value
    }
    
    /// Adds a child node to the children array for the TreeNode
    public func add(_ child: TreeNode) {
        children.append(child)
    }
}

extension TreeNode {
    /// Uses simple recursion to visit every child node (depth first)
    public func forEachDepthFirst(visit: (TreeNode) -> Void) {
        visit(self)
        children.forEach {
            $0.forEachDepthFirst(visit: visit)
        }
    }
}

extension TreeNode {
    /// Uses simple recursion to visit every level node (left to right) before diving one level deeper (also left to right)
    public func forEachLevelOrder(visit: (TreeNode) -> Void) {
        visit(self)
        var queue = Queue<TreeNode>()
        children.forEach { queue.enqueue($0) }
        while let node = queue.dequeue() {
            visit(node)
            node.children.forEach { queue.enqueue($0) }
        }
    }
}

extension TreeNode where T: Equatable {
    public func search(_ value: T) -> TreeNode? {
        var result: TreeNode?
        forEachLevelOrder { node in
            if node.value == value {
                result = node
            }
        }
        return result
    }
}

// MARK: - EXAMPLES
func makeBeverageTree() -> TreeNode<String> {
    let tree = TreeNode("Beverages:")
    
    let hot = TreeNode("Hot:")
    let cold = TreeNode("Cold:")
    
    let tea = TreeNode("tea")
    let coffee = TreeNode("coffee")
    let chocolate = TreeNode("cocoa")
    
    let blackTea = TreeNode("black")
    let greenTea = TreeNode("green")
    let chaiTea = TreeNode("chai")
    
    let soda = TreeNode("soda")
    let milk = TreeNode("milk")
    
    let gingerAle = TreeNode("ginger ale")
    let bitterLemon = TreeNode("bitter lemon")
    
    tree.add(hot)
    tree.add(cold)
    
    hot.add(tea)
    hot.add(coffee)
    hot.add(chocolate)
    
    cold.add(soda)
    cold.add(milk)
    
    tea.add(blackTea)
    tea.add(greenTea)
    tea.add(chaiTea)
    
    soda.add(gingerAle)
    soda.add(bitterLemon)
    
    return tree
}
let tree = makeBeverageTree()
// Depth-First
tree.forEachDepthFirst { print($0.value) }
// Bredth-First
tree.forEachLevelOrder { print($0.value) }

if let searchResult1 = tree.search("ginger ale") {
    print("\nFound node: \(searchResult1.value)")
}

if let searchResult2 = tree.search("WKD Blue") {
    print(searchResult2.value)
} else {
    print("Couldn't find WKD Blue")
}

// MARK: - CHALLENGES
// Challenge 1.
// Print all the values in a tree in an order based on their level. Nodes belonging in the same level should be printed in the same line. For example, consider the following tree:

func makeNumberTree() -> TreeNode<Int> {
    let root = TreeNode(1)
    let secondLevel₁ = TreeNode(2)
    let secondLevel₂ = TreeNode(3)
    let secondLevel₃ = TreeNode(4)
    let thirdLevel₁ = TreeNode(5)
    let thirdLevel₂ = TreeNode(6)
    let thirdLevel₃ = TreeNode(7)
    let thirdLevel₄ = TreeNode(8)
    let thirdLevel₅ = TreeNode(9)
    let thirdLevel₆ = TreeNode(10)
    root.add(secondLevel₁)
    root.add(secondLevel₂)
    root.add(secondLevel₃)
    secondLevel₁.add(thirdLevel₁)
    secondLevel₁.add(thirdLevel₂)
    secondLevel₂.add(thirdLevel₃)
    secondLevel₂.add(thirdLevel₂)
    secondLevel₃.add(thirdLevel₅)
    secondLevel₃.add(thirdLevel₆)
    
    return root
}


example(of: "Challenge 1") {
    let numberTree = makeNumberTree()
    numberTree.forEachLevelOrder { print($0.value) }
}
//: [Next](@next)
