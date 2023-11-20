import UIKit

final class TabBarController: UITabBarController {
    
    let servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl(),
        profileStorage: ProfileStorageImpl(),
        userStorage: UserStorageImpl()
    )
    
    let profileAssembly = ProfileAssembly(
        editingProfileViewController: EditingProfileViewController(
            presenter: EditingProfilePresenter()),
        webViewerController: WebViewerController(),
        myNFTViewController: MyNFTViewController(
            presenter: MyNFTPresenter()),
        favouriteNFTViewController: FavouriteNFTViewController(
            presenter: FavouriteNFTPresenter()))
    

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
        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem

        let profilePresenter = ProfilePresenter(profileAssembly: profileAssembly)
        let profileViewController = ProfileViewController(presenter: profilePresenter) 
        profilePresenter.view = profileViewController
        
        let profileController = UINavigationController(rootViewController: profileViewController)
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
}
