import Foundation

var str = "Hello, playground"

var array1 = [0,1,2,3,4,5]

func bianli() ->[Int]{
    var array2 = [Int]()
    for item in 0 ..< array1.count - 2{
        array2[item] = array1[item]
        print("\(array2[item])")
    }
        
    return array2
    
}



var array = [Int]()

array = bianli()

 
