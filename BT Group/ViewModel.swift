//
//  ViewModel.swift
//  BT Group
//
//  Created by Praveen Kumar on 22/02/24.
//

import Foundation

protocol ProfileListViewModelDelegate: AnyObject {
    func updateTableData()
}

class ProfileListViewModel {
    
    weak var delegate: ProfileListViewModelDelegate?
    var profilesList: ProfilesList?
    var profileDetailsArray = [ProfilesData]()
    var currentPageNo = 1
    var totalPageNo = 0
    
    init() {}
    
    func makeAPICallToGetDetails(pageNo: Int) {
        let url = URL(string: "https://reqres.in/api/users?page=\(pageNo)")!

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data, let profiles = try? JSONDecoder().decode(ProfilesList.self, from: data) else {
                print(error ?? "Unknown error")
                return
            }
            self.profilesList = profiles
            self.currentPageNo = self.profilesList?.page ?? 0
            self.totalPageNo = self.profilesList?.total_pages ?? 0
            self.profileDetailsArray = self.profilesList?.data ?? []
            DispatchQueue.main.async {
                self.delegate?.updateTableData()
            }
        }
        task.resume()
    }
    
    func makeAPICallInSwipe(page: Int) {
        if page != 0 {
            profileDetailsArray.removeAll()
            makeAPICallToGetDetails(pageNo: page)
        }
    }
    
    private func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
