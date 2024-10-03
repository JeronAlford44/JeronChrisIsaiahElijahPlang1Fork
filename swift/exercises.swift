import Foundation

struct NegativeAmountError: Error {}
struct NoSuchFileError: Error {}

func change(_ amount: Int) -> Result<[Int:Int], NegativeAmountError> {
    if amount < 0 {
        return .failure(NegativeAmountError())
    }
    var (counts, remaining) = ([Int:Int](), amount)
    for denomination in [25, 10, 5, 1] {
        (counts[denomination], remaining) = 
            remaining.quotientAndRemainder(dividingBy: denomination)
    }
    return .success(counts)
}

// Write your first then lower case function here

 func firstThenLowerCase(of strings: [String], satisfying predicate: (String) -> Bool) -> String? {
    for string in strings {
        if predicate(string) {
            return string.lowercased() 
        }
    }
    return nil
}

// Write your say function here
class Say {
    private var words: [String]

    init(_ initialWord: String = "") {
        self.words = [initialWord]
    }

    private init(words: [String]) {
        self.words = words
    }

    func and(_ word: String) -> Say {
        var newWords = self.words
        newWords.append(word)
        return Say(words: newWords)
    }

    var phrase: String {
        return self.words.joined(separator: " ")
    }
}

func say(_ initialWord: String = "") -> Say {
    return Say(initialWord)
}


// Write your meaningfulLineCount function here
enum FileError: Error {
    case noSuchFile
}

func meaningfulLineCount(_ filename: String) async -> Result<Int, FileError> {
    do {
        let fileURL = URL(fileURLWithPath: filename)
        let fileContents = try await String(contentsOf: fileURL)
        let lines = fileContents.split(separator: "\n")
        let meaningfulLines = lines.filter { line in
            let trimmedLine = line.trimmingCharacters(in: .whitespaces)
            return !trimmedLine.isEmpty && !trimmedLine.hasPrefix("#")
        }
        return .success(meaningfulLines.count)
    } catch {
        return .failure(.noSuchFile)
    }
}


// Write your Quaternion struct here

struct Quaternion: Equatable {
    let a: Double
    let b: Double
    let c: Double
    let d: Double

    var coefficients: [Double] {
        return [a, b, c, d]
    }

    var conjugate: Quaternion {
        return Quaternion(a: a, b: -b, c: -c, d: -d)
    }

    init(a: Double = 0, b: Double = 0, c: Double = 0, d: Double = 0) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }

    static let ZERO = Quaternion()
    static let I = Quaternion(b: 1)
    static let J = Quaternion(c: 1)
    static let K = Quaternion(d: 1)

    static func +(lhs: Quaternion, rhs: Quaternion) -> Quaternion {
        return Quaternion(a: lhs.a + rhs.a, b: lhs.b + rhs.b, c: lhs.c + rhs.c, d: lhs.d + rhs.d)
    }

    static func *(lhs: Quaternion, rhs: Quaternion) -> Quaternion {
        let a = lhs.a * rhs.a - lhs.b * rhs.b - lhs.c * rhs.c - lhs.d * rhs.d
        let b = lhs.a * rhs.b + lhs.b * rhs.a + lhs.c * rhs.d - lhs.d * rhs.c
        let c = lhs.a * rhs.c - lhs.b * rhs.d + lhs.c * rhs.a + lhs.d * rhs.b
        let d = lhs.a * rhs.d + lhs.b * rhs.c - lhs.c * rhs.b + lhs.d * rhs.a
        return Quaternion(a: a, b: b, c: c, d: d)
    }

    static func ==(lhs: Quaternion, rhs: Quaternion) -> Bool {
        return lhs.a == rhs.a && lhs.b == rhs.b && lhs.c == rhs.c && lhs.d == rhs.d
    }

    var description: String {
        var components: [String] = []
        if a != 0 { components.append("\(a)") }
        if b != 0 { components.append(b < 0 ? "\(b)i" : "+\(b)i") }
        if c != 0 { components.append(c < 0 ? "\(c)j" : "+\(c)j") }
        if d != 0 { components.append(d < 0 ? "\(d)k" : "+\(d)k") }
        if components.isEmpty { return "0" }
        let result = components.joined()
        return result.hasPrefix("+") ? String(result.dropFirst()) : result
    }
}

// Conform to CustomStringConvertible for string representation
extension Quaternion: CustomStringConvertible {}

// Write your Binary Search Tree enum here
