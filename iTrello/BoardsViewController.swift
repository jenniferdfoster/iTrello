//
//  BoardsViewController.swift
//  iTrello
//
//  Created by Jennifer Foster on 10/30/16.
//  Copyright © 2016 Jennifer Foster. All rights reserved.
//

import UIKit

class BoardsViewController: UITableViewController {
    
    var trelloAPI: TrelloAPI!
    var boards: [Board] = [Board]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       // Get all boards for the user
        trelloAPI.fetchAllBoards{
            (allBoards)->Void in
            self.boards = allBoards
            dispatch_async(dispatch_get_main_queue(), { self.tableView.reloadData() })
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boards.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BoardCell", forIndexPath: indexPath)
        let board = self.boards[indexPath.row]
        cell.textLabel?.text = board.name
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //If the triggered segue is the "Show Item" segue
        if segue.identifier == "ShowBoard" {
            //Figure out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                // Get the item associated with this row and pass it along
                let board = boards[row]
                let listsViewController = segue.destinationViewController as! ListsViewController
                listsViewController.board = board
                listsViewController.trelloAPI = self.trelloAPI
            }
        }
    }
}
