//
//  ListTableViewController.swift
//  PokemonGuide
//
//  Created by yilmaz on 15.03.2024.
//

import UIKit
import Combine

final class ListTableViewController: UIViewController {
    
    var viewModel: ListTableViewModelView!
    
    @IBOutlet weak var tableView: UITableView!
    
    private var cancellables = Set<AnyCancellable>()

    private var items: [PokemonItem] = [] {
        didSet {
          tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        
        print(viewModel.title)
        
        items.append(PokemonItem(id: 1,
                                 name: "Bulbasaur",
                                 description: "There is a plant seed on its back right from the day this Pokémon is born. The seed slowly grows larger.",
                                 imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png"))
        
//        viewModel.fetchPokemonItems()
//            .receive(on: DispatchQueue.main)
//            .sink { _ in
//
//            } receiveValue: { [weak self] items in
//                self?.items = items
//            }
//            .store(in: &cancellables)
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
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCell", for: indexPath) as? ListViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(item: items[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.coordinator.showDetail(with: items[indexPath.row])
    }
}
