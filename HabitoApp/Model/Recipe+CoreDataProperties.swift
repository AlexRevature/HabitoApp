//
//  Recipe+CoreDataProperties.swift
//  HabitoApp
//
//  Created by Areeb Durrani on 2/6/25.
//
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    @NSManaged public var ingredients: String?
    @NSManaged public var instructions: String?

}

extension Recipe : Identifiable {

}
