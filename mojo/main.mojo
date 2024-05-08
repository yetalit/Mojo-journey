# var : mutable
# alias : immutable (compile time)
# let !!!deprecated!!! : immutable (runtime)

# Data types: String, Int (Int8, Int16, Int32, Int64), UInt8, UInt16 ...,
# Float16, Float32 ..., Bool

from python import Python

from mypackage.mymodule import MyPair1
from testpack.mymodule import MyPair2

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
        

fn add[datatype: DType, length: Int](a: SIMD[datatype, length], b: SIMD[datatype, length]) -> SIMD[datatype, length]:
    return a + b

fn main():
    try:
        var py = Python.import_module('builtins')
        var np = Python.import_module('numpy')

        var user_input = py.input('what is your fav color? ')
        print('your fav color is', user_input)

        # use of python lists in mojo
        var x: PythonObject = [1,2,3,4,5]
        for i in range(len(x)):
            print(x[i])

        var arr = np.array([1,2,3,4,5])
        print(arr * 2)
    except:
        print('Error importing modules!')

    var myclass = myClass()
    print(myclass.prop1, myclass.prop2, myclass.prop3)
    alias p1: Int = 2
    alias p2: String = 'helloooo'
    alias p3: Bool = True
    myClass.setProp1(myclass, p1)
    myClass.setProp2(myclass, p2)
    myClass.setProp3(myclass, p3)
    print(myclass.prop1, myclass.prop2, myclass.prop3)

    alias mine1 = MyPair1(4, 8)
    mine1.dump()
    alias mine2 = MyPair1(16, 32)
    mine2.dump()

    # SIMD: Single Instruction Multiple Data
    # simd width must be power of 2
    alias x = SIMD[DType.float64, 8](2, 4, 8, 16, 32, 64, 128, 256)
    print(x.__len__())
    print(0.25 * x)
    print(add(x,x))
