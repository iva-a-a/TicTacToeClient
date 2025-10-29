//
//  ViewModelFactory.swift
//  TicTacToe

import Foundation

@MainActor
final class ViewModelFactory {
    private let container: ContainerProvider
    private let coordinator: AppCoordinator
    private let errorHandler: ErrorHandlerProtocol

    init(container: ContainerProvider = .shared,
         coordinator: AppCoordinator,
         errorHandler: ErrorHandlerProtocol) {
        self.container = container
        self.coordinator = coordinator
        self.errorHandler = errorHandler
    }

    private var apiService: ApiServiceProtocol { container.resolve(ApiServiceProtocol.self) }
    private var currentUserService: CurrentUserServiceProtocol { container.resolve(CurrentUserServiceProtocol.self) }
    private var gameService: GameServiceProtocol { container.resolve(GameServiceProtocol.self) }
    private var userService: UserServiceProtocol { container.resolve(UserServiceProtocol.self) }
    private var tokenRepository: TokenRepositoryProtocol { container.resolve(TokenRepositoryProtocol.self) }
    private var sessionService: SessionServiceProtocol { container.resolve(SessionServiceProtocol.self) }

    func makeAvailableGamesViewModel() -> AvailableGamesViewModel {
        AvailableGamesViewModel(coordinator: coordinator,
                                apiService: apiService,
                                currentUserService: currentUserService,
                                gameService: gameService,
                                errorHandler: errorHandler)
    }

    func makeInProgressGamesViewModel() -> InProgressGamesViewModel {
        InProgressGamesViewModel(coordinator: coordinator,
                                 apiService: apiService,
                                 currentUserService: currentUserService,
                                 gameService: gameService,
                                 errorHandler: errorHandler)
    }
    
    func makeFinishedGamesViewModel() -> FinishedGamesViewModel {
        FinishedGamesViewModel(coordinator: coordinator,
                                 apiService: apiService,
                                 currentUserService: currentUserService,
                                 gameService: gameService,
                                 errorHandler: errorHandler)
    }

    func makeNewGameViewModel() -> NewGameViewModel {
        NewGameViewModel(coordinator: coordinator,
                         apiService: apiService,
                         currentUserService: currentUserService,
                         errorHandler: errorHandler)
    }

    func makeSignInViewModel() -> SignInViewModel {
        SignInViewModel(apiService: apiService,
                        currentUserService: currentUserService,
                        userService: userService,
                        sessionService: sessionService,
                        tokenRepository: tokenRepository,
                        coordinator: coordinator,
                        errorHandler: errorHandler)
    }

    func makeSignUpViewModel() -> SignUpViewModel {
        SignUpViewModel(apiService: apiService,
                        userService: userService,
                        coordinator: coordinator,
                        errorHandler: errorHandler)
    }

    func makeCurrentGameViewModel(gameId: UUID) -> CurrentGameViewModel {
        CurrentGameViewModel(gameId: gameId,
                             apiService: apiService,
                             currentUserService: currentUserService,
                             gameService: gameService,
                             coordinator: coordinator,
                             errorHandler: errorHandler)
    }

    func makeGamesContainerViewModel() -> GamesContainerViewModel {
        GamesContainerViewModel(coordinator: coordinator,
                                sessionService: sessionService,
                                errorHandler: errorHandler)
    }
    
    func makeLeaderboardViewModel() -> LeaderboardViewModel {
        LeaderboardViewModel(apiService: apiService,
                             currentUserService: currentUserService,
                             errorHandler: errorHandler)
    }
}
