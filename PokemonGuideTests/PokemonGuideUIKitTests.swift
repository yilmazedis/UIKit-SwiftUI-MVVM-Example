//
//  PokemonGuideUIKitTests.swift
//  PokemonGuideTests
//
//  Created by yilmaz on 15.03.2024.
//

import XCTest
import Combine
@testable import PokemonGuide

final class PokemonGuideUIKitTests: XCTestCase {
    var viewModel: ListTableViewModel!
    var mockHttpTask: MockHTTPTask!
    
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        mockHttpTask = MockHTTPTask()
        viewModel = ListTableViewModel(coordinator: ListTableCoordinator(navigator: nil), httpTask: mockHttpTask)
    }
    
    override func tearDown() {
        viewModel = nil
        mockHttpTask = nil
        super.tearDown()
    }
    
    func testFetchPokemonItems_Success() async throws {
        let expectedItems = [PokemonItem.dummy]
        mockHttpTask.itemsToReturn = expectedItems
        
        viewModel.fetchPokemonItems()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { items in
                XCTAssertEqual(items, expectedItems)
            }
            .store(in: &cancellables)
    }
    
    func testFetchPokemonItems_Failure() async throws {
        mockHttpTask.shouldThrowError = true
        
        viewModel.fetchPokemonItems()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { items in
                XCTAssertTrue(items.isEmpty)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - ListTableCoordinator Tests
    
    // Test if coordinator starts without crashing
    // forexample if I forget to assign ViewModel my app will crash
    // Because it is only force unwrap
    func testListTableCoordinatorStart() {
        let navigator = UINavigationController()
        let coordinator = ListTableCoordinator(navigator: navigator)
        coordinator.start()
        
        let vm = (navigator.topViewController as? ListTableViewController)?.viewModel
        XCTAssertNotNil(vm)
    }
    
    // MARK: - ListDetailCoordinator Tests
    
    // Test if coordinator starts without crashing
    // forexample if I forget to assign ViewModel my app will crash
    // Because it is only force unwrap
    func testListDetailCoordinatorStart() {
        let navigator = UINavigationController()
        let coordinator = ListDetailCoordinator(navigator: navigator)
        coordinator.start(with: PokemonItem.dummy)
        
        let vm = (navigator.topViewController as? ListDetailViewController)?.viewModel
        XCTAssertNotNil(vm)
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
