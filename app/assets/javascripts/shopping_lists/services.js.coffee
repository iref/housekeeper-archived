ShoppingListServices = angular.module "shoppingListServices", []

ShoppingListServices.factory "ShoppingList", () ->
  shoppingLists =
    query: () -> root.shopping_lists

    get: (id) -> root.shopping_lists.find (sl) -> sl.id == id

    save: (sl) ->
      sl.id = root.shopping_lists.length
      root.shopping_lists[sl.id] = sl

    update: (sl) ->
      original = @get(sl.id)
      index = root.shopping_lists.indexOf original
      root.shopping_lists[index] = sl

    delete: (id) ->
      root.shopping_lists = root.shopping_lists.filter (s) -> s.id != id

    addItem: (item, shoppingListId) ->
      sl = @get(shoppingListId)
      item.buyer = { id: 1, name: "test author" }
      item.price = 0
      item.amount ||= 1
      item.created_at = new Date().toISOString()
      sl.items.push(item)
      item

ShoppingListServices.factory "Comment", ["ShoppingList", (ShoppingList) ->
  comment =
    create: (newComment, shoppingListId) ->
      sl = ShoppingList.get(shoppingListId)
      #TODO get author from universe
      newComment.posted_at = new Date().toISOString()
      newComment.author = { id: 1, name: "test author" }
      sl.comments.push(newComment)
      newComment
]

shopping_lists = [
  {
    id: 1
    title: "test"
    description: "testing shopping lists"
    deadline: "2014-12-12"
    moderator: { id: 1, name: "Jan Ferko" },
    items: [
      { id: 2, name: "Clojure in Action", amount: 1, price: 0, created_at: "2014-09-11 14:50", buyer: {id: 1, name: "Jan Ferko"} },
      { id: 3, name: "Elloquent Ruby", amount: 1, price: 0, created_at: "2014-10-11 15:20", buyer: {id: 2, name: "Sue Ferkova"}  }
    ]
    comments: [
      { id: 4, text: "This shopping list is for testing only", author: {id: 1, name: "Jan Ferko" }, posted_at: "2014-09-12 14:50"},
      { id: 3, text: "Got it", author: { id: 2, name: "Sue Ferkova"}, posted_at: "2014-10-11 15:20"}
    ]
  }, {
    id: 2,
    title: "test2",
    description: "testing shopping list 2",
    deadline: "2015-01-01",
    moderator: { id: 2, name: "Sue Ferkova" },
    items: [
      { id: 3, amount: 1, price: 200, name: "Learn yourself some Haskell for greater good", buyer: {id: 1, name: "Jan Ferko" }, created_at: "2014-08-12 15:43:20"},
      { id: 5, amount: 1, price: 100, name: "War and Peace", buyer: { id: 2, name: "Sue Ferkova" }, created_at: "2014-08-12 06:24:34"}
    ],
    comments: []
  }
]

root = exports ? this
unless root.shopping_lists
  root.shopping_lists = shopping_lists
