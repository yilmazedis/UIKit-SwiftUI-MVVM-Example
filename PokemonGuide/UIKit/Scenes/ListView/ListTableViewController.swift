//
//  ListTableViewController.swift
//  PokemonGuide
//
//  Created by yilmaz on 15.03.2024.
//

import UIKit
import Combine

private struct Constants {
    struct Cell {
        static let identifier = "ListViewCell"
        static let nibName = "ListViewCell"
    }
}

private enum Section { case main }
private typealias ListDataSource = UITableViewDiffableDataSource<Section, PokemonItem>
private typealias ListSnapshot = NSDiffableDataSourceSnapshot<Section, PokemonItem>

final class ListTableViewController: UIViewController {

    // MARK: - Properties
    
    private var viewModel: ListTableViewModel!
    
    @IBOutlet private weak var tableView: UITableView!
    
    private lazy var dataSource: ListDataSource = configureDataSource()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    convenience init(viewModel: ListTableViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        bindViewModel()
    }
    
    // MARK: - Private Methods
    
    private func prepareView() {
        tableView.register(UINib(nibName: Constants.Cell.nibName, bundle: nil), forCellReuseIdentifier: Constants.Cell.identifier)
        title = "Pokémon"
        tableView.delegate = self
    }
    
    private func bindViewModel() {
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
            }
            .store(in: &cancellables)
    }
    
    private func applySnapshot(from items: [PokemonItem]) {
        var snapshot = ListSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - ListDataSource

extension ListTableViewController {
    private func configureDataSource() -> ListDataSource {
        ListDataSource(tableView: tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.identifier, for: indexPath) as! ListViewCell
            cell.configure(item: item)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension ListTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedItem = dataSource.itemIdentifier(for: indexPath) {
            viewModel.coordinator.showDetail(with: selectedItem)
        }
    }
}
