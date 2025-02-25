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
        return []
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
        return false
    }

    func deleteRecord(_ record: Record) async -> Bool {
        return false
    }

    func getTotals() async -> (income: Double, outcome: Double) {
        return (income: 0.0, outcome: 0.0)
    }
}
