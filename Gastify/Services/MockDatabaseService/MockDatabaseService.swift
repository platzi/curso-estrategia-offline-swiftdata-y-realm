//
//  MockDatabaseService.swift
//  Gastify
//
//  Created by Santiago Moreno on 26/01/25.
//

import Foundation

class MockDatabaseService: DatabaseServiceProtocol {

    let mockRecords = MockRecordsHelper.mockRecords()

    func fetchRecords(filter: FilterItem) async -> [Record] {
        return MockRecordsHelper.applyFilter(to: self.mockRecords,
                                             by: filter)
    }

    func saveNewRecord(_ record: Record) async -> Bool {
        return true
    }

    func updateRecord(_ record: Record) async -> Bool {
        return true
    }

    func deleteRecord(_ record: Record) async -> Bool {
        return true
    }

    func getTotals() async -> (income: Double, outcome: Double) {
        return (income: 10000000, outcome: 5100000)
    }
}
