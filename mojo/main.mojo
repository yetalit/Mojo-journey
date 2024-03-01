# let : immutable (runtime)
# var : mutable
# alias : immutable (compile time)

# Data types: String, Int (Int8, Int16, Int32, Int64), UInt8, UInt16 ...,
# Float16, Float32 ..., Bool

from python import Python
from python import PythonObject

struct myClass:
    var prop1: Int
    var prop2: String
    var prop3: Bool

    # inout keyword is like passing by reference
    fn __init__(inout self):
        self.prop1 = 0
        self.prop2 = ''
        self.prop3 = False

    # owned keyword is like passing by value
    fn setProp1 (inout self, owned value: Int):
        value += 1
        self.prop1 = value
    # borrowed keyword is like passing a constant argument (immutable)
    fn setProp2 (inout self, borrowed value: String):
        self.prop2 = value
    # fn function arguments are treated as borrowed by default
    fn setProp3 (inout self, value: Bool):
        self.prop3 = value
        

fn main():
    try:
        let py = Python.import_module('builtins')
        let np = Python.import_module('numpy')

        let user_input = py.input('what is your fav color? ')
        print('your fav color is', user_input)

        # use of python lists in mojo
        let x: PythonObject = [1,2,3,4,5]
        for i in range(x.__len__()):
            print(x[i])

        var arr = np.array([1,2,3,4,5])
        print(arr * 2)
    except:
        print('Error importing modules!')

    var myclass = myClass()
    print(myclass.prop1, myclass.prop2, myclass.prop3)
    let p1: Int = 2
    let p2: String = 'helloooo'
    let p3: Bool = True
    myClass.setProp1(myclass, p1)
    myClass.setProp2(myclass, p2)
    myClass.setProp3(myclass, p3)
    print(myclass.prop1, myclass.prop2, myclass.prop3)
