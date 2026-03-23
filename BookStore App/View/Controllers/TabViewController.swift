//
//  TabViewController.swift
//  BookStore App
//
//  Created by Amit Kumar on 18/03/26.
//

import UIKit

enum Tab: Int {
    case home = 0
    case add = 1
    case profile = 2
}
final class MainTabViewController: UITabBarController {
    private var initialTab: Tab = .home
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        tabBar.backgroundColor = .systemBackground
    }
}

private extension MainTabViewController {
    private func setupTabs() {
        let homeVC = HomeViewController()
        let addVC = AddViewController()
        let profileVC = ProfileViewController()
        
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        addVC.tabBarItem = UITabBarItem(title: "Add", image: UIImage(systemName: "plus.circle.fill"), tag: 1)
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 2)
        
        viewControllers = [homeVC,addVC,profileVC]
        selectedIndex = initialTab.rawValue
        
    }
}

