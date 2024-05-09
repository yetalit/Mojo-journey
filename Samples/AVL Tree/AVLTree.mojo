from collections import Set
import math

struct Node:
    var key: Int
    var parent: Pointer[Node]
    var rightChild: Pointer[Node]
    var leftChild: Pointer[Node]
    var height: Int
    var size: Int

    fn __init__(inout self, key: Int):
        self.key = key
        self.parent = Pointer[Node].get_null()
        self.rightChild = Pointer[Node].get_null()
        self.leftChild = Pointer[Node].get_null()
        self.height = 0
        self.size = 1
        
    fn __str__(self) -> String:
        return str(self.key)
    
    fn is_leaf(self) -> Bool:
        return self.height == 0
    
    fn max_children_height(self) -> Int:
        if self.leftChild and self.rightChild:
            return math.max(self.leftChild[].height, self.rightChild[].height)
        if self.leftChild:
            return self.leftChild[].height
        if self.rightChild:
            return self.rightChild[].height
        return -1

    fn balance(self) -> Int:
        return (self.leftChild[].height if self.leftChild else -1) -\
               (self.rightChild[].height if self.rightChild else -1)

struct AVLTree:
    """
    __str__
        Args:
        Return a cute trees visualisation

        Examples::
    >>> var tree = AVLTree([1,2,3,4,5,6])
    >>> print(tree.__str__())
    >>>        4
    >>>       / \
    >>>      /   \
    >>>     /     \
    >>>    2       5
    >>>   / \\      \
    >>>  1   3       6

    height
        Args:
        Return AVLTree's height

        Examples::
    >>> var tree = AVLTree([1,2,3,4,5,6])
    >>> height = tree.height()
    >>> print(height)
    >>> 2

    find
        Args:
            key, node
        Return Node in node's subtree with this key

        Examples::
    >>> var tree = AVLTree([1,2,3,4,5,6])
    >>> tree.find(4)
    >>> print(tree.find(4))
    >>> 4
    >>> print(tree.find(7)) # return None
    >>> None


    find_biggest
        Args:
        Return biggest key in AVLTree

        Examples::
    >>> var tree = AVLTree([1,2,3,4,5,6])
    >>> tree.find_biggest()
    >>> 6

    find_smallest
        Args:
        Return smallest key in AVLTree

        Examples::
    >>> var tree = AVLTree([1,2,3,4,5,6])
    >>> tree.find_biggest()
    >>> 1

    as_list
        Args:
            type
        return AVLTrees keys in order depend on type:
            0 == preorder
            1 == inorder
            2 == postorder

        Examples::
    >>> var tree = AVLTree([1,2,3,4,5,6])
    >>> tree.as_list(0)
    >>> <4, 2, 1, 3, 5, 6>
    >>> tree.as_list(1)
    >>> <1, 2, 3, 4, 5, 6>
    >>> tree.as_list(2)
    >>> <1, 3, 2, 6, 5, 4>


    remove(key)
        Args: key
        return AVLTrees root without node, which val is equal key

        Examples::
    >>> var tree = AVLTree([1,2,3,4,5,6])
    >>> tree.remove(3)
    >>> print(tree)
    >>>        4
    >>>       / \
    >>>      /   \
    >>>     /     \
    >>>    2       5
    >>>   /         \
    >>>  1           6

    findkth
        Args: k, node
        return kth key in node's subtree

        Examples::
    >>> var tree = AVLTree([1,2,3,4,5,6])
    >>> tree.findkth(2)
    >>> 2
    >>> tree.findkth(2, tree.rootNode[].rightChild)
    >>> 6
    """
    
    var rootNode: Pointer[Node]
    var elements_count: Int
    var rebalance_count: Int

    fn __init__(inout self, h: object = []) raises:
        self.rootNode = Pointer[Node].get_null()
        self.elements_count = 0
        self.rebalance_count = 0
        for i in range(len(h)):
            self.insert(int(h[i]))

    fn __del__(owned self):
        if self.rootNode:
            self.delTree(self.rootNode)

    fn delTree(self, node: Pointer[Node]):
        if node[].leftChild:
            self.delTree(node[].leftChild)
        if node[].rightChild:
            self.delTree(node[].rightChild)
        node.free()

    fn height(self) -> Int:
        if self.rootNode:
            return self.rootNode[].height
        return -1
            
    fn find_in_subtree(self, key: Int, node: Pointer[Node]) -> Pointer[Node]:
        if not node:
            return Pointer[Node].get_null()  # key not found
        if key < node[].key:
            return self.find_in_subtree(key, node[].leftChild)
        if key > node[].key:
            return self.find_in_subtree(key, node[].rightChild)
        # key is equal to node key
        return node
        
    fn find(self, key: Int, owned node: Pointer[Node] = Pointer[Node].get_null()) -> Pointer[Node]:
        if not node:
            node = self.rootNode
        return self.find_in_subtree(key, node)
            
    fn recompute_heights(self, inout startNode: Pointer[Node]):
        var changed: Bool = True
        var node: Pointer[Node] = startNode
        while node and changed:
            var old_height: Int = node[].height
            node[].height = (node[].max_children_height() + 1 if
                           (node[].rightChild or node[].leftChild) else 0)
            changed = node[].height != old_height
            node = node[].parent

    fn find_biggest(self, start_node: Pointer[Node]) -> Pointer[Node]:
        var node: Pointer[Node] = start_node
        while node[].rightChild:
            node = node[].rightChild
        return node

    fn find_smallest(self, start_node: Pointer[Node]) -> Pointer[Node]:
        var node: Pointer[Node] = start_node
        while node[].leftChild:
            node = node[].leftChild
        return node

    fn as_list(self, type: Int = 1) -> List[Int]:
        if not self.rootNode:
            return List[Int]()
        
        if type == 0:
            return self.preorder(self.rootNode)
        elif type == 1:
            return self.inorder(self.rootNode)
        return self.postorder(self.rootNode)

    fn preorder(self, node: Pointer[Node], owned retlst: List[Int] = List[Int]()) -> List[Int]:
        retlst.append(node[].key)
        if node[].leftChild:
            retlst = self.preorder(node[].leftChild, retlst)
        if node[].rightChild:
            retlst = self.preorder(node[].rightChild, retlst)
        return retlst

    fn inorder(self, node: Pointer[Node], owned retlst: List[Int] = List[Int]()) -> List[Int]:
        if node[].leftChild:
            retlst = self.inorder(node[].leftChild, retlst)
        retlst.append(node[].key)
        if node[].rightChild:
            retlst = self.inorder(node[].rightChild, retlst)
        return retlst

    fn postorder(self, node: Pointer[Node], owned retlst: List[Int] = List[Int]()) -> List[Int]:
        if node[].leftChild:
            retlst = self.postorder(node[].leftChild, retlst)
        if node[].rightChild:
            retlst = self.postorder(node[].rightChild, retlst)
        retlst.append(node[].key)
        return retlst

    fn add_as_child(inout self, parent_node: Pointer[Node], child_node: Pointer[Node]):
        var node_to_rebalance: Pointer[Node] = Pointer[Node].get_null()
        parent_node[].size += 1
        if child_node[].key < parent_node[].key:
            if not parent_node[].leftChild:
                parent_node[].leftChild = child_node
                child_node[].parent = parent_node
                if parent_node[].height == 0: # in this case trees height could change
                    var node: Pointer[Node] = parent_node
                    while node:
                        node[].height = node[].max_children_height() + 1
                        if not node[].balance() in Set[Int](-1, 0, 1):
                            node_to_rebalance = node
                            break 
                        node = node[].parent
            else:
                self.add_as_child(parent_node[].leftChild, child_node)
        else:
            if not parent_node[].rightChild:
                parent_node[].rightChild = child_node
                child_node[].parent = parent_node
                if parent_node[].height == 0: # in this case trees height could change
                    var node: Pointer[Node] = parent_node
                    while node:
                        node[].height = node[].max_children_height() + 1
                        if not node[].balance() in Set[Int](-1, 0, 1):
                            node_to_rebalance = node
                            break 
                        node = node[].parent
            else:
                self.add_as_child(parent_node[].rightChild, child_node)

        if node_to_rebalance:
            self.rebalance(node_to_rebalance)

    fn insert(inout self, key: Int):
        var new_node = Pointer[Node].alloc(1)
        new_node[] = Node(key)
        if not self.rootNode:
            self.rootNode = new_node
            debug_assert(self.elements_count == 0, 'Wrong elements_count')
            self.elements_count += 1
        else:
            if not self.find(key):
                self.elements_count += 1
                self.add_as_child(self.rootNode, new_node)

    fn remove_branch(inout self, inout node: Pointer[Node]):
        var parent: Pointer[Node] = node[].parent
        if (parent):
            if parent[].leftChild == node:
                parent[].leftChild = node[].rightChild or node[].leftChild
            else:
                parent[].rightChild = node[].rightChild or node[].leftChild
            if node[].leftChild:
                node[].leftChild[].parent = parent
            else:
                node[].rightChild[].parent = parent
            self.recompute_heights(parent)
        node.free()
       
        # rebalance
        node = parent
        while (node):
            self.resize(node)
            if not node[].balance() in Set[Int](-1, 0, 1):
                self.rebalance(node)
            node = node[].parent

    fn remove_leaf(inout self, inout node: Pointer[Node]):
        var parent: Pointer[Node] = node[].parent
        if (parent):
            if parent[].leftChild == node:
                parent[].leftChild = Pointer[Node].get_null()
            else:
                parent[].rightChild = Pointer[Node].get_null()
            self.recompute_heights(parent)
        else:
            self.rootNode = Pointer[Node].get_null()
        node.free()
        
        # rebalance    
        node = parent
        while (node):
            self.resize(node)            
            if not node[].balance() in Set[Int](-1, 0, 1):
                self.rebalance(node)
            node = node[].parent

    fn remove(inout self, key: Int):
        var node: Pointer[Node] = self.find(key)

        if node:
            self.elements_count -= 1
            if node[].is_leaf():
                self.remove_leaf(node)
            elif (node[].leftChild.__bool__()) ^ (node[].rightChild.__bool__()):
                self.remove_branch(node)
            else:
                self.swap_with_successor_and_remove(node)

    fn swap_with_successor_and_remove(inout self, inout node: Pointer[Node]):
        var successor: Pointer[Node] = self.find_smallest(node[].rightChild)
        self.swap_nodes(node, successor)
        if node[].height == 0:
            self.remove_leaf(node)
        else:
            self.remove_branch(node)

    fn swap_nodes(inout self, node1: Pointer[Node], node2: Pointer[Node]):
        var parent1: Pointer[Node] = node1[].parent
        var leftChild1: Pointer[Node] = node1[].leftChild
        var rightChild1: Pointer[Node] = node1[].rightChild
        var parent2: Pointer[Node] = node2[].parent
        var leftChild2: Pointer[Node] = node2[].leftChild
        var rightChild2: Pointer[Node] = node2[].rightChild

        # swap heights
        var tmpInt: Int = node1[].height
        node1[].height = node2[].height
        node2[].height = tmpInt

        #swap sizes
        tmpInt = node1[].size
        node1[].size = node2[].size
        node2[].size = tmpInt

        if parent1:
            if parent1[].leftChild == node1:
                parent1[].leftChild = node2
            else:
                parent1[].rightChild = node2
            node2[].parent = parent1
        else:
            self.rootNode = node2
            node2[].parent = Pointer[Node].get_null()

        node2[].leftChild = leftChild1
        leftChild1[].parent = node2

        node1[].leftChild = leftChild2
        node1[].rightChild = rightChild2
        if rightChild2:
            rightChild2[].parent = node1
            
        if not (parent2 == node1):
            node2[].rightChild = rightChild1
            rightChild1[].parent = node2
            parent2[].leftChild = node1
            node1[].parent = parent2
        else:
            node2[].rightChild = node1
            node1[].parent = node2

    fn resize(self, node: Pointer[Node]):
        node[].size = 1
        if node[].rightChild:
            node[].size += node[].rightChild[].size
        if node[].leftChild:
            node[].size += node[].leftChild[].size
        
    fn rebalance(inout self, node_to_rebalance: Pointer[Node]):
        self.rebalance_count += 1
        var A: Pointer[Node] = node_to_rebalance
        var F: Pointer[Node] = A[].parent
        
        if node_to_rebalance[].balance() == -2:
            if node_to_rebalance[].rightChild[].balance() <= 0:
                """Rebalance, ase RRC """
                var B: Pointer[Node] = A[].rightChild
                var C: Pointer[Node] = B[].rightChild
                A[].rightChild = B[].leftChild
                if A[].rightChild:
                    A[].rightChild[].parent = A
                B[].leftChild = A
                A[].parent = B
                if not F:
                    self.rootNode = B
                    self.rootNode[].parent = Pointer[Node].get_null()
                else:
                    if F[].rightChild == A:
                        F[].rightChild = B
                    else:
                        F[].leftChild = B
                    B[].parent = F
            
                self.recompute_heights(A)                                                                                        
                self.resize(A)
                self.resize(B)
                self.resize(C)
            else:
                """Rebalance, case RLC """
                var B: Pointer[Node] = A[].rightChild
                var C: Pointer[Node] = B[].leftChild
                B[].leftChild = C[].rightChild
                if B[].leftChild:
                    B[].leftChild[].parent = B
                A[].rightChild = C[].leftChild
                if A[].rightChild:
                    A[].rightChild[].parent = A
                C[].rightChild = B
                B[].parent = C
                C[].leftChild = A
                A[].parent = C
                if not F:
                    self.rootNode = C
                    self.rootNode[].parent = Pointer[Node].get_null()
                else:
                    if F[].rightChild == A:
                        F[].rightChild = C
                    else:
                        F[].leftChild = C
                    C[].parent = F
                
                self.recompute_heights(A)
                self.recompute_heights(B)
                self.resize(A)
                self.resize(B)
                self.resize(C)
                
        else:
            if node_to_rebalance[].leftChild[].balance() >= 0:
                """Rebalance, case LLC """
                var B: Pointer[Node] = A[].leftChild
                var C: Pointer[Node] = B[].leftChild
                A[].leftChild = B[].rightChild
                if (A[].leftChild):
                    A[].leftChild[].parent = A
                B[].rightChild = A
                A[].parent = B
                if not F:
                    self.rootNode = B
                    self.rootNode[].parent = Pointer[Node].get_null()
                else:
                    if F[].rightChild == A:
                        F[].rightChild = B
                    else:
                        F[].leftChild = B
                    B[].parent = F
                 
                self.recompute_heights(A)
                self.resize(A)
                self.resize(C)
                self.resize(B)
                
            else:
                """Rebalance, case LRC """
                var B: Pointer[Node] = A[].leftChild
                var C: Pointer[Node] = B[].rightChild
                A[].leftChild = C[].rightChild
                if A[].leftChild:
                    A[].leftChild[].parent = A
                B[].rightChild = C[].leftChild
                if B[].rightChild:
                    B[].rightChild[].parent = B
                C[].leftChild = B
                B[].parent = C
                C[].rightChild = A
                A[].parent = C
                if not F:
                    self.rootNode = C
                    self.rootNode[].parent = Pointer[Node].get_null()
                else:
                    if (F[].rightChild == A):
                        F[].rightChild = C
                    else:
                        F[].leftChild = C
                    C[].parent = F
                
                self.recompute_heights(A)
                self.recompute_heights(B)
                self.resize(A)
                self.resize(B)
                self.resize(C)         
                 
    fn findkth(self, k: Int, owned root: Pointer[Node] = Pointer[Node].get_null()) -> Int:
        if not root:
            root = self.rootNode
        debug_assert(k <= root[].size, 'Error, k more then the size of BST')
        var leftsize: Int = 0 if not root[].leftChild else root[].leftChild[].size
        if leftsize >= k:
            return self.findkth(k, root[].leftChild)
        elif leftsize == (k - 1):
            return root[].key
        else:
            return self.findkth(k - leftsize - 1, root[].rightChild)    

    fn __str__(self, owned start_node: Pointer[Node] = Pointer[Node].get_null()) -> String:
        if not start_node:
            start_node = self.rootNode
        var space_symbol: String = r" "
        var spaces_count: Int = 4 * 2**(self.rootNode[].height)
        var out_string: String = r""
        var initial_spaces_string: String = ""
        for i in range(spaces_count):
            initial_spaces_string += space_symbol
        initial_spaces_string += "\n"
        if not start_node:
            return "Tree is empty"
        var height: Int = 2 ** (self.rootNode[].height)
        var level = List[Pointer[Node]]()
        level.append(start_node)
        var notNullCount: Int = 1

        while (notNullCount > 0):
            var level_string: String = initial_spaces_string
            for i in range(len(level)):
                if (level[i]):
                    var j: Int = int((2 * i + 1) * spaces_count / (2 * len(level)))
                    level_string = level_string[:j] + (
                        level[i][] if level[i] else space_symbol) + level_string[j +
                                                                            1:]

            out_string += level_string

            var level_next = List[Pointer[Node]]()
            notNullCount = 0
            for node in level:
                if node[]:
                    level_next.append(node[][].leftChild)
                    level_next.append(node[][].rightChild)
                    if node[][].leftChild:
                        notNullCount += 1
                    if node[][].rightChild:
                        notNullCount += 1
                else:
                    level_next.append(Pointer[Node].get_null())
                    level_next.append(Pointer[Node].get_null())
            for w in range(height-1):
                var level_string: String = initial_spaces_string
                for i in range(len(level)):
                    if level[i]:
                        var shift: Int = spaces_count//(2*len(level))
                        var j: Int = (2 * i + 1) * shift
                        level_string = level_string[:j - w - 1] + (
                            '/' if level[i][].leftChild else
                            space_symbol) + level_string[j - w:]
                        level_string = level_string[:j + w + 1] + (
                            '\\' if level[i][].rightChild else
                            space_symbol) + level_string[j + w:]
                out_string += level_string
            height = height // 2
            level = level_next

        return out_string
