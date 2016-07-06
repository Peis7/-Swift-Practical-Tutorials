//: Playground - noun: a place where people can play

import Foundation

var closures = "Swift Closures"
//By Pedro Luis Cabrera Acosta, ing.cabrera.acosta@gmail.com
//https://github.com/Peis7/
/*
 To understand closures there are some concepts we must review before diving into code.
 ->Function Types: Every function has a specific function type, made up of the parameter types and the return type of the function.
 ->What is a closures? 
   Apple's formal definition: Closures are self-contained blocks of functionality that can be passed around and used in your code. Closures in Swift are similar to blocks in C and Objective-C and to lambdas in other programming languages.
 
 They are self-contained blocks of code that allow some things such as: 
 1. Capture values from they environment.
 2. They are passed as parameters to functions like any other parameter, they have a name and a type (Function Type, Function Signature, Prototype etc.)
 3. can be defined when we call the function that receives (in-line).
 
 Global and nested functions, as introduced in Functions, are actually special cases of closures. Closures take one of three forms:
 
 Global functions are closures that have a name and do not capture any values.
 Nested functions are closures that have a name and can capture values from their enclosing function.
 Closure expressions are unnamed closures written in a lightweight syntax that can capture values from their surrounding context.
 Swift’s closure expressions have a clean, clear style, with optimizations that encourage brief, clutter-free syntax in common scenarios. These optimizations include:
 
 Inferring parameter and return value types from context
 Implicit returns from single-expression closures
 Shorthand argument names
 Trailing closure syntax
 
 */

/*1.----------------------------------------------------------------------------------------------------
 This first example is a function that takes two parameters, the first one is an string's array and  the second one is a closure, for this example we want to take each value of the string's array and return it as a single string(ordered backwards), eg. ["Luis","Pedro","is","name","my","Hi"] will result in "Hi my name is Pedro Luis"
*/

var arreglo = [String]()
arreglo.append("Great")
arreglo.append("is")
arreglo.append("Swift")
arreglo.append(":)")
func orderBackWards(a:[String],concatenador:(valueUntilNow:String,actualValue:String)->String)->String{//concatenador:(String,String)->String
    var result = ""//it will be saving partial result,at the end the final result as well
    for value in a{//we move through the array elements
        result = concatenador(valueUntilNow: result, actualValue: value)//we avaluate or closure passing the partial result and the actual element of the input array
    }
    return result
}
//Now i will show you diferent closure xpressions sintax
orderBackWards(arreglo,concatenador: {(partialResult:String ,actualElement:String)->String in return "\(actualElement) \(partialResult)"})//This is the general form, { (parameters) -> return type in statements }
orderBackWards(arreglo,concatenador: {(partialResult ,actualElement)->String in return "\(actualElement) \(partialResult)"})//parameters type are inferred
orderBackWards(arreglo,concatenador: {partialResult ,actualElement in return "\(actualElement) \(partialResult)"})//parameters types and return type are inferred
orderBackWards(arreglo,concatenador: {partialResult ,actualElement in "\(actualElement) \(partialResult)"})//if there is only one statement, return is assumed, in this case a string
orderBackWards(arreglo){"\($1) \($0)"}//Shorthand Argument Names:$0 represents argument 1, $2 argument 2, $n argument n and as you can see ther are a few strange things, first, our closures is still here and in this case is every thing between the curly braces({"\($1) \($0)"}) and it is posible if our closures is the last argument, in this case we can "move it out" the parenthesis and place our  statement between this curly braces
/*2.-----------------------------------------------------------------------------------------------------
In our second example we  have this function wich parameters are.
 fist: A string, that is the input that we are going to work in.
 second: a character to delete from the input string(first parameter)
 third: another character, in this case
will create a function that takes a string an two characters, one is the charactre we will be looking for all throught the string to change with the second character
*/
func lettersDeleterOrChanger(myString:String,fromChar:Character,toChar:Character,closure: (currentChar:Character,fromChar:Character,toChar:Character)->String)->String{
    var result = String()
    for character in myString.characters{
        result = result + closure(currentChar:character,fromChar:fromChar,toChar:toChar)
    }
    
    return result
}

//NOTA: Se puede hacer en dos funciones separadas, una para sustituir y la otra para eliminar
var testSting = "Hi, we are using closures"
var characterToChange = Character("s")
var newChar = Character("Y")
//La primera sustituye la 's' por 'P'
let sinS = lettersDeleterOrChanger(testSting,fromChar:characterToChange,toChar: newChar){(currentChar,fromChar,newChar)->String in
    return currentChar == fromChar ? "\(newChar)" : "\(currentChar)"
}
print(sinS)


//Using Shorthand Argument Notation
var characterToChange2 = Character("H")
var newChar2 = Character("f")
var sinO = lettersDeleterOrChanger(testSting,fromChar:characterToChange2,toChar: newChar2){
    return $0 == $1 ? "\($2)" :"\($0)"
}
print(sinO)
//at this point you are probably thinking: "Those problems could easyli be solved without closures" or "I cant see how closures will make things easier", dont worry! At the end of this set of problems, you'll change you mind.

//3.Things get more intersting here, in our third problem we have to create a function that recives an unsorted array and we will use a closure that sorts it.

