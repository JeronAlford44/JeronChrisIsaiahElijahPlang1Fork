import java.io.BufferedReader
import java.io.FileReader
import java.io.IOException
import kotlin.math.abs

fun change(amount: Long): Map<Int, Long> {
    require(amount >= 0) { "Amount cannot be negative" }
    
    val counts = mutableMapOf<Int, Long>()
    var remaining = amount
    for (denomination in listOf(25, 10, 5, 1)) {
        counts[denomination] = remaining / denomination
        remaining %= denomination
    }
    return counts
}

// Write your first then lower case function here
fun firstThenLowerCase(sequence: List<String>, predicate: (String) -> Boolean): String?{
    for (substring: String in sequence){
   
    if (predicate?.invoke(substring) == true){
      
      return substring.lowercase()
    }
  }
  return null

}

// Write your say function here
class say(val firstWord: String = "") {
    private var accumulatedPhrase = firstWord

   
    fun and(word: String): say {
        accumulatedPhrase += " $word"
        return this
    }

    val phrase: String
        get() = accumulatedPhrase
}

// Write your meaningfulLineCount function here
fun meaningfulLineCount(fileName: String): Long {
    
    val reader = BufferedReader(FileReader(fileName))
    var line: String? = reader.readLine()
    var count: Long = 0
    while (line != null) {
        val trimmedLine = line.trim()
        
        if (trimmedLine.isNotEmpty() && !trimmedLine.startsWith("#")) {
            count++
        }
        line = reader.readLine()
    }

    reader.close()  // Close reader
    return count
}

// Write your Quaternion data class here
data class Quaternion(val a: Double, val b: Double, val c: Double, val d: Double) {

    companion object {
        val ZERO: Quaternion 
            get() = Quaternion(0.0, 0.0, 0.0, 0.0)
        val I: Quaternion 
            get() = Quaternion(0.0, 1.0, 0.0, 0.0)
        val J: Quaternion 
            get() = Quaternion(0.0, 0.0, 1.0, 0.0)
        val K: Quaternion 
            get() = Quaternion(0.0, 0.0, 0.0, 1.0)
    }

    operator fun plus(that: Quaternion): Quaternion {
        return Quaternion(this.a + that.a, this.b + that.b, this.c + that.c, this.d + that.d)
    }

    operator fun times(that: Quaternion): Quaternion {
        val productA = this.a * that.a - this.b * that.b - this.c * that.c - this.d * that.d
        val productB = this.a * that.b + this.b * that.a + this.c * that.d - this.d * that.c
        val productC = this.a * that.c - this.b * that.d + this.c * that.a + this.d * that.b
        val productD = this.a * that.d + this.b * that.c - this.c * that.b + this.d * that.a

        return Quaternion(productA, productB, productC, productD)
    }
    
    // String representation of a quaternion
    override fun toString(): String {
        var result = ""
        val symbols = listOf("", "i", "j", "k")  
        
        // Array of the quaternion components [a, i, j, k]
        val components = listOf(this.a, this.b, this.c, this.d)
        
        // Iterate through each component
        for (idx in components.indices) {
            val value: Double = components[idx]
            if (value != 0.0) {
                
                if (value > 0.0 && result.isNotEmpty()) {
                    result += '+'
                } else if (value < 0.0) {
                    result += '-'
                }

               
                if (Math.abs(value) != 1.0 || idx == 0) {
                    result += Math.abs(value).toString()
                }

                
                result += symbols[idx]
            }
        }

        return if (result.isEmpty()) "0" else result
    }



    fun coefficients(): List<Double> {
        return listOf(this.a, this.b, this.c, this.d)
    }

    fun conjugate(): Quaternion {
        return Quaternion(this.a, -this.b, -this.c, -this.d)
    }
}

    
  



// Write your Binary Search Tree interface and implementing classes here
sealed class BinarySearchTree {
    object Empty : BinarySearchTree()
    class Node(val left: BinarySearchTree, val value: String, val right: BinarySearchTree) : BinarySearchTree()
    
    fun size(): Int = when (this) {
        is Empty -> 0
        is Node -> left.size() + 1 + right.size()
    }
    fun insert(newValue: String): BinarySearchTree = when (this) {
        is Empty -> Node(Empty, newValue, Empty) 
        is Node -> {
            when {
                newValue < value -> Node(left.insert(newValue), value, right)  
                newValue > value -> Node(left, value, right.insert(newValue))  
                else -> this  //char already exists
            }
        
        }
    }
    fun contains(letter: String): Boolean = when (this) {
        is Empty -> false  // If it's an empty tree, return false
        is Node -> when {
            letter < value -> left.contains(letter)  
            letter > value -> right.contains(letter) 
            else -> true  
        }
    }

    override fun toString(): String = when (this) {
        is Empty -> "()"
        is Node -> {
            val leftStr = if (left == Empty) "" else left.toString()
            val rightStr = if (right == Empty) "" else right.toString()
            "($leftStr$value$rightStr)"  
        }
        

    }
}
