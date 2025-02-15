//
//  ContentView.swift
//  MyKeys
//
//  Created by 李旭 on 2024/12/6.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [PasswordItem]
    @State private var isShowingNewItemSheet = false
    @State private var newItem = NewPasswordItem()

    var filteredItems: [PasswordItem] {
        guard let category = selectedCategory else { return items }
        return items.filter { $0.category == category }
    }

    @State private var selectedCategory: String? = nil
    @State private var selectedItem: PasswordItem? = nil

    var categories: [String] {
        Array(Set(items.map { $0.category })).sorted()
    }

    var body: some View {
        NavigationSplitView {
            List(categories, id: \.self, selection: $selectedCategory) { category in
                Text(category)
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
            }
        } content: {
            List(filteredItems, selection: $selectedItem) { item in
                Text(item.websiteOrTag)
            }
            .navigationTitle(selectedCategory ?? "")
            .toolbar {
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                    Divider()
                    HStack {}
                }
            }
        }
        detail: {
            if let selectedItem = selectedItem {
                VStack(alignment: .leading, spacing: 10) {
                    Text("详细信息")
                        .font(.title)
                    Group {
                        Text("网站/标签: \(selectedItem.websiteOrTag)")
                        Text("用户名: \(selectedItem.username)")
                        Text("密码: \(selectedItem.password)")
                        if let notes = selectedItem.notes {
                            Text("备注: \(notes)")
                        }
                    }
                    .textSelection(.enabled)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding()
            } else {
                Text("请选择一个项目")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .sheet(isPresented: $isShowingNewItemSheet) {
            NavigationView {
                Form {
                    Section {
                        TextField("网站或标签", text: $newItem.websiteOrTag)
                        TextField("用户名", text: $newItem.username)
                        TextField("密码", text: $newItem.password)
                        TextField("添加备注", text: $newItem.notes)
                    }

                    Section {
                        TextField("分类", text: $newItem.category)
                    }
                }
                .navigationTitle("新建密码")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("取消") {
                            isShowingNewItemSheet = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("存储") {
                            saveNewItem()
                        }
                    }
                }
            }
        }
    }

    private func addItem() {
        isShowingNewItemSheet = true
    }

    private func saveNewItem() {
        withAnimation {
            let item = PasswordItem(
                username: newItem.username,
                websiteOrTag: newItem.websiteOrTag,
                password: newItem.password,
                notes: newItem.notes,
                category: newItem.category
            )
            modelContext.insert(item)
            newItem = NewPasswordItem()
            isShowingNewItemSheet = false
        }
    }

    struct NewPasswordItem {
        var websiteOrTag = ""
        var username = ""
        var password = ""
        var notes = ""
        var category = "其他"
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: PasswordItem.self, inMemory: true)
}
