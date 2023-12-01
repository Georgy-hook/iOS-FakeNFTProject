final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let profileStorage: ProfileStorage
    private let userStorage: UserStorage

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        profileStorage: ProfileStorage,
        userStorage: UserStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.profileStorage = profileStorage
        self.userStorage = userStorage
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }
    var profileService: ProfileService {
        ProfileServiceImpl(
            networkClient: networkClient,
            profileStorage: profileStorage)
    }
    var userService: UserService {
        UserServiceImpl(
            networkClient: networkClient,
            storage: userStorage)
    }
}
