//
//  ElementsTableViewController.swift
//  AC3.2-MidtermElements
//
//  Created by Madushani Lekam Wasam Liyanage on 12/8/16.
//  Copyright © 2016 Madushani Lekam Wasam Liyanage. All rights reserved.
//

import UIKit

class ElementsTableViewController: UITableViewController {
    
    var elements = [Element]()
    let elementsEndPoint = "https://api.fieldbook.com/v1/58488d40b3e2ba03002df662/elements"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        APIRequestManager.manager.getData(endPoint: elementsEndPoint) { (data: Data?) in
            if  let validData = data,
                let validElements = Element.getElements(from: validData) {
                self.elements = validElements
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return elements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "elementCellIdentifier", for: indexPath)
        let elementAtIndex = elements[indexPath.row]
        let symbol = elementAtIndex.symbol
        let imageSize = "_200"
        let imageString = "https://s3.amazonaws.com/ac3.2-elements/\(symbol)\(imageSize).png"
        cell.imageView?.image = nil
        cell.textLabel?.text = elementAtIndex.name
        cell.detailTextLabel?.text = "\(symbol) (\(elementAtIndex.number))  \(elementAtIndex.weight)"
        
        APIRequestManager.manager.getData(endPoint: imageString ) { (data: Data?) in
            if  let validData = data,
                let validImage = UIImage(data: validData) {
                DispatchQueue.main.async {
                    cell.imageView?.image = validImage
                    cell.setNeedsLayout()
                }
            }
        }
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "elementDetailSegue" {
            if let edvc = segue.destination as? ElementDetailViewController,
                let cell = sender as? UITableViewCell,
                let indexPath = tableView.indexPath(for: cell) {
                edvc.element = elements[indexPath.row]
            }
        }
    }
    
}
