import UIKit

final class TabBarController: UITabBarController {
    
    private let servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl(),
        profileStorage: ProfileStorageImpl(),
        userStorage: UserStorageImpl()
    )
    
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(named: "YP Catalog"),
        tag: 0
    )

    private let profileTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.profile", comment: ""),
        image: UIImage(named: "YP Profile"),
        tag: 1
    )
    
    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.cart", comment: ""),
        image: UIImage(named: "YP Cart"),
        tag: 2
    )
    
    private let statsTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.stats", comment: ""),
        image: UIImage(named: "YP Statistics"),
        tag: 3
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogInteractor = CatalogInteractor(networkClient: DefaultNetworkClient())
        let catalogPresenter = CatalogPresenter(interactor: catalogInteractor)
        let catalogController = UINavigationController(rootViewController: CatalogViewController(presenter: catalogPresenter, router: Router.shared))
        catalogController.tabBarItem = catalogTabBarItem
        
        /// Profile
        let profileController = configureProfile()
        profileController.tabBarItem = profileTabBarItem
        
        let cartController = UIViewController()
        cartController.tabBarItem = cartTabBarItem
        
        let statsController = UIViewController()
        statsController.tabBarItem = statsTabBarItem

        viewControllers = [catalogController, profileController, cartController, statsController]
        view.backgroundColor = UIColor(named: "YP White")
        tabBar.tintColor = UIColor(named: "YP Blue")
        tabBar.unselectedItemTintColor = UIColor(named: "YP Black")
    }
    
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
}
