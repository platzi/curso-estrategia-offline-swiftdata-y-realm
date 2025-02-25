//
//  SDDatabaseService.swift
//  Gastify
//
//  Created by Santiago Moreno on 26/01/25.
//

import Foundation
import SwiftData

@MainActor
class SDDatabaseService: DatabaseServiceProtocol {

    private let container: ModelContainer
    private let context: ModelContext

    init() {
        self.container = try! ModelContainer(
            for: SDRecord.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: false)
        )
        self.context = ModelContext(container)
    }

    func fetchRecords(filter: FilterItem) async -> [Record] {
        let calendar = Calendar.current
        let now = Date()

        let predicate: Predicate<SDRecord>

        switch filter {
        case .today:
            let startOfDay = calendar.startOfDay(for: now)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
            predicate = #Predicate<SDRecord> { register in
                register.date >= startOfDay && register.date < endOfDay
            }

        case .week:
            let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
            let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek)!
            predicate = #Predicate<SDRecord> { register in
                register.date >= startOfWeek && register.date < endOfWeek
            }

        case .month:
            let components = calendar.dateComponents([.year, .month], from: now)
            let startOfMonth = calendar.date(from: components)!
            let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
            predicate = #Predicate<SDRecord> { register in
                register.date >= startOfMonth && register.date < endOfMonth
            }

        case .year:
            let oneYearAgo = calendar.date(byAdding: .year, value: -1, to: now)!
            predicate = #Predicate<SDRecord> { register in
                register.date >= oneYearAgo && register.date <= now
            }
        }

        let descriptor = FetchDescriptor<SDRecord>(predicate: predicate)

        do {
            let sdRecords = try context.fetch(descriptor)
            return sdRecords.map { $0.toRecord() }
        } catch {
            // TODO: Implementar caso
            return []
        }
    }

    func saveNewRecord(_ record: Record) async -> Bool {
        let sdRecord = SDRecord(id: record.id,
                                title: record.title,
                                date: record.date,
                                type: record.type.rawValue,
                                amount: record.amount)
        do {
            context.insert(sdRecord)
            try context.save()
            return true
        } catch {
            return false
        }
    }

    func updateRecord(_ record: Record) async -> Bool {
        let id = record.id
        let categoryPredicate = #Predicate<SDRecord> { $0.recordId == id }
        let descriptor = FetchDescriptor<SDRecord>(
            predicate: categoryPredicate
        )
        do {
            guard let existingRecord = try context.fetch(descriptor).first else {
                return false
            }
            existingRecord.title = record.title
            existingRecord.amount = record.amount
            try context.save()
            return true
        } catch {
            return false
        }
    }

    func deleteRecord(_ record: Record) async -> Bool {
        let id = record.id
        let categoryPredicate = #Predicate<SDRecord> { $0.recordId == id }
        let descriptor = FetchDescriptor<SDRecord>(
            predicate: categoryPredicate
        )
        do {
            guard let recordToDelete = try context.fetch(descriptor).first else {
                return false
            }
            context.delete(recordToDelete)
            try context.save()
            return true
        } catch {
            return false
        }
    }

    func getTotals() async -> (income: Double, outcome: Double) {
        do {
            let incomePredicate = #Predicate<SDRecord> { $0.type == "INCOME" }
            let outcomePredicate = #Predicate<SDRecord> { $0.type == "OUTCOME" }

            let incomeDescriptor = FetchDescriptor<SDRecord>(
                predicate: incomePredicate
            )
            let outcomeDescriptor = FetchDescriptor<SDRecord>(
                predicate: outcomePredicate
            )

            let incomeRecords = try context.fetch(incomeDescriptor)
            let outcomeRecords = try context.fetch(outcomeDescriptor)

            let income = incomeRecords.reduce(0.0) { $0 + $1.amount }
            let outcome = outcomeRecords.reduce(0.0) { $0 + $1.amount }

            return (income: income, outcome: outcome)
        } catch {
            return (income: 0.0, outcome: 0.0)
        }
    }
}
