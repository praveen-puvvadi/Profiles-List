//
//  ViewController.swift
//  BT Group
//
//  Created by Praveen Kumar on 19/02/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var activityView: UIActivityIndicatorView?
    
    private var viewModel: ProfileListViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ProfileListViewModel()
        viewModel?.delegate = self
        activityView?.isHidden = true
        tableView?.dataSource = self
        addSwipeGestures()
        
        if Reachability.isConnectedToNetwork() {
            viewModel?.makeAPICallToGetDetails(pageNo: viewModel!.currentPageNo) {
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
                }
            }
        } else {
            self.showToastLabel(message: "Please check your internet connection!")
        }
    }
    
    private func addSwipeGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    func makeSwipeAPICall(page: Int) {
        viewModel?.makeAPICallInSwipe(page: page) {
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }
    
    @objc func respondToSwipeGesture(gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .right:
            print("Swiped right")
            if viewModel?.currentPageNo ?? 0 < viewModel?.totalPageNo ?? 0 {
                makeSwipeAPICall(page: (viewModel?.currentPageNo ?? 0)+1)
            }
        case .left:
            print("Swiped left")
            makeSwipeAPICall(page: (viewModel?.currentPageNo ?? 0)-1)
        default:
            break
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel!.profileDetailsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsListTableViewCell") as! DetailsListTableViewCell
        cell.profileImage.layer.cornerRadius = 8
        if let data = viewModel?.profileDetailsArray[indexPath.row] {
            let fullName = "\(data.first_name ?? "") \(data.last_name ?? "")"
            cell.nameLabel.text = fullName
            cell.emailLabel.text = data.email ?? ""
            
            if let url = URL(string: data.avatar ?? "") {
                UIImage.loadFrom(url: url) { image in
                    cell.profileImage.image = image
                }
            }
        }
        return cell
    }
}

extension ViewController: ProfileListViewModelDelegate {
    
    func showLoader() {
        DispatchQueue.main.async {
            self.activityView?.isHidden = false
            self.activityView?.startAnimating()
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            self.activityView?.stopAnimating()
            self.activityView?.isHidden = true
        }
    }
    
    func showToastMessage(message: String) {
        self.showToastLabel(message: message)
    }
}
