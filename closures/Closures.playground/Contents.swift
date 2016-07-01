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
will create a function that can do 2 things.
1.- Borrar una letra especifica de un string o cambiar un caracter especifico por otro
*/
func lettersDeleterOrChanger(myString:String,fromChar:Character,toChar:Character,closure: (currentChar:Character,fromChar:Character,toChar:Character)->String)->String{
    var result = String()
    for character in myString.characters{
        result = result + closure(currentChar:character,fromChar:fromChar,toChar:toChar)
    }
    
    return result
}

//NOTA: Se puede hacer en dos funciones separadas, una para sustituir y la otra para eliminar
var testSting = "Hola, Mundo, este es un String y que ahora tiene muchas S"
var characterToChange = Character("s")
var newChar = Character("Y")
//La primera sustituye la 's' por 'P'
let sinS = lettersDeleterOrChanger(testSting,fromChar:characterToChange,toChar: newChar){(currentChar,fromChar,newChar)->String in
    return currentChar == fromChar ? "\(newChar)" : "\(currentChar)"
}
print(sinS)


//Aplicamos un closure con una definicion en linea y utilizando la notacion abreviada y con inferencia de tipos
var characterToChange2 = Character("H")
var newChar2 = Character("f")
var sinO = lettersDeleterOrChanger(testSting,fromChar:characterToChange2,toChar: newChar2){
    return $0 == $1 ? "\($2)" :"\($0)"
}
print(sinO)


//3.closure que ordena un arreglo de enteros, son insercion
func mySorting(array:[Int],sorter:(alreadySort:[Int],elementToSort:Int)->[Int])->[Int]{
    var sortedArray = [Int]()
    for value in array{
        sortedArray = sorter(alreadySort: sortedArray,elementToSort: value)
    }
    return sortedArray
}

var unsortedList = [4,-1,2,34,-34,1,45,34,56,-230,-90,-675,23,23,345,23,54,3,5,34,65,7,67,45,45,2,3,4,567,87,6,55,4,3,67,45,89,12,34]
func sortPersonalizated(alreadySorted:[Int],actualValue:Int)->[Int]{
    var copy = alreadySorted//usar paso por referencia en lugar de una copia
    var flag = false
    if copy.count > 0{
        var valor_anterior = 0
        for (index,val) in copy.enumerate(){
            //valor_anterior = (val < 0)? val : 0
            if !(index == 0){
                valor_anterior = copy[index-1]
            }else{
                if actualValue<0{
                    valor_anterior = actualValue
                }else{
                    valor_anterior=0
                }
            }
            if actualValue <= val && actualValue >= valor_anterior{
                copy.insert(actualValue, atIndex: index)
                flag = true
                break
            }
        }
        if !flag{
            copy.append(actualValue)
        }
        
    }else{
        copy.append(actualValue)
    }
    return copy
}
let sortedList = mySorting(unsortedList,sorter: sortPersonalizated)
print(sortedList)


//4.closures para crear un 'incrementer'

func incrementer(incrementValue:Int)->((value:Int)->Int){
    func incrementer(val:Int)->Int{
        return incrementValue + val
    }
return incrementer
}
var incrementValue = 1
let incrementByOne = incrementer(incrementValue)
var x = 0
x = incrementByOne(value: x)
x = incrementByOne(value: x)
let incrementByOneHundred = incrementer(100)
var y = incrementByOneHundred(value:1)

//5. Closure que mapea un arreglo valor por valor, procesa cada valor y retorna algo basado en este procesamiento
var presidents = ["Obama", "Bush", "Washington"]
presidents.map({
    (president: String) -> String in
        if president == "Obama"{
            return "\(president) is the president!"
        }else{
            return "\(president) was the president!"
        }
})
//6. Closure our own version of Map, with the diference that the original is part of the array class it self

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

//8. Clousure give us the greater element in an array



