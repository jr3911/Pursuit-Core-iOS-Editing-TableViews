import UIKit

class ShoppingItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var shoppingItems: [[ShoppingItem]] = [ShoppingItemFetchingClient.getShoppingItems(), []]
    
    @IBOutlet weak var shoppingTableView: UITableView!
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
        guard let addItemVC = segue.source as? AddItemViewController else {
            fatalError("segue.source could not be downcasted as AddItemViewController")
        }
        guard let textFromName = addItemVC.nameTextField.text, let textFromPrice = addItemVC.priceTextField.text, let priceAsDouble = Double(textFromPrice) else {
            //maybe alert
            fatalError("Could not convert text from price text field")
        }
        //create new object of ShoppingItem based on user input and add to section 0
        let newItem = ShoppingItem(name: textFromName, price: priceAsDouble)
        shoppingItems[0].append(newItem)
        //add new row to the relevant tableview section
        let lastIndex = shoppingTableView.numberOfRows(inSection: 0)
        let lastIndexPath = IndexPath(row: lastIndex, section: 0)
        shoppingTableView.insertRows(at: [lastIndexPath], with: .automatic)
    }
    
    @IBAction func editButton(_ sender: UIButton) {
        //toggles the editing feature, and changes the text of the button as approriate
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
        shoppingTableView.setEditing(false, animated: false)
    }
    
    private func configureShoppingItemsTableView() {
        shoppingTableView.dataSource = self
        shoppingTableView.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Items Available For Purchase"
        case 1:
            return "Purchased Items"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingItems[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //populates the cell with info from ShoppingItem
        let cell = tableView.dequeueReusableCell(withIdentifier: "items", for: indexPath)
        cell.textLabel?.text = shoppingItems[indexPath.section][indexPath.row].name
        cell.detailTextLabel?.text = "$\(shoppingItems[indexPath.section][indexPath.row].price)"
        
        //alternates background color of consecutive cells
        if indexPath.section % 2 == 0 {
            cell.backgroundColor = UIColor(red: 1, green: 0.988, blue: 0.473, alpha: 1)
        } else {
            cell.backgroundColor = UIColor(red: 0.451, green: 0.988, blue: 0.838, alpha: 1)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            if indexPath.section == 0 {
                //when user wants delete reference to item in its entirety
                shoppingItems[0].remove(at: indexPath.row)
                shoppingTableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                //when user tries to delete an item from purchased section, add back to available section
                shoppingItems[0].append(shoppingItems[1][indexPath.row])
                let lastRow = shoppingTableView.numberOfRows(inSection: 0)
                let lastIndexPath = IndexPath(row: lastRow, section: 0)
                shoppingTableView.insertRows(at: [lastIndexPath], with: .automatic)
                shoppingItems[1].remove(at: indexPath.row)
                shoppingTableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            //add item of tapped cell into other section's array and tableview section
            shoppingItems[1].append(shoppingItems[0][indexPath.row])
            let lastRow = shoppingTableView.numberOfRows(inSection: 1)
            let lastIndexPath = IndexPath(row: lastRow, section: 1)
            shoppingTableView.insertRows(at: [lastIndexPath], with: .automatic)
            //remove item from original location in array and tableview
            shoppingItems[0].remove(at: indexPath.row)
            shoppingTableView.deleteRows(at: [indexPath], with: .fade)
            
        case 1:
            //add item of tapped cell into other section's array and tableview section
            shoppingItems[0].append(shoppingItems[1][indexPath.row])
            let lastRow = shoppingTableView.numberOfRows(inSection: 0)
            let lastIndexPath = IndexPath(row: lastRow, section: 0)
            shoppingTableView.insertRows(at: [lastIndexPath], with: .automatic)
            //remove item from original location in array and tableview
            shoppingItems[1].remove(at: indexPath.row)
            shoppingTableView.deleteRows(at: [indexPath], with: .fade)
            
        default:
            break
        }
    }
    
}

