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
//print(letter)



/* Extension that allows us to access individual letters like an array */
extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}
//prints out 'y' in "Taylor"
//print(name[2])

//MARK: - Working with Strings in Swift

/* Methods for checking whether a string starts with or ends with a substring
 - hasPrefix()
 - hasSuffix()
 */

let password = "12345"
password.hasPrefix("123") //returns true
password.hasSuffix("345") //returns true

/* Extension methods to remove prefix/suffix */

extension String {
    //removes a prefix if it exists
    func deletePrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    //removes suffix if it exists
    func deleteSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
}
//test
//print(password.deletePrefix("123")) // "45"
//print(password.deleteSuffix("345")) // "12"

/* Capitalized method*/
let weather = "its going to rain"
//print(weather.capitalized) // "Its Going To Rain"


/* Extension that uppercases only the first letter in our string*/
extension String {
    
    var capitalizeFirst: String {
        guard let firstLetter = self.first else { return ""}
        return firstLetter.uppercased() + self.dropFirst()
    }
}

//print(weather.capitalizeFirst) //"Its going to rain"

/* Contains method */

let input = "Swift is like Objective-C without the C"
input.contains("Swift") //true

/* Extension of ContainsAny*/

let swiftString = "Swift is like Objective-C without the C"
let languageArray = ["Python", "Ruby", "Swift"]

extension String {
    func containsAny(of array: [String]) -> Bool {
        for item in array {
            if self.contains(item) {
                return true
            }
        }
        return false
    }
}
//checks if the swiftString contains any items in the languageArray
swiftString.containsAny(of: languageArray) //true


/* combining both for a better solution */
languageArray.contains(where: swiftString.contains)


//MARK: - Formatting strings with NSAttributedString

let string = "This is a test string."
let attributes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.white,
    .backgroundColor: UIColor.red,
    .font: UIFont.boldSystemFont(ofSize: 36)
]

let attributedString = NSAttributedString(string: string, attributes: attributes)


let attributedString2 = NSMutableAttributedString(string: string)

attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))

//MARK: - Hacking with Swift Challenges

/* 1. */

extension String {
    
    func withPrefix(_ prefix: String) -> String {
        if self.contains(prefix) { return self } else { return prefix + self}
    }
}

//test 1.
print("pet".withPrefix("car"))

/* 2. */

extension String {
    
    func isNumeric() -> Bool {
        
        for i in self {
            let char = String(i)
            if Double(char) != nil { return true }
        }
        return false
    }
}

let testString = "the homies are going to be here at 4 am"
testString.isNumeric()

/* 3. */

extension String {
   
    var lines: [String.SubSequence] {self.split(separator: "\n")
        
    }
}


print("this\nis\na\ntest".lines)
