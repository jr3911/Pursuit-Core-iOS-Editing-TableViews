struct ShoppingItem {
    let name: String
    let price: Double
}

struct ShoppingItemFetchingClient {
    static func getShoppingItems() -> [ShoppingItem] {
        return [
            ShoppingItem(name: "Apple", price: 2.99),
            ShoppingItem(name: "Donut", price: 1.19),
            ShoppingItem(name: "Egg", price: 0.19)
        ]
    }
}
