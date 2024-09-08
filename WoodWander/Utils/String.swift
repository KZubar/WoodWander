//
//  String.swift
//  WoodWander
//
//  Created by k.zubar on 2.07.24.
//

import Foundation

extension String {
    
    //длина строки
    var length: Int {
        return self.count
    }

    //удаляем последний символ
    var stringByDeletingLastCharacter: String {
        if self.count > 0 {
            return (self as NSString).substring(to: (self.count-1))
        } else {
            return self
        }
    }

    //удаляем первый символ
    var stringByDeletingFirstCharacter: String {
        if self.count > 0 {
            return (self as NSString).substring(from: 1)
        } else {
            return self
        }
    }

    //Возвращаем первые N символов
    func stringLeftCharacter(count: Int) -> String {
        if self.count > 0 {
            return (self as NSString).substring(to: min(count, self.count))
        } else {
            return self
        }
    }

    //Возвращаем последние N символов
    func stringRightCharacter(count: Int) -> String {
        if self.count > 0 {
            return (self as NSString).substring(from: min(count, self.count))
        } else {
            return self
        }
    }

    //Добавляет лидирующе нули слева
    func addLeftCharacter(_ char: String, count: Int, lenght: Int = 0) -> String {
        if self.count == 0 {
            return self
        }
        var result: String = ""
        
        for _ in 0..<count { result += char }
        
        result += self
        
        if lenght == 0 {
            return result
        } else {
            return result.stringRightCharacter(count: lenght)
        }
    }

    //строка имеет "."
    var isStringHaveDot: Bool {
        return self.filter { $0 == "." }.count > 0
    }

    //строка без пробелов
    var removeSpace: String {
        return self.filter { $0 != " " }
    }

    // удаляем из строки N символов справа
    mutating func removeCharsFromEnd(removeCount: Int) {
        if self.count < removeCount { return }
        self = (self as NSString).substring(to: (self.count - removeCount + 1))
     }

    //удаляем все пробелы справа
    mutating func removeSpaceRight() {
        if self.count == 0 { return }
        
        var txt = self
        var lastSymbol = txt.last
        
        while lastSymbol == " " {
            txt = txt.stringByDeletingLastCharacter
            lastSymbol = txt.last
        }
        self = txt
    }

    // проверяем соответствие символа в строке под номером numer с заданным символом symbol
    func isCorrectSymbol(numer: Int, symbol: String) -> Bool {
        if self.count == 0 || self.count < numer { return false }
        
        let start = self.index(self.startIndex, offsetBy: (numer-1))
        let end = self.index(self.endIndex, offsetBy: -(self.count-numer))
        let range = start..<end

        let mySubstring = self[range]
        
        return (mySubstring == symbol)
    }
    
    // попытка перевода строки в число Double
    func stringToDouble() -> Double {
        if self.count == 0 { return 0.0 }
        return (Double(self) ?? 0.0)
    }

    //попытка найти подстроку в строке
    func isHaveSubString(subText: String) -> Bool {
        return (self.range(of: subText)) != nil
    }
}
