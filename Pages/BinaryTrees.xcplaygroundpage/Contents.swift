//: [Previous](@previous)

import Foundation

// BINARY TREES:
// • A binary tree is a tree in which each node has at most two children, often referred to as the left and right children

// TRAVERSAL ALGORYTHMS:

// 1 In Order Traversal:
// • In-order traversal visits the nodes of a binary tree in the following order, starting from the root node:
// • If the current node has a left child, recursively visit this child first
// • Then visit the node itself
// • If the current node has a right child, recursively visit this child
// • If the tree nodes are structured in a certain way, in-order traversal visits them in ascending order

// 2 Pre Order Traversal:
// • Pre-order traversal always visits the current node first, then recursively visits the left and right child

// 3 Post-Order Traversal:
// • Post-order traversal only visits the current node after the left and right child have been visited recursively.

// KEY POINTS
// • Each one of these traversal algorithms has both a time and space complexity of O(n)
// • In-order traversal can be used to visit the nodes in ascending order
// • The binary tree is the foundation to some of the most important tree structures. The binary search tree and AVL tree are binary trees that impose restrictions on the insertion/deletion behaviors
// • In-order, pre-order and post-order traversals aren't just important only for the binary tree; if you're processing data in any tree, you'll interface with these traversals regularly

public class BinaryNode<Element> {
    public var value: Element
    public var leftChild: BinaryNode?
    public var rightChild: BinaryNode?
    private var height: Int?
    
    public init(value: Element) {
        self.value = value
    }
}

extension BinaryNode {
    
    /// First traverses the left-most node before visiting the value. Then traverse to the right-most node
    public func traverseInOrder(visit: (Element) -> Void) {
        leftChild?.traverseInOrder(visit: visit)
        visit(value)
        rightChild?.traverseInOrder(visit: visit)
    }
    
    /// First visits the current node. Then recursively traverses left to right.
    public func traversePreOrder(visit: (Element) -> Void) {
        visit(value)
        leftChild?.traversePreOrder(visit: visit)
        rightChild?.traversePreOrder(visit: visit)
    }
    
    /// First visists left and right child. Then visits self.
    public func traversePostOrder(visit: (Element) -> Void) {
        leftChild?.traversePostOrder(visit: visit)
        rightChild?.traversePostOrder(visit: visit)
        visit(value)
    }
}

extension BinaryNode: CustomStringConvertible {
    public var description: String {
        return diagram(for: self)
    }
    
    private func diagram(for node: BinaryNode?, _ top: String = "", _ root: String = "", _ bottom: String = "") -> String {
        guard let node = node else { return root + "nil\n" }
        
        if node.leftChild == nil && node.rightChild == nil {
            return root + "\(node.value)\n"
        }
        
        return diagram(for: node.rightChild, top + " ", top + "┌──", top + "│ ")
            + root + "\(node.value)\n"
            + diagram(for: node.leftChild, bottom + "│ ", bottom + "└──", bottom + " ")
    }
}

// EXAMPLES
var tree: BinaryNode<Int> = {
    let zero = BinaryNode(value: 0)
    let one = BinaryNode(value: 1)
    let two = BinaryNode(value: 2)
    let three = BinaryNode(value: 3)
    let four = BinaryNode(value: 4)
    let five = BinaryNode(value: 5)
    let six = BinaryNode(value: 6)
    let seven = BinaryNode(value: 7)
    let eight = BinaryNode(value: 8)
    let nine = BinaryNode(value: 9)
    
    seven.leftChild = one
    seven.rightChild = nine
    
    one.leftChild = zero
    one.rightChild = five
    nine.leftChild = eight
    nine.rightChild = two
    
    zero.leftChild = three
    zero.rightChild = four
    five.leftChild = six
    
    return seven
}()
print(tree)
var inOrderTraversal: [Int] = []
var preOrderTraversal: [Int] = []
var postOrderTraversal: [Int] = []
tree.traverseInOrder { inOrderTraversal.append($0) }
tree.traversePreOrder { preOrderTraversal.append($0) }
tree.traversePostOrder { postOrderTraversal.append($0) }
print("In-Order Traversal: Left -> Self -> Right:\n\(inOrderTraversal)")
print("\nPre-Ordered Traversal: Self -> Left -> Right:\n\(preOrderTraversal)")
print("\nPost-Ordered Traversal: Left -> Right -> Self:\n\(postOrderTraversal)")

// CHALLENEGES

// Challenge 1.
// • Given a binary tree, find the height of the tree. The height of the binary tree is determined by the distance between the root and the furthest leaf. The height of a binary tree with a single node is zero, since the single node is both the root and the furthest leaf

// Book Answer - Seems Slow
//func height(of node: BinaryNode<Int>?) -> Int {
//    guard let node = node else { return -1 }
//
//    return 1 + max(height(of: tree.leftChild), height(of: tree.rightChild))
//}
//
//print(height(of: tree))

// Challenge 2.
// • A common task in software development is serializing an object into another data type. This process is known as serialization, and allows custom types to be used in systems that only support a closed set of data types.
// • An example of serialization is JSON. Your task is to devise a way to serialize a binary tree into an array, and a way to deserialize the array back into the same binary tree.
// • To clarify this problem, consider the following binary tree:\

// • A particular algorithm may output the serialization as [15, 10, 5, nil, nil, 12, nil, nil, 25, 17, nil, nil, nil]. The deserialization process should transform the array back into the[…]

extension BinaryNode {
    
    public func traversePreOrderForSerialization(visit: (Element?) -> Void) {
        visit(value)
        if let leftChild = leftChild {
            leftChild.traversePreOrder(visit: visit)
        } else {
            visit(nil)
        }
        if let rightChild = rightChild {
            rightChild.traversePreOrder(visit: visit)
        } else {
            visit(nil)
        }
    }
}

func serialize<T>(_ node: BinaryNode<T>) -> [T?] {
    var array: [T?] = []
    node.traversePreOrderForSerialization { array.append($0) }
    return array
}

print(serialize(tree))

//: [Next](@next)
