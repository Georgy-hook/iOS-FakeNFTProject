//
//  CollectionViewController.swift
//  FakeNFT
//
//  Created by Руслан  on 06.11.2023.
//

import UIKit

protocol CollectionViewControllerProtocol: AnyObject & LoadingView & ErrorView {
    var presenter: CollectionPresenterProtocol { get set }
    func updateCollectionView()
    func setupCollection(_ collections: CollectionModel)    
    func showAlertWithTime(_ retryAction: @escaping () -> Void)
}

final class CollectionViewController: UIViewController & CollectionViewControllerProtocol {
    
    // MARK: Public properties
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    var presenter: CollectionPresenterProtocol
    
    // MARK: Private properties
    private var authorURL: String = ""
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    
    private let coverImage: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    
    private let nameLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 22, weight: .bold)
        view.textColor = .black
        return view
    }()
    
    private let authorTitleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .systemFont(ofSize: 13, weight: .medium)
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 13, weight: .regular)
        view.textColor = .black
        view.numberOfLines = 0
        return view
    }()
    
    private lazy var authorNameLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 15, weight: .regular)
        view.textColor = .systemBlue
        view.numberOfLines = 0
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(didTapUserNameLabel(_:)))
        )
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.dataSource = self
        view.register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.identifier)
        view.delegate = self
        view.isScrollEnabled = false
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    // MARK: Initialization
    init(presenter: CollectionPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.view = self
        self.presenter.viewDidLoad()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            hidesBottomBarWhenPushed = false
        }
    }
    
    // MARK: Public methods
    func setupCollection(_ collections: CollectionModel) {
        let author = presenter.getAuthor()
        authorURL = author.website
        authorNameLabel.text = author.name
        
        let urlString = collections.cover.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlString!)
        coverImage.kf.indicatorType = .activity
        coverImage.kf.setImage(with: url)
        
        nameLabel.text = collections.name
        descriptionLabel.text = collections.description
        authorTitleLabel.text = "Автор коллекции:"
        heightCollection(of: collections.nfts.count)
    }
    
    func updateCollectionView() {
        collectionView.reloadData()
    }
    
    func showAlertWithTime(_ retryAction: @escaping () -> Void) {
        let alert = UIAlertController(title: "Ошибка сервера", message: "Повторите попытку через:", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Назад", style: .cancel) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        let reloadAction = UIAlertAction(title: "Повторить", style: .default) { _ in retryAction() }
        reloadAction.isEnabled = false
        
        let timeLabel = UILabel()
        timeLabel.textAlignment = .center
        timeLabel.font = .systemFont(ofSize: 13, weight: .medium)
        alert.view.addSubviews(timeLabel)
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: alert.view.centerYAnchor, constant: 5)
        ])
        var seconds = 18
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            DispatchQueue.main.async {
                timeLabel.text = "\(seconds) сек"
            }
            if seconds > 1 { seconds -= 1
            } else { UIView.animate(withDuration: 0.3) { timeLabel.alpha = 0 }
                reloadAction.isEnabled = true; timer.invalidate()
            }
        }
        alert.addAction(cancelAction); alert.addAction(reloadAction)
        present(alert, animated: true) { timer.fire() }
    }

    // MARK: Private methods
    private func heightCollection(of nftsCount: Int) {
        let collectionHeight = (Constants.cellHeight.rawValue +
                                Constants.lineMargins.rawValue) *
                                ceil(CGFloat(nftsCount) /
                                Constants.cellCols.rawValue)
        collectionView.heightAnchor.constraint(equalToConstant: collectionHeight).isActive = true
        navigationController?.hidesBarsOnSwipe = nftsCount > 6
    }
    
    // MARK: Selectors
    @objc
    private func didTapUserNameLabel(_ sender: Any) {
        guard let urlString = authorURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlString)
        else { return }
        let webViewController = WebViewViewController(webSite: url)
        webViewController.modalPresentationStyle = .fullScreen
        present(webViewController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        presenter.getNftsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionCell.identifier,
            for: indexPath
        ) as? CollectionCell else {
            assertionFailure("Failed to dequeue CollectionCell for indexPath: \(indexPath)")
            return UICollectionViewCell()
        }
        cell.delegate = self
        
        setupCell(cell, indexPath)

        return cell
    }
    
    private func setupCell(_ cell: CollectionCell, _ indexPath: IndexPath) {
        presenter.getNftsIndex(indexPath.row) { cellModel in
            switch cellModel {
            case .success(let cellModel):
                cell.configureCell(cellModel)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CollectionViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = floor((collectionView.frame.width - Constants.cellMargins.rawValue * (Constants.cellCols.rawValue - 1)) / Constants.cellCols.rawValue)
            return CGSize(width: width, height: Constants.cellHeight.rawValue)
        }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return Constants.cellMargins.rawValue
        }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.lineMargins.rawValue
    }
}

// MARK: - UIGestureRecognizerDelegate
extension CollectionViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - CollectionCellDelegate
extension CollectionViewController: CollectionDelegate {
    func collectionCellDidTapLike(_ cell: CollectionCellProtocol, nftId: String) {
        presenter.reverseLike(cell: cell, id: nftId)
    }
    func collectionCellDidTapCart(_ cell: CollectionCellProtocol, nftId: String) {
        presenter.addDeleteInCart(cell: cell, id: nftId)
    }
}

// MARK: - Setup Views/Constraints
private extension CollectionViewController {
    func setupViews() {
        view.backgroundColor = .white
        setupNavigationBar()
        setupScrollView()
        setupActivityIndicator()
        
        scrollView.addSubviews(coverImage, nameLabel, authorTitleLabel, authorNameLabel, descriptionLabel, collectionView)
        
        setupCoverImage()
        setupNameLabel()
        setupAuthorTitleLabel()
        setupAuthorNameLabel()
        setupDescriptionLabel()
        setupCollectionView()
    }
    
    func setupNavigationBar() {
        let backItem = UIBarButtonItem()
        backItem.title = nil
        backItem.tintColor = .black
        navigationController?.navigationBar.topItem?.backBarButtonItem = backItem
    }
    
    func setupScrollView() {
        view.addSubviews(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupActivityIndicator() {
        view.addSubviews(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupCoverImage() {
        NSLayoutConstraint.activate([
            coverImage.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            coverImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coverImage.heightAnchor.constraint(equalToConstant: 310),
            coverImage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupNameLabel() {
        scrollView.addSubviews(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sideMargins.rawValue)
        ])
    }
    
    func setupAuthorTitleLabel() {
        NSLayoutConstraint.activate([
            authorTitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 13),
            authorTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sideMargins.rawValue)
        ])
    }
    
    func setupAuthorNameLabel() {
        NSLayoutConstraint.activate([
            authorNameLabel.topAnchor.constraint(equalTo: authorTitleLabel.topAnchor),
            authorNameLabel.leadingAnchor.constraint(equalTo: authorTitleLabel.trailingAnchor, constant: 4),
            authorNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.sideMargins.rawValue)
        ])
    }
    
    func setupDescriptionLabel() {
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: authorTitleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sideMargins.rawValue),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.sideMargins.rawValue)
        ])
    }
    
    func setupCollectionView() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sideMargins.rawValue),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.sideMargins.rawValue),
            collectionView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}

// MARK: - Constants
private extension CollectionViewController {
    enum Constants: CGFloat {
        case cellMargins = 9
        case lineMargins = 8
        case cellCols = 3
        case cellHeight = 192
        case sideMargins = 16
    }
}
