//
//  MainView.swift
//  MyPlaces
//
//  Created by NIKOLAI BORISOV on 14.02.2022.
//

import UIKit
import RealmSwift

protocol MainViewDelegate: AnyObject {
    func sorted(by keyPath: String)
}

final class MainView: UIView {
    
    // MARK: - Public Properties
    
    public weak var delegate: MainViewDelegate?
    public var refreshControlPulled: (() -> Void)?
    
    public lazy var placesTableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isScrollEnabled = true
        $0.register(cell: PlaceCell.self)
        $0.tableHeaderView = UIView()
        $0.contentInsetAdjustmentBehavior = .never
        $0.separatorColor = .lightGray
        $0.backgroundColor = .white
        return $0
    }(UITableView())
    
    public lazy var activityIndicator = ActivityIndicatorView(color: .cyan, style: .large)
    public lazy var refreshControl = RefreshControlFactory.generateWith(color: .cyan)
    
    // MARK: - Private Properties
    
    public lazy var segmentedControl: UISegmentedControl = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.selectedSegmentTintColor = .systemBlue
        let normalTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        $0.setTitleTextAttributes(normalTextAttributes, for:.normal)
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        $0.setTitleTextAttributes(selectedTextAttributes, for:.selected)
        $0.selectedSegmentIndex = 0
        return $0
    }(UISegmentedControl(items: ["Date", "Name"]))
    
    // MARK: - Initializers
    
    init(delegate: MainViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        
        setupView()
        addSubviews()
        setupLayout()
        setupRefreshControl()
        addActionForSegmentedControl()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        activityIndicator.setup(on: self)
    }
    
    // MARK: - Actions
    
    @objc private func segmentedControlDidChange(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: delegate?.sorted(by: "date")
        case 1: delegate?.sorted(by: "name")
        default: break
        }
    }
    
    // MARK: - Actions
    
    @objc private func refreshData(sender: UIRefreshControl) {
        refreshControlPulled?()
        refreshControl.endRefreshing()
    }
    
    // MARK: - Private Methods
    
    private func addActionForSegmentedControl() {
        segmentedControl.addTarget(self, action: #selector(segmentedControlDidChange), for: .valueChanged)
    }
    
    private func setupRefreshControl() {
        placesTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    private func setupView() {
        backgroundColor = .white
    }
    
    private func addSubviews() {
        addSubview(placesTableView)
        addSubview(segmentedControl)
        addSubview(activityIndicator)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            placesTableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            placesTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            placesTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            placesTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            segmentedControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            segmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 5)
        ])
    }
    
}
