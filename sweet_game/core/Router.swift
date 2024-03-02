//
//  Router.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 29.02.2024.
//

import SwiftUI
import Combine

enum ViewSpec: Hashable {
    case showSweetBlissLevels
    case showSweetBlissGame(SweetBlissGameLevel)
    case showSweetGameJoys
    case showMain
    case shopShop
}

extension ViewSpec: Identifiable {
    var id: Self { self }
}

public class MainRouter: Router {
    
    override func view(spec: ViewSpec, route: Route) -> AnyView {
        AnyView(buildView(spec: spec, route: route))
    }
    
    @ViewBuilder
    func buildView(spec: ViewSpec, route: Route) -> some View {
        switch spec {
        case let .showSweetBlissGame(level):
            SweetBlissGame(level: level)
        case .showSweetBlissLevels:
            SweetBlissGameLevelView()
        case .showSweetGameJoys:
            SweetGameJoysView()
        case .showMain:
            MainView()
        case .shopShop:
            ShopView()
        }
    }
}

protocol Routing {}

public class Router: Routing, ObservableObject {
    
    enum Route {
        case navigation
        case sheet
        case fullScreenCover
    }
    
    struct State {
        var navigationPath: [ViewSpec] = []
        var presentingSheet: ViewSpec? = nil
        var presentingFullScreen: ViewSpec? = nil
        var isPresented: Binding<ViewSpec?>
        
        var isPresenting: Bool {
            presentingSheet != nil || presentingFullScreen != nil
        }
    }
    
    @Published private(set) var state: State
    
    init(isPresented: Binding<ViewSpec?>) {
        state = State(isPresented: isPresented)
    }
    
    func view(spec: ViewSpec, route: Route) -> AnyView {
        AnyView(EmptyView())
    }
}

extension Router {
    
    func navigateTo(_ viewSpec: ViewSpec) {
        state.navigationPath.append(viewSpec)
    }
    
    func navigateBack() {
        if state.navigationPath.count > 0 {
            state.navigationPath.removeLast()
        }
    }
    
    func replaceNavigationStack(path: [ViewSpec]) {
        state.navigationPath = path
    }
    
    func presentSheet(_ viewSpec: ViewSpec) {
        state.presentingSheet = viewSpec
    }
    
    func presentFullScreen(_ viewSpec: ViewSpec) {
        state.presentingFullScreen = viewSpec
    }
    
    func dismiss() {
        if state.presentingSheet != nil {
            state.presentingSheet = nil
        } else if state.presentingFullScreen != nil {
            state.presentingFullScreen = nil
        }
        else if navigationPath.count > 1 {
            state.navigationPath.removeLast()
        } else {
            state.isPresented.wrappedValue = nil
        }
    }
}

extension Router {
    
    var navigationPath: Binding<[ViewSpec]> {
        binding(keyPath: \.navigationPath)
    }
    
    var presentingSheet: Binding<ViewSpec?> {
        binding(keyPath: \.presentingSheet)
    }
    
    var presentingFullScreen: Binding<ViewSpec?> {
        binding(keyPath: \.presentingFullScreen)
    }
    
    var isPresented: Binding<ViewSpec?> {
        state.isPresented
    }
}

private extension Router {
    
    func binding<T>(keyPath: WritableKeyPath<State, T>) -> Binding<T> {
        Binding(
            get: { self.state[keyPath: keyPath] },
            set: { self.state[keyPath: keyPath] = $0 }
        )
    }
}

public struct RouterView<Container>: View where Container: View {
    
    init(router: Router, initial: @escaping () -> Container) {
        self._router = .init(wrappedValue: router)
        self.initial = initial
    }
    
    @StateObject private var router: Router
    private let initial: () -> Container
    
    public var body: some View {
        NavigationStack(path: router.navigationPath) {
            self.initial()
                .navigationBarHidden(true)
                .navigationDestination(for: ViewSpec.self) { spec in
                    router.view(spec: spec, route: .navigation)
                }
                .sheet(item: router.presentingSheet) { spec in
                    router.view(spec: spec, route: .sheet)
                }.fullScreenCover(item: router.presentingFullScreen) { spec in
                    router.view(spec: spec, route: .fullScreenCover)
                }
        }
    }
    
}

public protocol InjectionKey {
    /// The associated type representing the type of the dependency injection key's value.
    associatedtype Value

    /// The default value for the dependency injection key.
    static var currentValue: Self.Value { get set }
}

/// Provides access to injected dependencies.
public struct InjectedValues {
    /// This is only used as an accessor to the computed properties within extensions of `InjectedValues`.
    private static var current = InjectedValues()

    /// A static subscript for updating the `currentValue` of `InjectionKey` instances.
    public static subscript<K>(key: K.Type) -> K.Value where K: InjectionKey {
        get { key.currentValue }
        set { key.currentValue = newValue }
    }

    /// A static subscript accessor for updating and references dependencies directly.
    public static subscript<T>(_ keyPath: WritableKeyPath<InjectedValues, T>) -> T {
        get { current[keyPath: keyPath] }
        set { current[keyPath: keyPath] = newValue }
    }
}

@propertyWrapper
public struct Injected<T> {
    private let keyPath: WritableKeyPath<InjectedValues, T>
    public var wrappedValue: T {
        get { InjectedValues[keyPath] }
        set { InjectedValues[keyPath] = newValue }
    }

    public init(_ keyPath: WritableKeyPath<InjectedValues, T>) {
        self.keyPath = keyPath
    }
}

public class AppContext {
    var router: Router

    public init(
        router: Router
    ) {
        self.router = router
        AppContextProviderKey.currentValue = self
    }
}

/// Returns the current value for the `StreamChat` instance.
private struct AppContextProviderKey: InjectionKey {
    static var currentValue: AppContext?
}

extension InjectedValues {
    /// Provides access to the `StreamChat` instance in the views and view models.
    var context: AppContext {
        get {
            guard let injected = Self[AppContextProviderKey.self] else {
                fatalError("Context was not setup")
            }
            return injected
        }
        set {
            Self[AppContextProviderKey.self] = newValue
        }
    }
}


extension InjectedValues {
    
    public var router: Router {
        get {
            context.router
        }
        set {
            context.router = newValue
        }
    }
}
