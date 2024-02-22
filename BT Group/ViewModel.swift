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
    var profileDetailsArray = [NSDictionary]()
    var currentPageNo = 1
    var totalPageNo = 0
    
    init(_ delegate: ProfileListViewModelDelegate) {
        self.delegate = delegate
    }
    
    func makeAPICallToGetDetails(pageNo: Int) {
        let url = URL(string: "https://reqres.in/api/users?page=\(pageNo)")!

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data, let string = String(data: data, encoding: .utf8) else {
                print(error ?? "Unknown error")
                return
            }
            let dict = self.convertToDictionary(text: string)
            self.currentPageNo = dict?["page"] as? Int ?? 0
            self.totalPageNo = dict?["total_pages"] as? Int ?? 0
            self.profileDetailsArray = dict?["data"] as? [NSDictionary] ?? []
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
