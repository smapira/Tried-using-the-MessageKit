//
//  ViewController.swift
//  Tried-using-the-MessageKit
//
//  Created by bookpro on 2021/08/01.
//  Copyright © 2021 routeflags. All rights reserved.
//

import UIKit

class ThreadsTableViewController: UITableViewController {
	let model = generateRandomData()

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.register(ThreadsTableViewCell.self,
						   forCellReuseIdentifier: ThreadsTableViewCell.reuseIdentifier)
		tableView.reloadData()
	}

	// MARK: - UITableViewDelegate

	override func tableView(_ tableView: UITableView,
				   didSelectRowAt indexPath: IndexPath) {
		print("Table view at row selected index path \(indexPath)")
	}
	
	// MARK: - UITableViewDataSource

	override func tableView(_ tableView: UITableView,
				   numberOfRowsInSection section: Int) -> Int {
		return model.count
	}
	
	override func tableView(_ tableView: UITableView,
				   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: ThreadsTableViewCell.reuseIdentifier,
												 for: indexPath) as! ThreadsTableViewCell
		cell.backgroundColor = model[indexPath.row]
		return cell
	}

}

