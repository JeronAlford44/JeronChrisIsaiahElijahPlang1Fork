import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Optional;
import java.util.function.Predicate;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class Exercises {
    static Map<Integer, Long> change(long amount) {
        if (amount < 0) {
            throw new IllegalArgumentException("Amount cannot be negative");
        }
        var counts = new HashMap<Integer, Long>();
        for (var denomination : List.of(25, 10, 5, 1)) {
            counts.put(denomination, amount / denomination);
            amount %= denomination;
        }
        return counts;
    }

    // Write your first then lower case function here
    public static Optional<String> firstThenLowerCase(List<String> strings, Predicate<String> predicate) {
        return strings.stream()
                      .filter(predicate)
                      .map(String::toLowerCase)
                      .findFirst();
    }
    // Write your say function here
    public static class Say {
        private StringBuilder phrase;
    
        // Start with an empty phrase
        public Say() {
            this.phrase = new StringBuilder();
        }
    
        // Start with an initial word
        public Say(String word) {
            this.phrase = new StringBuilder(word);
        }
    
        // Add a word to the phrase with a space before it
        public Say and(String word) {
            // Add a space even if word is empty, but only if there's already something in the phrase
            Say newSay = new Say(this.phrase.toString());
            if (this.phrase.length() > 0 || !word.isEmpty()) {
                newSay.phrase.append(" ");
            }
            newSay.phrase.append(word); // Add a space only if the phrase is not empty
            return newSay;
        }
    
        // Get the full phase so far
        public String phrase() {
            return this.phrase.toString();
        }
    }
    
    // Creates an empty Say object
    public static Say say() {
        return new Say();
    }
    
    public static Say say(String word) {
        return new Say(word);
    }
    // Write your line count function here
    public static long meaningfulLineCount(String filename) throws IOException {
        try (BufferedReader reader = new BufferedReader(new FileReader(filename))) {
            return reader.lines()
                         .filter(line -> !line.trim().isEmpty())    // Skip empty lines
                         .filter(line -> !line.trim().startsWith("#")) // Skip comments
                         .count();  // Count the remaining lines
        }
    }}

// Write your Quaternion record class here
record Quaternion(double a, double b, double c, double d) {
    // Make sure the components are not NaN
    public Quaternion {
        if (Double.isNaN(a) || Double.isNaN(b) || Double.isNaN(c) || Double.isNaN(d)) {
            throw new IllegalArgumentException("Coefficients cannot be NaN");
        }
    }

    // Adds two quaternions together
    public Quaternion plus(Quaternion q) {
        return new Quaternion(
            this.a + q.a, 
            this.b + q.b, 
            this.c + q.c, 
            this.d + q.d
        );
    }
    
    // Multiplies two quaternions together
    public Quaternion times(Quaternion q) {
        double newA = this.a * q.a - this.b * q.b - this.c * q.c - this.d * q.d;
        double newB = this.a * q.b + this.b * q.a + this.c * q.d - this.d * q.c;
        double newC = this.a * q.c - this.b * q.d + this.c * q.a + this.d * q.b;
        double newD = this.a * q.d + this.b * q.c - this.c * q.b + this.d * q.a;
        return new Quaternion(newA, newB, newC, newD);
    }

    // Get coefficients as a list
    public List<Double> coefficients() {
        return List.of(a, b, c, d);
    }

    // Returns conjugate of the quaternion
    public Quaternion conjugate() {
        return new Quaternion(a, -b, -c, -d);
    }

    // String representation of the quaternion
    @Override
    public String toString() {
        StringBuilder result = new StringBuilder();
        if (a != 0) result.append(a);
        if (b != 0) result.append((b > 0 && result.length() > 0 ? "+" : "")).append(b).append("i");
        if (c != 0) result.append((c > 0 && result.length() > 0 ? "+" : "")).append(c).append("j");
        if (d != 0) result.append((d > 0 && result.length() > 0 ? "+" : "")).append(d).append("k");
        
        return result.length() > 0 ? result.toString() : "0";
    }

// Static constants for ZERO, I, J, K
public static final Quaternion ZERO = new Quaternion(0, 0, 0, 0);
public static final Quaternion I = new Quaternion(0, 1, 0, 0);
public static final Quaternion J = new Quaternion(0, 0, 1, 0);
public static final Quaternion K = new Quaternion(0, 0, 0, 1);
}

// Write your BinarySearchTree sealed interface and its implementations here
sealed interface BinarySearchTree permits Empty, Node {
    BinarySearchTree insert(String value);
    boolean contains(String value);
    int size();
}

final class Empty implements BinarySearchTree {
    // Inserting into an empty tree creates a new Node
    public BinarySearchTree insert(String value) {
        return new Node(value, new Empty(), new Empty());
    }

    // Empty tree contains no values
    public boolean contains(String value) {
        return false;
    }

    // Size of an empty tree is 0
    public int size() {
        return 0;
    }

    @Override
    public String toString() {
        return "()"; // Empty tree representation
    }
}

final class Node implements BinarySearchTree {
    private final String value;
    private final BinarySearchTree left, right;

    public Node(String value, BinarySearchTree left, BinarySearchTree right) {
        this.value = value;
        this.left = left;
        this.right = right;
    }

    // Insert new value in the correct place in the tree
    public BinarySearchTree insert(String value) {
        if (value.compareTo(this.value) < 0) {
            return new Node(this.value, this.left.insert(value), this.right);
        } else if (value.compareTo(this.value) > 0) {
            return new Node(this.value, this.left, this.right.insert(value));
        } else {
            return this; // Value is already in the tree
        }
    }

    // Check if tree contains a value
    public boolean contains(String value) {
        if (value.compareTo(this.value) < 0) {
            return this.left.contains(value);
        } else if (value.compareTo(this.value) > 0) {
            return this.right.contains(value);
        } else {
            return true; // Value found
        }
    }

    // Calculate size of the tree
    public int size() {
        return 1 + this.left.size() + this.right.size();
    }

    @Override
    public String toString() {
        String leftStr = left.toString();
        String rightStr = right.toString();
        return "(" + (leftStr.equals("()") ? "" : leftStr) + this.value + (rightStr.equals("()") ? "" : rightStr) + ")";
    }
}
