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
        view.backgroundColor = Constants.Colors.clear
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    
    private let coverImage: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = Constants.Layout.cornerRadius
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    
    private let nameLabel: UILabel = {
        let view = UILabel()
        view.font = .headlineBold22
        view.textColor = Constants.Colors.black
        return view
    }()
    
    private let authorTitleLabel: UILabel = {
        let view = UILabel()
        view.textColor = Constants.Colors.black
        view.font = .captionMedium13
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let view = UILabel()
        view.font = .captionRegular13
        view.textColor = Constants.Colors.black
        view.numberOfLines = .zero
        return view
    }()
    
    private lazy var authorNameLabel: UILabel = {
        let view = UILabel()
        view.font = .captionRegular15
        view.textColor = Constants.Colors.blue
        view.numberOfLines = .zero
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
        view.backgroundColor = Constants.Colors.clear
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
    
    // MARK: Public methods
    func setupCollection(_ collections: CollectionModel) {
        let author = presenter.getAuthor()
        authorURL = author.website
        authorNameLabel.text = author.name
        
        guard let urlString = collections.cover.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = URL(string: urlString)
        coverImage.kf.indicatorType = .activity
        coverImage.kf.setImage(with: url)
        
        nameLabel.text = collections.name
        descriptionLabel.text = collections.description
        authorTitleLabel.text = Constants.Strings.authorTitle
        heightCollection(of: collections.nfts.count)
    }
    
    func updateCollectionView() {
        collectionView.reloadData()
    }
    
    func showAlertWithTime(_ retryAction: @escaping () -> Void) {
        let alert = UIAlertController(title: Constants.Strings.alertTitle, message: Constants.Strings.alertMessage, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: Constants.Strings.alertBackAction, style: .cancel) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        let retryAction = UIAlertAction(title: Constants.Strings.alertRetryAction, style: .default) { _ in retryAction() }
        retryAction.isEnabled = false
        
        let timeLabel = UILabel()
        timeLabel.textAlignment = .center
        timeLabel.font = .captionMedium13
        alert.view.addSubviews(timeLabel)
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: alert.view.centerYAnchor, constant: 5)
        ])
        var seconds = 18
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            DispatchQueue.main.async {
                timeLabel.text = "\(seconds) \(Constants.Strings.alertSeconds)"
            }
            if seconds > 1 { seconds -= 1
            } else { UIView.animate(withDuration: 0.3) { timeLabel.alpha = .zero }
                retryAction.isEnabled = true; timer.invalidate()
            }
        }
        alert.addAction(cancelAction); alert.addAction(retryAction)
        present(alert, animated: true) { timer.fire() }
    }

    // MARK: Private methods
    private func heightCollection(of nftsCount: Int) {
        let collectionHeight = (Constants.Layout.cellHeight +
                                Constants.Layout.lineMargins) *
                                ceil(CGFloat(nftsCount) /
                                     Constants.Layout.cellColumns)
        collectionView.heightAnchor.constraint(equalToConstant: collectionHeight).isActive = true
        navigationController?.hidesBarsOnSwipe = nftsCount > Constants.Layout.maxNumberOfCellsWithoutSwipe
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        goToDetail()
    }
    
    private func goToDetail() {}
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = floor((collectionView.frame.width - Constants.Layout.cellMargins * (Constants.Layout.cellColumns - 1)) / Constants.Layout.cellColumns)
            return CGSize(width: width, height: Constants.Layout.cellHeight)
        }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return Constants.Layout.cellMargins
        }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.Layout.lineMargins
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
    func collectionCellDidTapLike(cell: CollectionCellProtocol, nftId: String) {
        presenter.reverseLike(cell: cell, id: nftId)
    }
    func collectionCellDidTapCart(cell: CollectionCellProtocol, nftId: String) {
        presenter.addDeleteInCart(cell: cell, id: nftId)
    }
}

// MARK: - Setup Views/Constraints
private extension CollectionViewController {
    func setupViews() {
        view.backgroundColor = Constants.Colors.backgroundColor
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
        backItem.tintColor = Constants.Colors.black
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
            coverImage.heightAnchor.constraint(equalToConstant: Constants.Layout.coverImageHeight),
            coverImage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupNameLabel() {
        scrollView.addSubviews(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: Constants.Layout.sideMargins),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Layout.sideMargins)
        ])
    }
    
    func setupAuthorTitleLabel() {
        NSLayoutConstraint.activate([
            authorTitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Constants.Layout.authorTitleLabelTopAnchor),
            authorTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Layout.sideMargins)
        ])
    }
    
    func setupAuthorNameLabel() {
        NSLayoutConstraint.activate([
            authorNameLabel.topAnchor.constraint(equalTo: authorTitleLabel.topAnchor),
            authorNameLabel.leadingAnchor.constraint(equalTo: authorTitleLabel.trailingAnchor, constant: Constants.Layout.authorNameLabelLeadingAnchor),
            authorNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Layout.sideMargins)
        ])
    }
    
    func setupDescriptionLabel() {
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: authorTitleLabel.bottomAnchor, constant: Constants.Layout.descriptionLabelTopAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Layout.sideMargins),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Layout.sideMargins)
        ])
    }
    
    func setupCollectionView() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constants.Layout.sideMargins),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Layout.sideMargins),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Layout.sideMargins),
            collectionView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -Constants.Layout.sideMargins)
        ])
    }
}

// MARK: - Constants
private extension CollectionViewController {
    enum Constants {
        enum Layout {
            static let cornerRadius: CGFloat = 12
            static let cellMargins: CGFloat = 9
            static let lineMargins: CGFloat = 8
            static let cellColumns: CGFloat = 3
            static let cellHeight: CGFloat = 192
            static let sideMargins: CGFloat = 16
            
            static let coverImageHeight: CGFloat = 310
            static let authorTitleLabelTopAnchor: CGFloat = 13
            static let authorNameLabelLeadingAnchor: CGFloat = 4
            static let descriptionLabelTopAnchor: CGFloat = 5
            
            static let maxNumberOfCellsWithoutSwipe: Int = 6
        }

        enum Strings {
            static let authorTitle = "Автор коллекции:"
            static let alertTitle = "Ошибка сервера"
            static let alertMessage = "Повторите попытку через:"
            static let alertBackAction = "Назад"
            static let alertRetryAction = "Повторить"
            static let alertSeconds = "сек"
        }

        enum ImageNames {
            static let placeholder = "placeholder_image"
        }
        
        enum Colors {
            static let backgroundColor = UIColor.white
            static let blue = UIColor.systemBlue
            static let black = UIColor.black
            static let clear = UIColor.clear
        }
    }
}
