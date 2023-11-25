//
//  BudgetPlannerTests.swift
//  BudgetPlannerTests
//
//  Created by Kalebu Patan on 11/13/23.
//

import XCTest
@testable import BudgetPlanner
import SwiftData

final class BudgetPlannerTests: XCTestCase {
    
    private var context: ModelContext!
    
    @MainActor override func setUp() {
        context = mockContainer.mainContext
    }
    
    func testPeopleModel() throws {
        
        let people = People(name: "Joe Doe", email: "example@edu.com")
        context.insert(people)
        
        let peopleFetch = FetchDescriptor<People>()
            
        let result = try context.fetch(peopleFetch)
            
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name, "Joe Doe")
        XCTAssertEqual(result.first?.email, "example@edu.com")
    }
    
    func testPeopleWithMoneyModel() throws {
        
        let people = People(name: "Joe Doe", email: "example@edu.com")
        context.insert(people)
        
        let peopleWithMoney = PeopleWithMoney(people: people,settled: 10.25)
        context.insert(peopleWithMoney)
        
        let peopleFetch = FetchDescriptor<PeopleWithMoney>()
            
        let result = try context.fetch(peopleFetch)
            
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.people?.name, "Joe Doe")
        XCTAssertEqual(result.first?.people?.email, "example@edu.com")
    }
    
    
    func testBudgetModel() throws {
        
        let people = People(name: "Joe Doe", email: "example@edu.com")
        context.insert(people)
        
        let budget = Budget(name: "Test",peoples: [people])
        context.insert(budget)
        
        let budgetFetch = FetchDescriptor<Budget>()
            
        let result = try context.fetch(budgetFetch)
            
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name, "Test")
        XCTAssertEqual(result.first?.peoples.count, 1)
    }
    
    
    func testExpenseModel() throws {
        
        let people = People(name: "Joe Doe", email: "example@edu.com")
        context.insert(people)
        
        let budget = Budget(name: "Test",peoples: [people])
        context.insert(budget)
        
        let expense = Expense(name: "Food", amount: 5.0)
        
        budget.expenses = [expense]
        
        let budgetFetch = FetchDescriptor<Budget>()
            
        let result = try context.fetch(budgetFetch)
            
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.expenses.first?.name, "Food")
        XCTAssertEqual(result.first?.expenses.first?.amount, 5.0)
    }
    
    func testMultipleExpenses() throws {
        
//        let peopleWithMoney1 = PeopleWithMoney(people: people,settled: 10.25)
//        let peopleWithMoney1 = PeopleWithMoney(people: people,settled: 10.25)
        
        let people = People(name: "Joe Doe", email: "example@edu.com")
        context.insert(people)
        
        let budget = Budget(name: "Test",peoples: [people])
        context.insert(budget)
        
        let expense = Expense(name: "Food", amount: 43.0)
        let expense2 = Expense(name: "Movie", amount: 15.0)
        let expense3 = Expense(name: "Travel", amount: 82.0)
        
        budget.expenses = [expense, expense2, expense3]
        
        let budgetFetch = FetchDescriptor<Budget>()
            
        let result = try context.fetch(budgetFetch)
            
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.expenses.count, 3)
    }
    
    func testMultiplePersonsWithMoney() throws {
        
        
        let people = People(name: "Joe Doe", email: "example@edu.com")
        context.insert(people)
        
        let budget = Budget(name: "Test",peoples: [people])
        context.insert(budget)
        
        let peopleWithMoney1 = PeopleWithMoney(people: people,settled: 10.25)
        let peopleWithMoney2 = PeopleWithMoney(people: people,settled: 12.25)
        
        let expense = Expense(name: "Food", amount: 43.0, shares: [peopleWithMoney1,peopleWithMoney2])
        
        budget.expenses = [expense]
        
        let budgetFetch = FetchDescriptor<Budget>()
            
        let result = try context.fetch(budgetFetch)
            
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.expenses.count, 1)
        XCTAssertEqual(result.first?.expenses.first?.shares.count, 2)
    }
    
    @MainActor
    override func tearDown() {
        try! context.delete(model: People.self)
        try! context.delete(model: PeopleWithMoney.self)
        try! context.delete(model: Expense.self)
        try! context.delete(model: Budget.self)
    }

}
