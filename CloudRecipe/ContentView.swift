//
//  ContentView.swift
//  CloudRecipe
//
//  Created by P. Kurt Thorderson on 10/21/20.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject var recipes: Recipes
  @State private var newItem = Recipe(name:"")
  @State private var showEditedTextField = false
  @State private var editedItem = Recipe(name: "")
  
    var body: some View {
      NavigationView {
        VStack {
          VStack {
            HStack(spacing: 15) {
              TextField("Add new recipe name", text: $newItem.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
              Button("Add") {
                if !self.newItem.name.isEmpty {
                  let newItem = Recipe(name: self.newItem.name)
                  //MARK: - saving to CloudKit
                  CloudKitHelper.save(item: newItem) { (result) in
                    switch result {
                      case .success(let newItem):
                        self.recipes.items.insert(newItem, at: 0)
                        print("Successfully added item")
                      case .failure(let err):
                        print(err.localizedDescription)
                    }
                  }
                  self.newItem = Recipe(name: "")
                }
              }
            }
            HStack(spacing: 15) {
              TextField("Edit item", text: self.$editedItem.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
              Button("Done") {
                //MARK: - modify in CloudKit
                CloudKitHelper.modify(item:self.editedItem) { (result) in
                  switch result {
                    case .success(let item):
                      for i in 0..<self.recipes.items.count {
                        let currentItem = self.recipes.items[i]
                        if currentItem.recordID == item.recordID {
                          self.recipes.items[i] = item
                        }
                      }
                      self.showEditedTextField = false
                      print("Successfully modified item")
                    case .failure(let err):
                      print(err.localizedDescription)
                  }
                }
              }
            }
            .padding()
            Text("Double tap to Edit. Long press to Delete.")
              .frame(height: showEditedTextField ?0 : 40)
              .opacity(showEditedTextField ? 0 : 1)
              .animation(.easeInOut)
            List(recipes.items) { item in
              HStack(spacing: 15) {
                Text(item.name)
              }
              .onTapGesture(count: 2, perform: {
                if !self.showEditedTextField {
                  self.showEditedTextField = true
                  self.editedItem = item
                }
              })
              .onLongPressGesture {
                if !self.showEditedTextField {
                  let recordID = item.recordID
                  //MARK: -delete from CloudKit
                  CloudKitHelper.delete(recordID: recordID) { (result) in
                    switch result {
                      case .success(let recordID):
                        self.recipes.items.removeAll { (recipe) ->
                          Bool in
                          return recipe.recordID == recordID
                        }
                        print("Successfully deleted item")
                      case .failure(let err):
                        print(err.localizedDescription)
                    }
                  }
                }
              }
            }
            .animation(.easeInOut)
          }
          .navigationBarTitle(Text("Thorderson Recipes in CloudKit"))
        }
        .onAppear {
          //MARK: - fetch from CloudKit
          CloudKitHelper.fetch { (result) in
            switch result {
              case .success(let newItem):
                self.recipes.items.append(newItem)
                print("Successfully fetched item")
              case .failure(let err):
                print(err.localizedDescription)
            }
          }
        }
      }
    }
}

