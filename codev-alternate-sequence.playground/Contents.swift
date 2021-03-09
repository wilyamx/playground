import UIKit

/**
 There are N coins, each showing either heads or tails. We would like all the coins to form a sequence of alternating heads and tails. What is the minimum number of coins that must be reversed to achieve this?

 Write a function ghat, given an array A consisting of N integers representing the coins, returns the minimum number of coins that must be reversed. Consecutive elements of array A represent consecutive and contain either a 0 (heads) or a 1 (tails).

 Examples:

 1. Given array A = [1,0,1,0,1,1] the function should return 1. After reversing the sixth coin, we achieve an alternating sequence of coins [1,0,1,0,1,*0*]

 2. Given array A = [1,1,0,1,1] the function should return 2. After reversing the first and fifth coins, we achieve an alternating sequence [0,1,0,1,*0*]

 3. Given array A = [0,1,0] the function should return 0. The sequence of coins is already alternating.

 4. Given array A = [0,1,1,0] the function should return 2. We can reverse the first and second coins to get the sequence: [*1,0*,1,0].

 Assume that:

 * N is the integer within the range [1...100]
 * each element of array A is an integer that can have one of the following values: 0,1
 */

// answers 1, 2, 0, 2
let sequences = [
    [1,0,1,0,1,1],
    [1,1,0,1,1],
    [0,1,0],
    [0,1,1,0]
]

for sequence in sequences {
    solution(sequenceByte: sequence)
}

public func solution(sequenceByte: [Int]) -> Int {

    let normalBits: String = sequenceByte.map({ String($0) }).joined()
    
    var startZero: String = ""
    var nextSequence = 0
    for _ in sequenceByte.enumerated() {
        if nextSequence == 0 {
            startZero.append("\(nextSequence)")
            nextSequence = 1
        }
        else {
            startZero.append("\(nextSequence)")
            nextSequence = 0
        }
    }
   
    var startOne: String = ""
    nextSequence = 1
    for _ in sequenceByte.enumerated() {
        if nextSequence == 0 {
            startOne.append("\(nextSequence)")
            nextSequence = 1
        }
        else {
            startOne.append("\(nextSequence)")
            nextSequence = 0
        }
    }

    let sequenceInt = UInt8(normalBits, radix: 2) ?? 0
    let startZeroInt = UInt8(startZero, radix: 2) ?? 0
    let startOneInt = UInt8(startOne, radix: 2) ?? 0
    
    let xorded0 = sequenceInt ^ startZeroInt
    let xorded1 = sequenceInt ^ startOneInt
    
    let count0 = String(xorded0, radix: 2).filter({$0 == "1"}).count
    let count1 = String(xorded1, radix: 2).filter({$0 == "1"}).count
    
    let minCount = min(count0, count1)
    
    //print("\(stringElements)")
    print("\(sequenceByte) -- \(normalBits) -- '\(startZero) (\(startZeroInt))' -- '\(startOne)' (\(startOneInt)) -- \(minCount)")
    print("---")
    return minCount
}
