from collections import Set

@register_passable
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
            return math.max(self.leftChild.load().height, self.rightChild.load().height)
        if self.leftChild:
            return self.leftChild.load().height
        if self.rightChild:
            return self.rightChild.load().height
        return -1

    fn balance(self) -> Int:
        return (self.leftChild.load().height if self.leftChild else -1) -\
               (self.rightChild.load().height if self.rightChild else -1)

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
    >>>   / \\       \
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

    as_vector
        Args:
            type
        return AVLTrees keys in order depend on type:
            0 == preorder
            1 == inorder
            2 == postorder

        Examples::
    >>> var tree = AVLTree([1,2,3,4,5,6])
    >>> tree.as_vector(0)
    >>> <4, 2, 1, 3, 5, 6>
    >>> tree.as_vector(1)
    >>> <1, 2, 3, 4, 5, 6>
    >>> tree.as_vector(2)
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
    >>> tree.findkth(2,tree.rootNode.rightChild)
    >>> 6
    """
    
    var rootNode: Pointer[Node]
    var elements_count: Int
    var rebalance_count: Int

    fn __init__(inout self, h:object = []) raises:
        self.rootNode = Pointer[Node].get_null()
        self.elements_count = 0
        self.rebalance_count = 0
        for i in range(h.__len__()):
            self.insert(int(h[i]))

    fn __del__(owned self):
        if self.rootNode:
            self.delTree(self.rootNode)

    fn delTree(self, node: Pointer[Node]):
        if node.load().leftChild:
            self.delTree(node.load().leftChild)
        if node.load().rightChild:
            self.delTree(node.load().rightChild)
        node.free()

    fn height(self) -> Int:
        if self.rootNode:
            return self.rootNode.load().height
        return -1
            
    fn find_in_subtree(self, key: Int, node: Pointer[Node]) -> Pointer[Node]:
        if not node:
            return Pointer[Node].get_null()  # key not found
        if key < node.load().key:
            return self.find_in_subtree(key, node.load().leftChild)
        if key > node.load().key:
            return self.find_in_subtree(key, node.load().rightChild)
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
            var old_height: Int = node.load().height
            var tmp: Node = node.load()
            tmp.height = (node.load().max_children_height() + 1 if
                           (node.load().rightChild or node.load().leftChild) else 0)
            node.store(tmp)
            changed = node.load().height != old_height
            node = node.load().parent

    fn find_biggest(self, start_node: Pointer[Node]) -> Pointer[Node]:
        var node: Pointer[Node] = start_node
        while node.load().rightChild:
            node = node.load().rightChild
        return node

    fn find_smallest(self, start_node: Pointer[Node]) -> Pointer[Node]:
        var node: Pointer[Node] = start_node
        while node.load().leftChild:
            node = node.load().leftChild
        return node

    fn as_vector(self, type: Int=1) -> DynamicVector[Int]:
        if not self.rootNode:
            return DynamicVector[Int]()
        
        debug_assert(type in Set[Int](0, 1, 2), 'wrong type value')
        
        if type == 0:
            return self.preorder(self.rootNode)
        elif type == 1:
            return self.inorder(self.rootNode)
        else:
            return self.postorder(self.rootNode)

    fn preorder(self, node: Pointer[Node], owned retlst:DynamicVector[Int] = DynamicVector[Int]()) -> DynamicVector[Int]:
        retlst.append(node.load().key)
        if node.load().leftChild:
            retlst = self.preorder(node.load().leftChild, retlst)
        if node.load().rightChild:
            retlst = self.preorder(node.load().rightChild, retlst)
        return retlst

    fn inorder(self, node: Pointer[Node], owned retlst:DynamicVector[Int] = DynamicVector[Int]()) -> DynamicVector[Int]:
        if node.load().leftChild:
            retlst = self.inorder(node.load().leftChild, retlst)
        retlst.append(node.load().key)
        if node.load().rightChild:
            retlst = self.inorder(node.load().rightChild, retlst)
        return retlst

    fn postorder(self, node: Pointer[Node], owned retlst:DynamicVector[Int] = DynamicVector[Int]()) -> DynamicVector[Int]:
        if node.load().leftChild:
            retlst = self.postorder(node.load().leftChild, retlst)
        if node.load().rightChild:
            retlst = self.postorder(node.load().rightChild, retlst)
        retlst.append(node.load().key)
        return retlst

    fn add_as_child(inout self, parent_node: Pointer[Node], child_node: Pointer[Node]):
        var node_to_rebalance: Pointer[Node] = Pointer[Node].get_null()
        var tmp: Node = parent_node.load()
        tmp.size += 1
        parent_node.store(tmp)
        if child_node.load().key < parent_node.load().key:
            if not parent_node.load().leftChild:
                tmp = parent_node.load()
                tmp.leftChild = child_node
                parent_node.store(tmp)

                tmp = child_node.load()
                tmp.parent = parent_node
                child_node.store(tmp)
                if parent_node.load().height == 0: # in this case trees height could change
                    var node: Pointer[Node] = parent_node
                    while node:
                        tmp = node.load()
                        tmp.height = tmp.max_children_height() + 1
                        node.store(tmp)
                        if not node.load().balance() in Set[Int](-1, 0, 1):
                            node_to_rebalance = node
                            break 
                        node = node.load().parent
            else:
                self.add_as_child(parent_node.load().leftChild, child_node)
        else:
            if not parent_node.load().rightChild:
                tmp = parent_node.load()
                tmp.rightChild = child_node
                parent_node.store(tmp)

                tmp = child_node.load()
                tmp.parent = parent_node
                child_node.store(tmp)
                if parent_node.load().height == 0: # in this case trees height could change
                    var node: Pointer[Node] = parent_node
                    while node:
                        tmp = node.load()
                        tmp.height = tmp.max_children_height() + 1
                        node.store(tmp)
                        if not node.load().balance() in Set[Int](-1, 0, 1):
                            node_to_rebalance = node
                            break 
                        node = node.load().parent
            else:
                self.add_as_child(parent_node.load().rightChild, child_node)

        if node_to_rebalance:
            self.rebalance(node_to_rebalance)

    fn insert(inout self, key: Int):
        var new_node = Pointer[Node].alloc(1)
        new_node.store(Node(key))
        if not self.rootNode:
            self.rootNode = new_node
            debug_assert(self.elements_count == 0, 'Wrong elements_count')
            self.elements_count += 1
        else:
            if not self.find(key):
                self.elements_count += 1
                self.add_as_child(self.rootNode, new_node)

    fn remove_branch(inout self, inout node: Pointer[Node]):
        var parent: Pointer[Node] = node.load().parent
        if (parent):
            var tmp: Node = parent.load()
            if tmp.leftChild == node:
                tmp.leftChild = node.load().rightChild or node.load().leftChild
            else:
                tmp.rightChild = node.load().rightChild or node.load().leftChild
            parent.store(tmp)
            if node.load().leftChild:
                tmp = node.load().leftChild.load()
                tmp.parent = parent
                node.load().leftChild.store(tmp)
            else:
                tmp = node.load().rightChild.load()
                tmp.parent = parent
                node.load().rightChild.store(tmp)
            self.recompute_heights(parent)
        node.free()
       
        # rebalance
        node = parent
        while (node):
            self.resize(node)
            if not node.load().balance() in Set[Int](-1, 0, 1):
                self.rebalance(node)
            node = node.load().parent

    fn remove_leaf(inout self, inout node: Pointer[Node]):
        var parent: Pointer[Node] = node.load().parent
        if (parent):
            var tmp: Node = parent.load()
            if tmp.leftChild == node:
                tmp.leftChild = Pointer[Node].get_null()
            else:
                tmp.rightChild = Pointer[Node].get_null()
            parent.store(tmp)
            self.recompute_heights(parent)
        else:
            self.rootNode = Pointer[Node].get_null()
        node.free()
        
        # rebalance    
        node = parent
        while (node):
            self.resize(node)            
            if not node.load().balance() in Set[Int](-1, 0, 1):
                self.rebalance(node)
            node = node.load().parent

    fn remove(inout self, key: Int):
        var node: Pointer[Node] = self.find(key)

        if node:
            self.elements_count -= 1
            if node.load().is_leaf():
                self.remove_leaf(node)
            elif (node.load().leftChild.__bool__()) ^ (node.load().rightChild.__bool__()):
                self.remove_branch(node)
            else:
                self.swap_with_successor_and_remove(node)

    fn swap_with_successor_and_remove(inout self, inout node: Pointer[Node]):
        var successor: Pointer[Node] = self.find_smallest(node.load().rightChild)
        self.swap_nodes(node, successor)
        if node.load().height == 0:
            self.remove_leaf(node)
        else:
            self.remove_branch(node)

    fn swap_nodes(inout self, node1: Pointer[Node], node2: Pointer[Node]):
        var parent1: Pointer[Node] = node1.load().parent
        var leftChild1: Pointer[Node] = node1.load().leftChild
        var rightChild1: Pointer[Node] = node1.load().rightChild
        var parent2: Pointer[Node] = node2.load().parent
        var leftChild2: Pointer[Node] = node2.load().leftChild
        var rightChild2: Pointer[Node] = node2.load().rightChild

        # swap heights
        var tmp1: Node = node1.load()
        var tmp2: Node = node2.load()
        var tmpInt: Int = tmp1.height
        tmp1.height = tmp2.height
        tmp2.height = tmpInt

        #swap sizes
        tmpInt = tmp1.size
        tmp1.size = tmp2.size
        tmp2.size = tmpInt

        var tmp: Node
        if parent1:
            tmp = parent1.load()
            if tmp.leftChild == node1:
                tmp.leftChild = node2
            else:
                tmp.rightChild = node2
            parent1.store(tmp)
            tmp2.parent = parent1
        else:
            self.rootNode = node2
            tmp2.parent = Pointer[Node].get_null()

        tmp2.leftChild = leftChild1
        tmp = leftChild1.load()
        tmp.parent = node2
        leftChild1.store(tmp)

        tmp1.leftChild = leftChild2
        tmp1.rightChild = rightChild2
        if rightChild2:
            tmp = rightChild2.load()
            tmp.parent = node1
            rightChild2.store(tmp)
            
        if not (parent2 == node1):
            tmp2.rightChild = rightChild1
            tmp = rightChild1.load()
            tmp.parent = node2
            rightChild1.store(tmp)

            tmp = parent2.load()
            tmp.leftChild = node1
            parent2.store(tmp)
            tmp1.parent = parent2
        else:
            tmp2.rightChild = node1
            tmp1.parent = node2

        node1.store(tmp1)
        node2.store(tmp2)

    fn resize(self, node: Pointer[Node]):
        var tmp: Node = node.load()
        tmp.size = 1
        if tmp.rightChild:
            tmp.size += tmp.rightChild.load().size
        if tmp.leftChild:
            tmp.size += tmp.leftChild.load().size
        node.store(tmp)
        
    fn rebalance(inout self, node_to_rebalance: Pointer[Node]):
        self.rebalance_count += 1
        var A: Pointer[Node] = node_to_rebalance
        var tmpA: Node = A.load()
        var F: Pointer[Node] = tmpA.parent
        var tmpF: Node
        var tmp: Node
        var tmpB: Node
        var tmpC: Node
        
        if node_to_rebalance.load().balance() == -2:
            if node_to_rebalance.load().rightChild.load().balance() <= 0:
                """Rebalance, ase RRC """
                var B: Pointer[Node] = tmpA.rightChild
                tmpB = B.load()
                var C: Pointer[Node] = tmpB.rightChild
                tmpA.rightChild = tmpB.leftChild
                A.store(tmpA)
                tmpA = A.load()
                if tmpA.rightChild:
                    tmp = tmpA.rightChild.load()
                    tmp.parent = A
                    tmpA.rightChild.store(tmp)
                tmpB.leftChild = A
                B.store(tmpB)
                tmpB = B.load()
                tmpA.parent = B
                A.store(tmpA)
                if not F:
                    self.rootNode = B
                    tmp = self.rootNode.load()
                    tmp.parent = Pointer[Node].get_null()
                    self.rootNode.store(tmp)
                else:
                    tmpF = F.load()
                    if tmpF.rightChild == A:
                        tmpF.rightChild = B
                    else:
                        tmpF.leftChild = B
                    F.store(tmpF)
                    tmpB.parent = F
                    B.store(tmpB)
            
                self.recompute_heights(A)                                                                                        
                self.resize(A)
                self.resize(B)
                self.resize(C)
            else:
                """Rebalance, case RLC """
                var B: Pointer[Node] = tmpA.rightChild
                tmpB = B.load()
                var C: Pointer[Node] = tmpB.leftChild
                tmpC = C.load()
                tmpB.leftChild = tmpC.rightChild
                B.store(tmpB)
                tmpB = B.load()
                if tmpB.leftChild:
                    tmp = tmpB.leftChild.load()
                    tmp.parent = B
                    tmpB.leftChild.store(tmp)
                tmpA.rightChild = tmpC.leftChild
                A.store(tmpA)
                tmpA = A.load()
                if tmpA.rightChild:
                    tmp = tmpA.rightChild.load()
                    tmp.parent = A
                    tmpA.rightChild.store(tmp)
                tmpC.rightChild = B
                C.store(tmpC)
                tmpC = C.load()
                tmpB.parent = C
                B.store(tmpB)
                tmpC.leftChild = A
                C.store(tmpC)
                tmpC = C.load()
                tmpA.parent = C
                A.store(tmpA)
                if not F:
                    self.rootNode = C
                    tmp = self.rootNode.load()
                    tmp.parent = Pointer[Node].get_null()
                    self.rootNode.store(tmp)
                else:
                    tmpF = F.load()
                    if tmpF.rightChild == A:
                        tmpF.rightChild = C
                    else:
                        tmpF.leftChild = C
                    F.store(tmpF)
                    tmpC.parent = F
                    C.store(tmpC)
                
                self.recompute_heights(A)
                self.recompute_heights(B)
                self.resize(A)
                self.resize(B)
                self.resize(C)
                
        else:
            if node_to_rebalance.load().leftChild.load().balance() >= 0:
                """Rebalance, case LLC """
                var B: Pointer[Node] = tmpA.leftChild
                tmpB = B.load()
                var C: Pointer[Node] = tmpB.leftChild
                tmpA.leftChild = tmpB.rightChild
                A.store(tmpA)
                tmpA = A.load()
                if (tmpA.leftChild):
                    tmp = tmpA.leftChild.load()
                    tmp.parent = A
                    tmpA.leftChild.store(tmp)
                tmpB.rightChild = A
                B.store(tmpB)
                tmpB = B.load()
                tmpA.parent = B
                A.store(tmpA)
                if not F:
                    self.rootNode = B
                    tmp = self.rootNode.load()
                    tmp.parent = Pointer[Node].get_null()
                    self.rootNode.store(tmp)
                else:
                    tmpF = F.load()
                    if tmpF.rightChild == A:
                        tmpF.rightChild = B
                    else:
                        tmpF.leftChild = B
                    F.store(tmpF)
                    tmpB.parent = F
                    B.store(tmpB)
                 
                self.recompute_heights(A)
                self.resize(A)
                self.resize(C)
                self.resize(B)
                
            else:
                """Rebalance, case LRC """
                var B: Pointer[Node] = tmpA.leftChild
                tmpB = B.load()
                var C: Pointer[Node] = tmpB.rightChild
                tmpC = C.load()
                tmpA.leftChild = tmpC.rightChild
                A.store(tmpA)
                tmpA = A.load()
                if tmpA.leftChild:
                    tmp = tmpA.leftChild.load()
                    tmp.parent = A
                    tmpA.leftChild.store(tmp)
                tmpB.rightChild = tmpC.leftChild
                B.store(tmpB)
                tmpB = B.load()
                if tmpB.rightChild:
                    tmp = tmpB.rightChild.load()
                    tmp.parent = B
                    tmpB.rightChild.store(tmp)
                tmpC.leftChild = B
                C.store(tmpC)
                tmpC = C.load()
                tmpB.parent = C
                B.store(tmpB)
                tmpC.rightChild = A
                C.store(tmpC)
                tmpC = C.load()
                tmpA.parent = C
                A.store(tmpA)
                if not F:
                    self.rootNode = C
                    tmp = self.rootNode.load()
                    tmp.parent = Pointer[Node].get_null()
                    self.rootNode.store(tmp)
                else:
                    tmpF = F.load()
                    if (tmpF.rightChild == A):
                        tmpF.rightChild = C
                    else:
                        tmpF.leftChild = C
                    F.store(tmpF)
                    tmpC.parent = F
                    C.store(tmpC)
                
                self.recompute_heights(A)
                self.recompute_heights(B)
                self.resize(A)
                self.resize(B)
                self.resize(C)         
                 
    fn findkth(self, k: Int, owned root: Pointer[Node] = Pointer[Node].get_null()) -> Int:
        if not root:
            root = self.rootNode
        debug_assert(k <= root.load().size, 'Error, k more then the size of BST')
        var leftsize: Int = 0 if not root.load().leftChild else root.load().leftChild.load().size
        if leftsize >= k:
            return self.findkth(k, root.load().leftChild)

        elif leftsize == (k - 1):
            return root.load().key
        else:
            return self.findkth(k - leftsize - 1, root.load().rightChild)    

    fn __str__(self, owned start_node: Pointer[Node] = Pointer[Node].get_null()) -> String:
        if not start_node:
            start_node = self.rootNode
        var space_symbol: String = r" "
        var spaces_count: Int = 4 * 2**(self.rootNode.load().height)
        var out_string: String = r""
        var initial_spaces_string: String = ""
        for i in range(spaces_count):
            initial_spaces_string += space_symbol
        initial_spaces_string += "\n"
        if not start_node:
            return "Tree is empty"
        var height: Int = 2 ** (self.rootNode.load().height)
        var level = DynamicVector[Pointer[Node]]()
        level.append(start_node)
        var notNullCount: Int = 1

        while (notNullCount > 0):
            var level_string: String = initial_spaces_string
            for i in range(len(level)):
                if (level[i]):
                    var j: Int = int((2 * i + 1) * spaces_count / (2 * len(level)))
                    level_string = level_string[:j] + (
                        level[i].load().__str__() if level[i] else space_symbol) + level_string[j +
                                                                            1:]

            out_string += level_string

            var level_next = DynamicVector[Pointer[Node]]()
            notNullCount = 0
            for node in level:
                if node[]:
                    level_next.append(node[].load().leftChild)
                    level_next.append(node[].load().rightChild)
                    if node[].load().leftChild:
                        notNullCount += 1
                    if node[].load().rightChild:
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
                            '/' if level[i].load().leftChild else
                            space_symbol) + level_string[j - w:]
                        level_string = level_string[:j + w + 1] + (
                            '\\' if level[i].load().rightChild else
                            space_symbol) + level_string[j + w:]
                out_string += level_string
            height = height // 2
            level = level_next

        return out_string