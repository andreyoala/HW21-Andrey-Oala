//
//  BruteForcePassword.swift
//  Pr2503
//
//  Created by Andrey Oala on 12.07.2022.
//

import Foundation


// This class uses (bruteForce) to asyncronize with main.

class BruteForcePassword: Operation {
    
    // MARK: - Properties
    
    private var password: String
    
    // MARK: - Initial
    
    init(password: String) {
        self.password = password
    }
    
    // MARK: - Setup operation
    
    override func main() {
        if self.isCancelled {
            return
        }
        bruteForce(passwordToUnlock: password)
    }
    
    // MARK: - Setup password selection
    
    private func bruteForce(passwordToUnlock: String) {
        let allowedCharacters: [String] = String().printable.map { String($0) }
        
        var password = ""
        while password != passwordToUnlock {
            password = generateBruteForce(password, fromArray: allowedCharacters)
            print(password)
        }
        print(password)
    }
    
    private func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
        var bruteForce = string
        
        if bruteForce.count <= 0 {
            bruteForce.append(characterAt(index: 0, array))
        } else {
            bruteForce.replace(at: bruteForce.count - 1,
                        with: characterAt(
                            index: (indexOf(
                                character: bruteForce.last ?? " ", array) + 1) % array.count, array))
            
            if indexOf(character: bruteForce.last ?? " ", array) == 0 {
                bruteForce = String(generateBruteForce(String(bruteForce.dropLast()), fromArray: array)) + String(bruteForce.last ?? " ")
            }
        }
        return bruteForce
    }

    private func indexOf(character: Character, _ array: [String]) -> Int {
        return array.firstIndex(of: String(character)) ?? Int()
    }
    
    private func characterAt(index: Int, _ array: [String]) -> Character {
        return index < array.count ? Character(array[index]) : Character("")
    }
}
