//
//  ShowItem+CoreDataProperties.swift
//  ListiCloudKit
//
//  Created by 黃德桑 on 2020/12/9.
//
//

import Foundation
import CoreData


extension ShowItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShowItem> {
        return NSFetchRequest<ShowItem>(entityName: "ShowItem")
    }

    @NSManaged public var name: String?

}

extension ShowItem : Identifiable {

}
