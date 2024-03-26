//
//  ListTableViewController.swift
//  PokemonGuide
//
//  Created by yilmaz on 15.03.2024.
//

import UIKit
import Combine

final class ListTableViewController: UIViewController {
    
    var viewModel: ListTableViewModel!
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        viewModel.fetchPokemonItems()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching Pokemon items: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] items in
                self?.viewModel.items = items
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func prepareView() {
        tableView.register(UINib(nibName: "ListViewCell", bundle: nil), forCellReuseIdentifier: "ListViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        title = "Pokémon"
    }
}

extension ListTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCell", for: indexPath) as? ListViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(item: viewModel.items[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.coordinator.showDetail(with: viewModel.items[indexPath.row])
    }
}
