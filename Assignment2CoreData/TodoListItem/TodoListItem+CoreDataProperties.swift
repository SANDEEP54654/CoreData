//
//  TodoListItem+CoreDataProperties.swift
//  Assignment2CoreData
//
//  Created by Pawandeep Singh on 16/03/22.
//
//

import Foundation
import CoreData


extension TodoListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoListItem> {
        return NSFetchRequest<TodoListItem>(entityName: "TodoListItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var completed: Bool

}

extension TodoListItem : Identifiable {

}
