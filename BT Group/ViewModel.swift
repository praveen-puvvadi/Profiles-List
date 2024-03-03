//
//  ViewModel.swift
//  BT Group
//
//  Created by Praveen Kumar on 22/02/24.
//

import Foundation

protocol ProfileListViewModelDelegate: AnyObject {
    func showLoader()
    func hideLoader()
    func showToastMessage(message: String)
}

class ProfileListViewModel {
    
    weak var delegate: ProfileListViewModelDelegate?
    var profilesList: ProfilesList?
    var profileDetailsArray = [ProfilesData]()
    var currentPageNo = 1
    var totalPageNo = 0
    
    init() {}
    
    func networkingAPIHandler(urlString: String, completion: @escaping (Bool, ProfilesList, Error) -> Void) {
        let url = URL(string: urlString)!

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let profiles = try? JSONDecoder().decode(ProfilesList.self, from: data) else {
                print(error ?? "Unknown error")
                return
            }
            completion(error == nil ? true : false, profiles, error ?? NSError())
        }
        task.resume()
    }
    
    func makeAPICallToGetDetails(pageNo: Int, completion: @escaping () -> Void) {
        delegate?.showLoader()
        networkingAPIHandler(urlString: Constants.getUserProfiles+"\(pageNo)", completion: { [weak self] status, profiles, error in
            self?.delegate?.hideLoader()
            switch status {
            case true:
                self?.profilesList = profiles
                self?.currentPageNo = self?.profilesList?.page ?? 0
                self?.totalPageNo = self?.profilesList?.total_pages ?? 0
                if !(self?.profilesList?.data?.isEmpty ?? false) {
                    self?.profileDetailsArray = self?.profilesList?.data ?? []
                    completion()
                } else {
                    self?.delegate?.showToastMessage(message: "No more data!")
                }
            case false:
                DispatchQueue.main.async {
                    self?.delegate?.showToastMessage(message: "Something went wrong, Please try again!")
                }
            }
        })
    }
    
    func makeAPICallInSwipe(page: Int, completion: @escaping () -> Void) {
        if Reachability.isConnectedToNetwork() {
            if page != 0 {
                profileDetailsArray.removeAll()
                makeAPICallToGetDetails(pageNo: page) {
                    completion()
                }
            }
        } else {
            delegate?.showToastMessage(message: "Please check your internet connection!")
        }
    }
}
