//
//  PokemonList.swift
//  PokemonGuide
//
//  Created by yilmaz on 14.03.2024.
//

import SwiftUI

final class PokemonListViewModel: ObservableObject {
    @Published var items: [PokemonItem] = []
    private let httpTask: HTTPTaskProtocol
    
    init(httpTask: HTTPTask) {
        self.httpTask = httpTask
    }
    
    func fetchPokemonItems() async {
        guard let url = URL(string: Constants.pokemonListUrl) else { return }
        
        do {
            
            let items = try await httpTask.downloadWithAsync(url: url)
            await MainActor.run {
                self.items = items
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct PokemonList: View {
    
    @StateObject var viewModel: PokemonListViewModel
    @Environment(\.dismiss) var dismiss
    
    init(viewModel: PokemonListViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(viewModel.items, id: \.self) { item in
                        NavigationLink(value: item) {
                            PokemonRowView(item: item)
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
                Spacer()
            }
            .navigationDestination(for: PokemonItem.self) { item in
                PokemonDetailView(item: item)
            }
            .navigationBarItems(
                leading: Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
            )
            .navigationTitle("Pokémon")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(
                Color("toolbarColor"),
                for: .navigationBar
            )
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .task {
            await viewModel.fetchPokemonItems()
        }
    }
}

#Preview {
    let httpTask = HTTPTask()
    let vm = PokemonListViewModel(httpTask: httpTask)
    return PokemonList(viewModel: vm)
}
