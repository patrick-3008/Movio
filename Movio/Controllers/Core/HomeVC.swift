//
//  HomeVC.swift
//  Movio
//
//  Created by iMac on 02/03/2024.
//

import UIKit

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeVC: UIViewController {
    
    private var randomTrendingMovie: Title?
    private var headerView: HeroHeaderUIView?
    
    let sectionTitles: [String] = ["Trending Movies", "Trending Tv", "Popular", "Upcoming Movies", "Top rated"]
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavBar()
        
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
        
        configureHeroHeaderView()
    }
    
    private func configureHeroHeaderView() {
        
        APICaller.shared.getTitles(for: APIType.getTrendingMovies, completion: { [weak self] result in
            switch result {
                case .success(let titles):
                    let selectedTitle = titles.randomElement()
                    self?.randomTrendingMovie = selectedTitle
                    
                    self?.headerView?.configure(with: TitleViewModel(titleName: selectedTitle?.original_name ?? "", posterURL: selectedTitle?.poster_path ?? ""))
                    
                case .failure(let error):
                    print("error in getting random movie \(error.localizedDescription)")
            }
        })
    }
    
    private func configureNavBar() {
        
        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
}

// MARK: - Home table

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        switch indexPath.section {
            case Sections.TrendingMovies.rawValue:
                APICaller.shared.getTitles(for: APIType.getTrendingMovies, completion: { result in
                    switch result {
                        case .success(let titles):
                            cell.configure(with: titles)
                        case .failure(let error):
                            print(error.localizedDescription)
                    }
                })
            case Sections.TrendingTv.rawValue:
                APICaller.shared.getTitles(for: APIType.getTrendingTvs, completion: { result in
                    switch result {
                        case .success(let titles):
                            cell.configure(with: titles)
                        case .failure(let error):
                            print(error.localizedDescription)
                    }
                })
            case Sections.Popular.rawValue:
                APICaller.shared.getTitles(for: APIType.getPopular, completion: { result in
                    switch result {
                        case .success(let titles):
                            cell.configure(with: titles)
                        case .failure(let error):
                            print(error.localizedDescription)
                    }
                })
            case Sections.Upcoming.rawValue:
                APICaller.shared.getTitles(for: APIType.getUpcomingMovies, completion: { result in
                    switch result {
                        case .success(let titles):
                            cell.configure(with: titles)
                        case .failure(let error):
                            print(error.localizedDescription)
                    }
                })
            case Sections.TopRated.rawValue:
                APICaller.shared.getTitles(for: APIType.getTopRated, completion: { result in
                    switch result {
                        case .success(let titles):
                            cell.configure(with: titles)
                        case .failure(let error):
                            print(error.localizedDescription)
                    }
                })
                
            default:
                return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        let systemBackgroundColor = self.view.backgroundColor ?? .white
        
        header.textLabel?.textColor = systemBackgroundColor.isLight ? .black : .white
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    // navigation bar scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}

// MARK: - for push title preview screen

extension HomeVC: CollectionViewTableViewCellDelegate {
    
    func CollectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewVC()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
