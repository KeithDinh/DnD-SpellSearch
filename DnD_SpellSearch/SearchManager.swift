//
//  SearchManager.swift
//  DnD_SpellSearch
//
//  Created by student on 11/6/20.
//  Copyright © 2020 Dillon Jones & Kiet Dinh. All rights reserved.
//  Fetch Data from API

import Foundation

//Manager for API interactions

protocol SearchManagerDelegate {
    func didUpdateList(_ searchManager: SearchManager, list: [Spells])
    func didFailWithError(error: Error)
}

struct SearchManager {
    let spellUrl = "https://www.dnd5eapi.co/api/spells"
    let schoolUrl = "https://www.dnd5eapi.co/api//spells?school"
    let levelUrl = "https://www.dnd5eapi.co/api//spells?level"
    var delegate: SearchManagerDelegate?
    
    func fetchSchoolList(school: String) {
        let urlString = "\(schoolUrl)=\(school)"
        downloadData(with: urlString)
    }
    func fetchLevelList(level: Int) {
        let urlString = "\(levelUrl)=\(level)"
        downloadData(with: urlString)
    }
    func fetchList() {
        downloadData(with: spellUrl)
    }
    
    //NETWORKING PART
    func downloadData(with urlString: String) {
        //1. Create URL
        if let url = URL(string: urlString) {
            
            //2. Create URL session (acts like a browser)
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task (in this case, it is a data task)
            //Instead of Closure: let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let goodData = data {
                    if let list = self.decodeData(goodData) {
                        self.delegate?.didUpdateList(self, list: list)
                    }
                }
            }
            task.resume()
        }
    }

    //DECODING PART
    func decodeData(_ downloaded_data: Data) -> [Spells]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Root.self, from: downloaded_data)
            var spellList = [Spells]()
            for item in decodedData.results {
                spellList.append(item)
            }
            return spellList
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }

}
