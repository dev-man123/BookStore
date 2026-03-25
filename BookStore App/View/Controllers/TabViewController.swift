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
    case wishLsit = 2
    case profile = 3
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
        let wishlistVC = WishlistViewController()
        let profileVC = ProfileViewController()
        
        let homeNav = UINavigationController(rootViewController: homeVC)
        let addNav = UINavigationController(rootViewController: addVC)
        let wishlistNav = UINavigationController(rootViewController: wishlistVC)
        let profileNav = UINavigationController(rootViewController: profileVC)
        
        homeNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        addNav.tabBarItem = UITabBarItem(title: "Add", image: UIImage(systemName: "plus.circle.fill"), tag: 1)
        wishlistNav.tabBarItem = UITabBarItem(title: "Wishlist", image: UIImage(systemName: "heart.fill"), tag: 2)
        profileNav.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 3)
        
        viewControllers = [homeNav, addNav, wishlistNav, profileNav]
        selectedIndex = initialTab.rawValue
    }
}

