import UIKit

//MARK: - Strings are not Arrays

let name = "Taylor"
//we can loop through them, similar to arrays.
//for letter in name {
//    print(letter)
//}

//but we cannot read individual letters from the string i.e.
//print(name[3])

//reading the fourth letter in the string
let letter = name[name.index(name.startIndex, offsetBy: 3)]
//prints l
print(letter)



//extension that allows us to access individual letters like an array
extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}
//prints out 'y' in "Taylor"
print(name[2])

//MARK: - Working with Strings in Swift

/* Methods for checking whether a string starts with or ends with a substring
 - hasPrefix()
 - hasSuffix()
 */

let password = "12345"
password.hasPrefix("123") //returns true
password.hasSuffix("345") //returns true

