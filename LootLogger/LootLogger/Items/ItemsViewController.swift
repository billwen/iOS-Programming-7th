//
//  ItemsViewController.swift
//  LootLogger
//
//  Created by Gang Wen on 2021-02-10.
//

import UIKit

class ItemsViewController: UITableViewController {
    
    var itemStore: ItemStore!
    
    var _imageStore: ImageStore!
    
    var _isEditing = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        self.tableView.rowHeight = 65
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 65
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        
        // Get a new or recycled cell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        // set the text on the cell iwth the description of the item that is at the nth index of items,
        // where n = row this cell
        let item = itemStore.allItems[indexPath.row]
        
        /*
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = "$ \(item.valueInDollars)"
 */
        cell.nameLabel.text = item.name
        cell.serialNumberLabel.text = item.serialNumber!
        cell.valueLabel.text = "$\(item.valueInDollars)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // if the table view is asking to commit a delete command..'
        if editingStyle == .delete {
            let item = itemStore.allItems[indexPath.row]
            
            // Remove the item from the store
            itemStore.removeItem(item)
            
            // Remove the item's image from the image store
            self._imageStore.deleteImage( forKey: item.itemKey )
            
            // Also remove that row from the table view with an animation
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Update the model
        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If the triggered segue is the "showItem" segue
        switch segue.identifier {
        case "showItem":
            // Figure out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                // Get the item associated with this row and pass it along
                let item = self.itemStore.allItems[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController._item = item
                detailViewController._imageStore = self._imageStore
            }
        default:
            preconditionFailure("Unexpected segue identifier. \(segue.identifier!)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        /*
        // make a new index path for the 0th section, last row
        let lastRow = tableView.numberOfRows(inSection: 0)
        let indexPath = IndexPath(row: lastRow, section: 0)
        
        // insert the new row into the table
        tableView.insertRows(at: [lastRow], with: .automatic)
         */
        
        // create a new item and add it to the store
        let newItem = itemStore.createItem()
        
        // Figure out where that item is in the array
        if let index = itemStore.allItems.firstIndex(of: newItem) {
            let indexPath = IndexPath(row: index, section: 0)
            
            
            // insert the new row into the table
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func toggleEditingMode(_ sender: UIButton) {
        // If you are currently in editing mode...
        if isEditing {
            sender.setTitle("Edit", for: .normal)
            
            // Turn off editing mode
            setEditing(false, animated: true)
            self._isEditing = false
        } else {
            sender.setTitle("Done", for: .normal)
            setEditing(true, animated: true)
            self._isEditing = true
        }
    }
}
