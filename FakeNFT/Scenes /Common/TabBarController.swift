import UIKit

final class TabBarController: UITabBarController {
    // MARK: TabBarItems
    private let profileTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.profile", comment: ""),
        image: UIImage(named: "YP Profile"),
        tag: 0
    )
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(named: "YP Catalog"),
        tag: 1
    )

    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.cart", comment: ""),
        image: UIImage(named: "YP Cart"),
        tag: 2
    )
    
    // MARK: Services
    private let servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl(),
        profileStorage: ProfileStorageImpl(),
        userStorage: UserStorageImpl()
    )
    
    private let cartService = CartServiceImpl(networkClient: DefaultNetworkClient(), storage: CartStorageImpl())

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Profile
        let profileController = configureProfile()
        profileController.tabBarItem = profileTabBarItem
        
        /// Catalog
        let catalogController = configureCatalog()
        catalogController.tabBarItem = catalogTabBarItem
        
        /// Cart
        let cartController = configureCart()
        cartController.tabBarItem = cartTabBarItem

        viewControllers = [profileController, catalogController, cartController]
        view.backgroundColor = UIColor(named: "YP White")
        tabBar.tintColor = UIColor(named: "YP Blue")
        tabBar.unselectedItemTintColor = UIColor(named: "YP Black")
    }
    
    // MARK: configuration of viewControllers
    private func configureProfile() -> UIViewController {
        let profileAssembly = ProfileAssembly(
            editingProfileViewController: EditingProfileViewController(
                presenter: EditingProfilePresenter()),
            webViewerController: WebViewerController(),
            myNFTViewController: MyNFTViewController(
                presenter: MyNFTPresenter(servicesAssembly: servicesAssembly)),
            favouriteNFTViewController: FavouriteNFTViewController(
                presenter: FavouriteNFTPresenter(servicesAssembly: servicesAssembly))
        )
        let profilePresenter = ProfilePresenter(profileAssembly: profileAssembly)
        let profileViewController = ProfileViewController(presenter: profilePresenter)
        profilePresenter.view = profileViewController
        let profileController = UINavigationController(rootViewController: profileViewController)
        return profileController
    }
    
    private func configureCatalog() -> UIViewController {
        let catalogInteractor = CatalogInteractor(networkClient: DefaultNetworkClient())
        let catalogPresenter = CatalogPresenter(interactor: catalogInteractor)
        let catalogController = UINavigationController(rootViewController: CatalogViewController(presenter: catalogPresenter, router: Router.shared))
        return catalogController
    }
    
    private func configureCart() -> UIViewController {
        let cartPresenter = CartViewPresenterImpl(service: cartService)
        let cartController = CartViewController(
            presenter: cartPresenter
        )
        cartPresenter.view = cartController
        return cartController
    }
}
