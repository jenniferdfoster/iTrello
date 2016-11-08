//
//  ListsViewController.swift
//  iTrello
//
//  Created by Jennifer Foster on 11/2/16.
//  Copyright © 2016 Jennifer Foster. All rights reserved.
//

import UIKit

class ListsViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var board: Board!
    var pages = [UIViewController]()
    var trelloAPI: TrelloAPI!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        self.title = board.name
        
        self.view.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        let pageControl = UIPageControl.appearance()
        pageControl.currentPageIndicatorTintColor = UIColor.darkGrayColor()
        pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
        
        
        trelloAPI.fetchListsForBoard(board: board) {
            (boardLists)->Void in
            self.board.lists = boardLists
            
            for pageIndex in 0...self.board.lists.count - 1 {
                let page: CardsViewController! = self.storyboard?.instantiateViewControllerWithIdentifier("ListTableViewID") as? CardsViewController
                page.list = self.board.lists[pageIndex]
                page.trelloAPI = self.trelloAPI
                self.pages.append(page)
            }
            if self.pages.count > 0 {
                dispatch_async(dispatch_get_main_queue(),
                               {self.setViewControllers([self.pages.first!], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)})
            }
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = pages.indexOf(viewController)!
        if index == 0 || index == NSNotFound {
            return nil
        }
        index -= 1
        return pages[index]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = pages.indexOf(viewController)!
        index += 1
        if index == pages.count || index == NSNotFound {
            return nil
        }
        return pages[index]
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}