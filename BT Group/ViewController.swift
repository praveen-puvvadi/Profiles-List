//
//  ViewController.swift
//  BT Group
//
//  Created by Praveen Kumar on 19/02/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: ProfileListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = ProfileListViewModel(self)
        tableView.dataSource = self
        viewModel.makeAPICallToGetDetails(pageNo: viewModel.currentPageNo)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .left
        self.view.addGestureRecognizer(swipeDown)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .right:
                print("Swiped right")
                if viewModel.currentPageNo < viewModel.totalPageNo {
                    viewModel.makeAPICallInSwipe(page: viewModel.currentPageNo+1)
                }
            case .down:
                print("Swiped down")
            case .left:
                print("Swiped left")
                viewModel.makeAPICallInSwipe(page: viewModel.currentPageNo-1)
            case .up:
                print("Swiped up")
            default:
                break
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.profileDetailsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsListTableViewCell") as? DetailsListTableViewCell else { return UITableViewCell() }
        cell.profileImage.layer.cornerRadius = 8
        let data = viewModel.profileDetailsArray[indexPath.row]
        let fullName = "\(data["first_name"] as? String ?? "") \(data["last_name"] as? String ?? "")"
        cell.nameLabel.text = fullName
        cell.emailLabel.text = data["email"] as? String ?? ""
        
        if let url = URL(string: data["avatar"] as? String ?? "") {
            UIImage.loadFrom(url: url) { image in
                cell.profileImage.image = image
            }
        }
        return cell
    }
}

extension ViewController: ProfileListViewModelDelegate {
    
    func updateTableData() {
        tableView.reloadData()
    }
}
