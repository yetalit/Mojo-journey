from AVLTree import AVLTree

fn main() raises:
    var tree = AVLTree([10, 20, 30, 40, 50])
    random.seed()
    for i in range(15):
        tree.insert(random.random_ui64(1, 999).to_int())
    print(tree.__str__())
    tree.remove(tree.findkth(18))
    tree.remove(tree.findkth(14))
    tree.remove(tree.findkth(10))
    print(tree.__str__())
    var data = tree.as_vector(2)
    print('Postorder:')
    for el in data:
        print(el[])