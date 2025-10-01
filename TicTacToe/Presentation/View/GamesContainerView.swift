//
//  GamesContainerView.swift
//  TicTacToe

import SwiftUI

struct GamesContainerView: View {
    @ObservedObject private var coordinator: AppCoordinator
    @StateObject private var viewModel: GamesContainerViewModel
    @State private var selectedTab: GamesTab = .available
    
    private let viewModelFactory: ViewModelFactory
    
    init(coordinator: AppCoordinator, viewModelFactory: ViewModelFactory) {
        self._coordinator = ObservedObject(initialValue: coordinator)
        self.viewModelFactory = viewModelFactory
        _viewModel = StateObject(wrappedValue: viewModelFactory.makeGamesContainerViewModel())
    }
    
    var body: some View {
        VStack {
            Picker("Games", selection: $selectedTab) {
                ForEach(GamesTab.allCases, id: \.self) { tab in
                    Text(tab.title).tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            Group {
                switch selectedTab {
                case .available:
                    AvailableGamesView(coordinator: coordinator, viewModelFactory: viewModelFactory)
                case .inProgress:
                    InProgressGamesView(coordinator: coordinator, viewModelFactory: viewModelFactory)
                }
            }
            .transition(.opacity.combined(with: .slide))
            .animation(.easeInOut, value: selectedTab)
        }
        .navigationTitle("Games")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { toolbarContent }
    }
}

private extension GamesContainerView {
    var createGameButton: some View {
        Button {
            coordinator.navigate(to: .newGame)
        } label: {
            Label("Create Game", systemImage: "plus.circle.fill")
                .font(.headline)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
    }

    var logoutButton: some View {
        Button(role: .destructive) {
            viewModel.logout()
        } label: {
            Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                .font(.subheadline)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.red.opacity(0.1))
        .foregroundColor(.red)
        .cornerRadius(6)
    }
    
    var toolbarContent: some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarLeading) { logoutButton }
            ToolbarItem(placement: .navigationBarTrailing) { createGameButton }
        }
    }
}

enum GamesTab: CaseIterable {
    case available
    case inProgress
    
    var title: String {
        switch self {
        case .available: return "Available"
        case .inProgress: return "My Active"
        }
    }
}
