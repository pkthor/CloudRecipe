//
//  Recipes.swift
//  CloudRecipe
//
//  Created by P. Kurt Thorderson on 10/21/20.
//

import SwiftUI

class Recipes: ObservableObject {
  @Published var items: [Recipe] = []
}
