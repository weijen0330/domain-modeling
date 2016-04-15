//
//  main.swift
//  SimpleDomainModel
//
//  Created by Wei-Jen Chiang on 4/11/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

public class TestMe {
  public func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
    public var amount : Int
    public var currency : String
  
    init(amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency
    }
    
    public func convert(to: String) -> Money {
        if (self.currency != to) {
            var newAmount : Int = 0;
            if (self.currency == "USD") {
                if (to == "GBP") {
                    newAmount = self.amount / 2
                } else if (to == "EUR") {
                    newAmount = Int(Double(self.amount) * 1.5)
                } else if (to == "CAN") {
                    newAmount = Int(Double(self.amount) * 1.25)
                }
            } else if (self.currency == "GBP") {
                if (to == "USD") {
                    newAmount = self.amount * 2
                } else if (to == "EUR") {
                    newAmount = self.amount * 3
                } else if (to == "CAN") {
                    newAmount = Int(Double(self.amount) * 2.5)
                }
            } else if (self.currency == "EUR") {
                if (to == "USD") {
                    newAmount = Int(Double(self.amount) * (2.0/3.0))
                } else if (to == "GBP") {
                    newAmount = Int(Double(self.amount) * (1.0/3.0))
                } else if (to == "CAN") {
                    newAmount = Int(Double(self.amount) * (2.5/3.0))
                }
            } else if (self.currency == "CAN") {
                if (to == "USD") {
                    newAmount = Int(Double(self.amount) * (4.0/5.0))
                } else if (to == "GBP") {
                    newAmount = Int(Double(self.amount) * (1.0/2.5))
                } else if (to == "EUR") {
                    newAmount = Int(Double(self.amount) * (3.0/2.5))
                }
            }
            return Money(amount: newAmount, currency: to)
        }
        return self
    }
  
    public func add(to: Money) -> Money {
        if (self.currency == to.currency) {
            return Money(amount: self.amount + to.amount, currency: self.currency)
        } else {
            return to.add(self.convert(to.currency))
        }
    }
        
    public func subtract(from: Money) -> Money {
        if (self.currency == from.currency) {
            return Money(amount: self.amount - from.amount, currency: self.currency)
        } else {
            return self.subtract(convert(from.currency))
        }
    }
}

////////////////////////////////////
// Job
//
public class Job {
    public var title : String
    public var type : JobType
    
    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }
  
    public init(title : String, type : JobType) {
        self.title = title
        self.type = type
    }
  
    public func calculateIncome(hours: Int) -> Int {
        switch self.type {
        case .Hourly(let pay):
            return Int(pay * Double(hours))
        case .Salary(let pay):
            return pay;
        }
    }
  
    public func raise(amt : Double) {
        switch self.type {
        case .Hourly(let pay):
            self.type = JobType.Hourly(pay + amt)
        case .Salary(let pay):
            self.type = JobType.Salary(pay + Int(amt))
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    public var firstName : String = ""
    public var lastName : String = ""
    public var age : Int = 0
    private var _job : Job? = nil
    private var _spouse: Person? = nil

    public var job : Job? {
        get {
            return _job;
        }
        set(value) {
            if (self.age >= 16) {
                _job = value;
            } else {
                _job = nil;
            }
        }
    }
  
    public var spouse : Person? {
        get {
            return _spouse;
        }
        set(value) {
            if (self.age >= 18) {
                _spouse = value;
            } else {
                _spouse = nil
            }
        }
    }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  public func toString() -> String {
    return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(self.job) spouse:\(self.spouse)]"
  }
}

let ted = Person(firstName: "Ted", lastName: "Neward", age: 45)
print(ted.toString())

////////////////////////////////////
// Family
//
public class Family {
    private var members : [Person] = []
  
    public init(spouse1: Person, spouse2: Person) {
        if (spouse1.spouse == nil && spouse2.spouse == nil) {
            self.members.append(spouse1)
            self.members.append(spouse2)
        }
    }
  
    public func haveChild(child: Person) -> Bool {
        for member in members {
            if (member.age >= 21) {
                self.members.append(child)
                return true;
            }
        }
        return false;
    }
  
    public func householdIncome() -> Int {
        var incomeSum : Int = 0
        for member in members {
            if (member.job != nil) {
                incomeSum += member.job!.calculateIncome(2000)
            }
        }
        return incomeSum
    }
}





