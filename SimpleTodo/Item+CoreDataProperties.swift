//
//  Item+CoreDataProperties.swift
//  SimpleTodo
//
//  Created by kenjou yutaka on 2016/08/18.
//  Copyright © 2016年 yutaka kenjo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Item {

    @NSManaged var checked: NSNumber?
    @NSManaged var displayOrder: NSNumber?
    @NSManaged var text: String?

}
