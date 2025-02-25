//
//  RecordDetailViewModel.swift
//  Gastify
//
//  Created by Santiago Moreno on 7/01/25.
//

import Foundation

enum RecordDetaiSheet: Identifiable {
    var id: String { String(describing: self) }
    case updateRecord(_ record: Record)
}

class RecordDetailViewModel: ObservableObject {

    @Published var sheet: RecordDetaiSheet?
    @Published var loading = false
    @Published var showDeleteAlert = false
    @Published var record: Record

    let databaseService: DatabaseServiceProtocol

    init(_ databaseService: DatabaseServiceProtocol, record: Record) {
        self.databaseService = databaseService
        self.record = record
    }

    func updateRecord() {
        self.sheet = .updateRecord(self.record)
    }

    func deleteRecord(completion: @escaping () -> Void) {
        self.loading = true
        Task {
            let deleted = await self.databaseService.deleteRecord(self.record)
            if deleted {
                await MainActor.run {
                    self.loading = false
                    completion()
                }
            } else {
                // TODO: Mostrar un error
            }
        }
    }

    func showDeleteRecordAlert() {
        self.showDeleteAlert = true
    }
}
