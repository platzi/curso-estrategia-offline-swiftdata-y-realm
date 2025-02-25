//
//  RMDatabaseService.swift
//  Gastify
//
//  Created by Santiago Moreno on 26/01/25.
//

import Foundation
import RealmSwift

@MainActor
class RMDatabaseService: DatabaseServiceProtocol {

    private let realm = try! Realm()

    func fetchRecords(filter: FilterItem) async -> [Record] {
        return []
    }

    func saveNewRecord(_ record: Record) async -> Bool {
        do {
            let rlmRecord = RMRecord()
            rlmRecord.recordId = record.id
            rlmRecord.title = record.title
            rlmRecord.date = record.date
            rlmRecord.type = record.type.rawValue
            rlmRecord.amount = record.amount

            try self.realm.write {
                self.realm.add(rlmRecord)
            }
            return true
        } catch {
            print("Error saving record: \(error)")
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
