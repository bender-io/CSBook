//: [Previous](@previous)

import Foundation

// Helper Data Structs
public class BinaryNode<Element> {
    public var value: Element
    public var leftChild: BinaryNode?
    public var rightChild: BinaryNode?
    
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
private extension BinaryNode {
    var min: BinaryNode {
        return leftChild?.min ?? self
    }
}

// BINARY SEARCH TREE
// ● A binary search tree, or BST, is a data structure that facilitates fast lookup, insert and removal operations.
// ● The value of a left child must be less than the value of its parent.
// ● Consequently, the value of a right child must be greater than or equal to the value of its parent.
// Binary search trees use this property to save you from performing unnecessary checking. As a result, lookup, insert and removal have an average time complexity of O(log n), which is considerably faster than linear data structures such as arrays and linked lists.

// LOOKUP:
// ● If the search value is less than the current value, it must be in the left subtree.
// ● If the search value value is greater than the current value, it must be in the right subtree.


// INSERTING:
// ● Similar to lookup, we can reduce an array's O(n) to O(log n) by using a binary search tree insert
// ● In accordance with the rules of the BST, nodes of the left child must contain values less than the current node. Nodes of the right child must contain values greater than or equal to the current node. You’ll implement the insert method while respecting these rules.

// REMOVE:
// ● Similar to inserting, we can reduce an array's O(n) to O(log n) by using a binary search tree remove
// ● Removing elements is a little more tricky, as there are a few different scenarios you need to handle.
// Case 1: Leaf Node
// ● Removing a leaf node is straightforward; simply detach the leaf node.
// Case 2: Nodes with One Child
// ● When removing nodes with one child, you’ll need to reconnect that one child with the rest of the tree:
// Case 3: Node with Two Children
// ● When removing a node with two children, replace the node you removed with smallest node in its right subtree. Based on the rules of the BST, this is the leftmost node of the right subtree:
// ● It’s important to note that this produces a valid binary search tree. Because the new node was the smallest node in the right subtree, all nodes in the right subtree will still be greater than or equal to the new node. And because the new node came from the right subtree, all nodes in the left subtree will be less than the new node.

// KEY POINTS:
// ● By definition, binary search trees can only hold values that are Comparable.
// ● The binary search tree is a powerful data structure for holding sorted data.
// ● Average performance for insert, remove and contains methods in a BST is O(log n).
// ● Performance will degrade to O(n) as the tree becomes unbalanced. This is undesireable, so you'll learn about a self-balancing binary search tree called the AVL tree in the next chapter.”

public struct BinarySearchTree<Element: Comparable> {
    public private(set) var root: BinaryNode<Element>?
    public init(){}
}

extension BinarySearchTree: CustomStringConvertible {
    public var description: String {
        guard let root = root else { return "empty tree" }
        return String(describing: root)
    }
}

// MARK: - Insert Methods
extension BinarySearchTree {
    // Public insert method exposed to the users for use
    public mutating func insert(_ value: Element) {
        root = insert(from: root, value: value)
    }
    
    // Private helper insert method
    /// O(log n) Insertion:
    /// 1. If the current node is nil, you’ve found the insertion point and you return the new BinaryNode.
    /// 2. If the new value is less than the current value, you call insert on the left child. If the new value is greater than or equal to the current value, you’ll call insert on the right child.
    /// 3. Return the current node. This makes assignments of the form node = insert(from: node, value: value) possible as insert will either create node (if it was nil) or return node (it it was not nil).
    private func insert(from node: BinaryNode<Element>?, value: Element) -> BinaryNode<Element> {
        guard let node = node else { return BinaryNode(value: value) }
        
        if value < node.value {
            node.leftChild = insert(from: node.leftChild, value: value)
        } else {
            node.rightChild = insert(from: node.rightChild, value: value)
        }
        
        return node
    }
}

// MARK: - Contains Methods
extension BinarySearchTree {
    
    /// O(log n) Contains: Traverses through the tree in-order and returns true if the value is found
    /// 1. Start by setting current to the root node. While current is not nil, check the current node’s value.
    /// 2. If the value is equal to what you’re trying to find, return true.
    /// 3. Otherwise, decide whether you’re going to check the left or the right child.
    public func contains(_ value: Element) -> Bool {
        var current = root
        
        while let node = current {
            if node.value == value {
                return true
            } else if value < node.value {
                current = node.leftChild
            } else {
                current = node.rightChild
            }
        }
        return false
    }
}

// MARK: - Remove Methods
extension BinarySearchTree {
    /// Public remove method for users
    public mutating func remove(_ value: Element) {
        root = remove(node: root, value: value)
    }
    
    // Private helper
    /// O(log n) Removal: Similar to insert, but with different leaf cases:
    /// 1. In the case in which the node is a leaf node, you simply return nil, thereby removing the current node.
    /// 2. If the node has no left child, you return node.rightChild to reconnect the right subtree.
    /// 3. If the node has no right child, you return node.leftChild to reconnect the left subtree.
    /// 4. This is the case in which the node to be removed has both a left and right child. You replace the node’s value with the smallest value from the right subtree. You then call remove on the right child to remove this swapped value.
    private func remove(node: BinaryNode<Element>?, value: Element) -> BinaryNode<Element>? {
        guard let node = node else { return nil }
        
        if value == node.value {
            if node.leftChild == nil && node.rightChild == nil {
                return nil
            }
            if node.leftChild == nil {
                return node.rightChild
            }
            if node.rightChild == nil {
                return node.leftChild
            }
            node.value = node.rightChild!.min.value
            node.rightChild = remove(node: node.rightChild, value: node.value)
        } else if value < node.value {
            node.leftChild = remove(node: node.leftChild, value: value)
        } else {
            node.rightChild = remove(node: node.rightChild, value: value)
        }
        return node
    }
}

var bst = BinarySearchTree<Int>()
for i in 0..<5 {
    bst.insert(i)
}
print("Unbalanced Tree:\n\(bst)")
// ● That tree looks a bit unbalanced, but it does follow the rules. However, this tree layout has undesirable consequences. When working with trees, you always want to achieve a balanced format:

var exampleTree: BinarySearchTree<Int> {
    var bst = BinarySearchTree<Int>()
    bst.insert(3)
    bst.insert(1)
    bst.insert(4)
    bst.insert(0)
    bst.insert(2)
    bst.insert(5)
    
    return bst
}
print("Balanced Tree:\n\(exampleTree)")
print("Contains 5?:\n\(exampleTree.contains(18))\n")

var tree = exampleTree
print("Tree before removal:")
print(tree)
tree.remove(3)
print("Tree after removing root:")
print(tree)


// Binary Search Tree - O(log n) - Sean Allan example
var sortedArray = [2, 4, 5, 6, 7, 9, 10, 13, 14, 16, 22, 25]

func searchBinaryArray(for key: Int, in array: [Int]) -> Bool {
    let minIndex = 0
    let maxIndex = array.count - 1
    let midIndex = maxIndex / 2
    let midValue = array[midIndex]

    print(array)

    if key > array[maxIndex] || key < array[minIndex] {
        return false
    } else if key > midValue {
        let slice = Array(array[midIndex + 1...maxIndex])
        return searchBinaryArray(for: key, in: slice)
    } else if key < midValue {
        let slice = Array(array[minIndex...midIndex - 1])
        return searchBinaryArray(for: key, in: slice)
    } else if key == midValue {
        return true
    }
    return false
}
searchBinaryArray(for: 8, in: sortedArray)

//: [Next](@next)



