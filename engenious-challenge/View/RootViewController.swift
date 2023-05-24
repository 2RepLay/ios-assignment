//
//  ViewController.swift
//  engenious-challenge
//
//  Created by Abdullah Atkaev on 20.05.2022.
//

import UIKit
import Combine

class RootViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let repositoryService: RepositoryService = NetworkRepositoryService()
    let username: String = "Apple"
    var repoList: [Repo] = []
    
    let tv = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        title = "\(username)'s repos"
        navigationController?.navigationBar.prefersLargeTitles = true

        tv.delegate = self
        tv.dataSource = self
        tv.register(RepoTableViewCell.self, forCellReuseIdentifier: String(describing: RepoTableViewCell.self))
        tv.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tv)
        tv.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tv.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tv.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tv.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

		tv.separatorColor = .clear
		tv.allowsSelection = false
		
        getRepos()
    }

    func getRepos() {
		Task {
			let repoList = try await repositoryService.getUserRepos(username: username).value
			
			await MainActor.run(body: { 
				self.repoList = repoList
				self.tv.reloadData()
			})
		}
	}

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RepoTableViewCell.self)) as? RepoTableViewCell else { return UITableViewCell() }
        let repo = repoList[indexPath.row]
		cell.update(with: repo)
        return cell
    }

}
