//
//  CardsViewController.swift
//  iTrello
//
//  Created by Jennifer Foster on 11/2/16.
//  Copyright © 2016 Jennifer Foster. All rights reserved.
//

import UIKit

class CardsViewController: UITableViewController {
    var list: List!
    var trelloAPI: TrelloAPI!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
        getCards()
    }
    
    func getCards() {
        
        // Get all boards for the user
        trelloAPI.fetchCardsForList(list: self.list) {
            (listCards)->Void in
            self.list.cards = listCards
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.setNeedsLayout()
                self.tableView.layoutIfNeeded()
                self.tableView.reloadData() })
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.cards.count + 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == self.list.cards.count {
            let cell = tableView.dequeueReusableCellWithIdentifier("AddNewCardCell", forIndexPath: indexPath)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("CardCell", forIndexPath: indexPath) as! CardCell
            let card = self.list.cards[indexPath.row]
            cell.nameLabel?.text = card.name
            cell.descriptionLabel?.text = card.description
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.list.name
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == self.list.cards.count {
            addNewCard()
        }
        else {
            updateCard(self.list.cards[indexPath.row])
        }
    }
    
    func addNewCard() {
        
        let title = "Add New Card"
        let message = "Create a new card in \(list.name)"
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                        style: .Cancel,
                                        handler: nil)
        
        let saveAction = UIAlertAction(title: "Save",
                                        style: .Default,
                                        handler: {
            alert -> Void in
                
            let titleTextField = alertController.textFields![0] as UITextField
            let descriptionTextField = alertController.textFields![1] as UITextField
                
            self.trelloAPI.addCard(titleTextField.text!, description: descriptionTextField.text!, listID: self.list.id) {
                (newCard)->Void in
                self.list.cards.append(newCard)
                dispatch_async(dispatch_get_main_queue(), { self.tableView.reloadData() })
            }
        })
            
        alertController.addTextFieldWithConfigurationHandler {
            (textField : UITextField!) -> Void in
            textField.placeholder = "Name"
        }
        alertController.addTextFieldWithConfigurationHandler {
            (textField : UITextField!) -> Void in
            textField.placeholder = "Description"
        }
            
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
            
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func updateCard(card: Card) {
        
        let title = "Edit Card"
        let message = ""
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .Cancel,
                                         handler: nil)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: UIAlertActionStyle.Default,
                                       handler: {
            alert -> Void in
            
            let titleTextField = alertController.textFields![0] as UITextField
            let descriptionTextField = alertController.textFields![1] as UITextField
            
            self.trelloAPI.updateCard(card.id, name: titleTextField.text!, description: descriptionTextField.text!) {
                (updatedCard)->Void in
                card.name = updatedCard.name
                card.description = updatedCard.description
                dispatch_async(dispatch_get_main_queue(), { self.tableView.reloadData() })
            }
        })
        
        alertController.addTextFieldWithConfigurationHandler {
            (textField : UITextField!) -> Void in
            textField.placeholder = "Name"
            textField.text = card.name
        }
        alertController.addTextFieldWithConfigurationHandler {
            (textField : UITextField!) -> Void in
            textField.placeholder = "Description"
            textField.text = card.description
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func deleteCard(sender: AnyObject) {
        let button = sender as! UIButton
        let view = button.superview! as UIView
        let cell = view.superview as! CardCell
        let indexPath = self.tableView.indexPathForCell(cell)
        let card = self.list.cards[indexPath!.row]
        
        let title = "Delete \(card.name)"
        let message = "Are you sure you want to delete this card?"
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .Cancel,
                                         handler: nil)
        
        let deleteAction = UIAlertAction(title: "Delete",
                                         style: .Destructive,
                                         handler: { (action) -> Void in
            self.trelloAPI.deleteCard(card: card)
            self.list.cards.removeAtIndex(indexPath!.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}
