import UIKit

class ShoppingItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var shoppingItems: [ShoppingItem]!
    
    @IBOutlet weak var shoppingTableView: UITableView!
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
        guard let addItemVC = segue.source as? AddItemViewController else {
            fatalError("segue.source could not be downcasted as AddItemViewController")
        }
        guard let textFromName = addItemVC.nameTextField.text, let textFromPrice = addItemVC.priceTextField.text, let priceAsDouble = Double(textFromPrice) else {
            //maybe alert
            fatalError("Could not convert text from price text field")
        }
        
        let newItem = ShoppingItem(name: textFromName, price: priceAsDouble)
        shoppingItems.append(newItem)
        
        let lastIndex = shoppingTableView.numberOfRows(inSection: 0)
        let lastIndexPath = IndexPath(row: lastIndex, section: 0)
        shoppingTableView.insertRows(at: [lastIndexPath], with: .automatic)
    }
    
    @IBAction func editButton(_ sender: UIButton) {
        if shoppingTableView.isEditing {
            shoppingTableView.setEditing(false, animated: true)
            sender.setTitle("Edit", for: UIControl.State.normal)
        } else {
            shoppingTableView.setEditing(true, animated: true)
            sender.setTitle("Done", for: UIControl.State.normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureShoppingItemsTableView()
        loadShoppingItems()
        shoppingTableView.setEditing(false, animated: false)
    }
    
    private func loadShoppingItems() {
        let allItems = ShoppingItemFetchingClient.getShoppingItems()
        shoppingItems = allItems
    }
    
    private func configureShoppingItemsTableView() {
        shoppingTableView.dataSource = self
        shoppingTableView.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Shopping Items"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //populates the cell with info from ShoppingItem
        let cell = tableView.dequeueReusableCell(withIdentifier: "items", for: indexPath)
        cell.textLabel?.text = shoppingItems[indexPath.row].name
        cell.detailTextLabel?.text = "$\(shoppingItems[indexPath.row].price)"
        
        //alternates background color of consecutive cells
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 1, green: 0.988, blue: 0.473, alpha: 1)
        } else {
            cell.backgroundColor = UIColor(red: 0.451, green: 0.988, blue: 0.838, alpha: 1)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            shoppingItems.remove(at: indexPath.row)
            shoppingTableView.deleteRows(at: [indexPath], with: .fade)
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifier = segue.identifier else { fatalError("No identifier in segue") }

        switch segueIdentifier {
        case "switchToAdd":
            let _ = segue.destination as? AddItemViewController
            let _ = shoppingTableView.indexPathForSelectedRow
        default:
            fatalError("Unexpected segue identifier")
        }
    }

}

