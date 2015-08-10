//
//  TeamSoundsTests.swift
//  TeamSoundsTests
//
//  Created by Said Marouf on 7/27/15.
//  Copyright (c) 2015 Said Marouf. All rights reserved.
//

import UIKit
import XCTest
//@testable //swift 2
import TeamSounds

class TeamSoundsTests: XCTestCase {
    
    var viewController: SearchViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        viewController = sb.instantiateViewControllerWithIdentifier("SearchViewController") as! SearchViewController
        let _ = viewController.view //make sure view loaded
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTableViewReadySet() {
        
        XCTAssertNotNil(viewController.tableView, "tableView should be loaded")
        XCTAssertNotNil(viewController.tableView.dataSource, "datasource not set")
        XCTAssertNotNil(viewController.tableView.delegate, "delegate not set!")
    }
    
    func testSearchBarReady() {
        
        XCTAssertNotNil(viewController.searchBar, "searchBar should be loaded")
        XCTAssertTrue(count(viewController.searchBar.text) == 0, "Search bar should be empty at start")
    }
    
    func testSCEngineReady() {
        
        
        
    }
    
    func testSCEngineSearchResultType() {
        
    }
    
}