func mySorting(inout array:[Int],sorter:(inout unSorted:[Int],elementToSort:Int)->Void)->[Int]{
    var sortedArray = [Int]()
    for value in array{
        sorter(unSorted: &sortedArray,elementToSort: value)
    }
    return sortedArray
}

var unsortedList = [4,-1,2,34,-34,1,45,34,-1110,56,-230,-90,-675,23,23,345,23,54,3,5,34,65,7,67,45,45,2,3,4,567,87,6,55,4,3,67,45,89,12,34]
func sortPersonalizated(inout alreadySorted:[Int],actualValue:Int)->Void{
    var flag = false
    if alreadySorted.count > 0{
        var valor_anterior = 0
        for (index,val) in alreadySorted.enumerate(){
            if !(index == 0){
                valor_anterior = alreadySorted[index-1]
            }else{
                if actualValue < 0{
                    valor_anterior = actualValue
                }else{
                    valor_anterior = 0
                }
            }
            if actualValue <= val && actualValue >= valor_anterior{
                alreadySorted.insert(actualValue, atIndex: index)
                flag = true
                break
            }
        }
        if !flag{
            alreadySorted.append(actualValue)//if it was not found until here, it must be at the end
        }
        
    }else{
         alreadySorted.append(actualValue)
    }
}
var result = mySorting(&unsortedList,sorter: sortPersonalizated)
print(result)


/*4.In this next example we are going to create an  'incrementer'
 In Swift, the simplest form of a closure that can capture values is a nested function.
*/
func operationPerformencer(forIncrement amount: Float,toPerformpOpration operation:(Float,Float)->Float) -> () -> (Float,Bool) {
    var runningTotal:Float = 0.0
    var enclosedVar:Bool = false
    func perform() -> (Float,Bool) {
        runningTotal = operation(runningTotal,amount)
        if runningTotal > 31{
            enclosedVar = true
        }
        return (runningTotal,enclosedVar)
    }
    return perform
}
var powOfTwo = operationPerformencer(forIncrement: 2, toPerformpOpration: {(x,y) in if x==0{return y}else{return x*y} })
powOfTwo()//by this fist call our powOfTwo function that are 'closed' by our nested function will have the values of (2,false) as we expect, nothing weird
powOfTwo()//but in the second call of powOfTwo we can see this 'hability' of closures, now we can think that our values runningTotal and enclosedVar will have the initial values like in the first call, but now their initial values are that they get as result of first call
powOfTwo()//by now as you are probably thinking, the value of the variables is the result after the seconf call, our closure is 'closing' those values and after each call, the values dont 'die'
powOfTwo()//in this call the result will be (16,false)
powOfTwo()//in this call the result will be (32,true), by this call our condition will be
powOfTwo()//in this  the result will be (64,true)
var incrementByTen = operationPerformencer(forIncrement: 10, toPerformpOpration: {(x,y) in return x+y })
incrementByTen()
incrementByTen()
incrementByTen()
incrementByTen()
//5. Our next example is a function provided by apple call map, with a parameter that is a  Closure  that gets a value of the same type as the array type to proccess each value of the array
var presidents = ["Obama", "Bush", "Washington"]
presidents.map({
    (president: String) -> String in
        if president == "Obama"{
            return "\(president) is the president!"
        }else{
            return "\(president) was the president!"
        }
})
//6.our own version of Map, with a few differences, our function returns an array after all the mapping, with the diference that the original is part of the object it self.

func myMap(arrayToMap:[String],mapper:(String)->String?)->[String]{
    var new = [String]()
    var result:String?
    for val in arrayToMap{
        result = mapper(val)
        if let res = result{
            new.append(res)
        }
    }
    return new
}
var presidents2 = ["Obama", "Bush", "Washington"]
var mapped = myMap(presidents2){
    (president)->String? in
        if president == "Obama"{
            return president
        }
        return nil
    }

print(mapped)
//7. Clousure that is a words counter, recives an string an a character that is the one that will separate the units, for words, blank space, all this as an array


func reducer(stringToProcess:String,devidingCharacter:String,closure:(String,devidingChar:String)->(String?,String?,Bool))->[String]{
    var result:[String]=[String]()
    var actualValueRet:String? = nil
    var restOfString:String? = stringToProcess
    var keepGoing:Bool = false
    while (!keepGoing){
        (actualValueRet,restOfString,keepGoing) = closure(restOfString!,devidingChar: devidingCharacter)
        result.append(actualValueRet!)
    }
    return result
}
let someArray = "Estee es un array de caracteres"
var devide = [String]()
let separator = " "
//print(separator)
devide = reducer(someArray,devidingCharacter: separator){(currentString,character) in
    var ended:Bool = false
    for (index,val) in currentString.characters.enumerate(){
        if val == Character(character){
            if index == currentString.characters.count{
                ended = true
            }
            let restOfTheString:String? = currentString.substringFromIndex(currentString.startIndex.advancedBy(index+1))
            return (currentString.substringToIndex(currentString.startIndex.advancedBy(index)),restOfTheString,ended)
        }
    }
    return (currentString,nil,true)
}

print(devide)



