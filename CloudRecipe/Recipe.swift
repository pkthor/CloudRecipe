//
//  ListElement.swift
//  CloudRecipe
//
//  Created by P. Kurt Thorderson on 10/21/20.
//

import SwiftUI
import CloudKit

struct Recipe: Identifiable {
  var id = UUID()
  var recordID: CKRecord.ID?
  var name:String
//  var category:String
//  var cookTime:Int
//  var difficulty:Int
//  var directions:String
//  var familyInfo:String
//  var ingredients:String
//  var isMyFavorite:Bool
//  var lovedBy:String
//  var prepTime:Int
//  var rating: Int
//  var recipeDescription:String
//  var recipeNotes:String
//  var servings:Int
//  var sourceNotes:String
//  var submittedBy:String
//  var totalTime:Int
}
