//
//  ApiManager.swift
//  PartyOrg
//
//  Created by Vuk Knežević on 2/9/19.
//  Copyright © 2019 Vuk Knežević. All rights reserved.
//

import Foundation

class Api {
    
    static public let manager = Api()
    private init() {}
        
    public func getProfiles(handler: @escaping ([ProfileModel]?) -> Void) {
        
        let urlString = BASE_URL
        
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            do {
                var profileModels: [ProfileModel]?
                let response = try JSONDecoder().decode(Profiles.self, from: data)
                if let profiles = response.profiles {
                   profileModels = profiles
                }

                handler(profileModels)
                
            } catch let jsonErr {
                print("Error serializing JSON:", jsonErr)
            }
            }.resume()
    }
    
}
