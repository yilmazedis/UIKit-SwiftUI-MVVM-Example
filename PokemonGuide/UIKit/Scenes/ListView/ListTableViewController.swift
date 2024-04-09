//
//  ListTableViewController.swift
//  PokemonGuide
//
//  Created by yilmaz on 15.03.2024.
//

import UIKit
import Combine

fileprivate typealias ListDataSource = UITableViewDiffableDataSource<ListTableViewController.Section, PokemonItem>
fileprivate typealias ListSnapshot = NSDiffableDataSourceSnapshot<ListTableViewController.Section, PokemonItem>

final class ListTableViewController: UIViewController {

    var viewModel: ListTableViewModel!
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var dataSource: ListDataSource!
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        configureDataSource()
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
                self?.applySnapshot(from: items)
                
                self?.viewModel.fetchPokemonItems()
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                        switch completion {
                        case .failure(let error):
                            print("Error fetching Pokemon items: \(error)")
                        case .finished:
                            break
                        }
                    } receiveValue: { [weak self] items in
                        self?.applySnapshot(from: items)
                    }
                    .store(in: &self!.cancellables)
            }
            .store(in: &cancellables)
    }
    
    private func prepareView() {
        tableView.register(UINib(nibName: "ListViewCell", bundle: nil), forCellReuseIdentifier: "ListViewCell")
        title = "Pokémon"
        tableView.delegate = self
    }
    
    private func configureDataSource() {
        dataSource = ListDataSource(tableView: tableView) { tableView, indexPath, item in
            /// I already registered ListViewCell, so I dont worry it to put under guard let condition. So it is guarantee not to be crashed.
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCell", for: indexPath) as! ListViewCell
            cell.configure(item: item)
            return cell
        }
    }
    
    private func applySnapshot(from items: [PokemonItem]) {
        var snapshot = ListSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension ListTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedItem = dataSource.itemIdentifier(for: indexPath) {
            viewModel.coordinator.showDetail(with: selectedItem)
        }
    }
}

extension ListTableViewController {
    // Enum is bydefault hashable
    fileprivate enum Section {
        case main
    }
}
