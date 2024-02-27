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

    fn __init__(inout self):
        self.prop1 = 0
        self.prop2 = ''
        self.prop3 = False

    fn setProp1 (inout self, value: Int):
        self.prop1 = value
    fn setProp2 (inout self, value: String):
        self.prop2 = value
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
    myClass.setProp1(myclass, 3)
    myClass.setProp2(myclass, 'helloooo')
    myClass.setProp3(myclass, True)
    print(myclass.prop1, myclass.prop2, myclass.prop3)
