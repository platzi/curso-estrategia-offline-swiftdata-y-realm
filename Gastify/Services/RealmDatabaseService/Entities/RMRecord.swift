//
//  RMRecord.swift
//  Gastify
//
//  Created by Santiago Moreno on 26/01/25.
//

import Foundation
import RealmSwift

class RMRecord: Object {

    @Persisted(primaryKey: true) var _id: UUID
    @Persisted var recordId: String
    @Persisted var title: String
    @Persisted var date: Date
    @Persisted var type: String
    @Persisted var amount: Double
}

extension RMRecord: ToRecordProtocol {
    
    func toRecord() -> Record {
        Record(id: self.recordId,
               title: self.title,
               date: self.date,
               type: RcordType(rawValue: self.type) ?? .income,
               amount: self.amount)
    }
}
