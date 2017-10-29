//
//  WebClient.swift
//  WeatherApp
//
//  Created by Danial Zahid on 12/26/15.
//  Copyright © 2015 Danial Zahid. All rights reserved.
//

import UIKit

let RequestManager = WebClient.sharedInstance

class WebClient: AFHTTPSessionManager {
    
    //MARK: - Shared Instance
    static let sharedInstance = WebClient(url: NSURL(string: Constant.serverURL)!, securityPolicy: AFSecurityPolicy(pinningMode: AFSSLPinningMode.publicKey))
    
    
    convenience init(url: NSURL, securityPolicy: AFSecurityPolicy){
        self.init(baseURL: url as URL)
        self.securityPolicy = securityPolicy
        
        
    }
    
    
    func postPath(urlString: String,
                  params: [String: AnyObject],
                  addToken: Bool = true,
                  successBlock success:@escaping (AnyObject) -> (),
                  failureBlock failure: @escaping (String) -> ()){
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        
        if let sessionID = UserDefaults.standard.value(forKey: "token") as? String , addToken == true {
            manager.requestSerializer.setValue("Bearer \(sessionID)", forHTTPHeaderField: "Authorization")
        }
        
        manager.post((NSURL(string: urlString, relativeTo: self.baseURL)?.absoluteString)!, parameters: params, progress: nil, success: {
            (sessionTask, responseObject) -> () in
            print(responseObject ?? "")
            success(responseObject! as AnyObject)
        },  failure: {
            (sessionTask, error) -> () in
            print(error)
            let err = error as NSError
            do {
                if let data = err.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? Data {
                    let dictionary = try JSONSerialization.jsonObject(with: data,
                                                                      options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: String]
                    failure(dictionary["detail"]!)
                }
                else{
                    failure("Failed to connect")
                }
            }catch
            {
                
            }
            
        })
    }
    
    func multipartPost(urlString: String,
                       params: [String: AnyObject],
                       image: UIImage?,
                       addToken: Bool = true,
                       successBlock success:@escaping (AnyObject) -> (),
                       failureBlock failure: @escaping (String) -> ()){
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        
        
        if let sessionID = UserDefaults.standard.value(forKey: "token") as? String , addToken == true {
            manager.requestSerializer.setValue("Bearer \(sessionID)", forHTTPHeaderField: "Authorization")
        }
        manager.post((NSURL(string: urlString, relativeTo: self.baseURL)?.absoluteString)!, parameters: params, constructingBodyWith: { (data) in
            if let imageData = UIImagePNGRepresentation(image ?? UIImage()) {
                data.appendPart(withFileData: imageData, name: "avatar", fileName: "profile", mimeType: "image/jpeg")
            }
        }, progress: { (progress) in
            
        }, success: {
            (sessionTask, responseObject) -> () in
            print(responseObject ?? "")
            success(responseObject! as AnyObject)
        },  failure: {
            (sessionTask, error) -> () in
            print(error)
            let err = error as NSError
            do {
                if let data = err.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? Data {
                    let dictionary = try JSONSerialization.jsonObject(with: data,
                                                                      options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: String]
                    failure(dictionary["detail"]!)
                }
                else{
                    failure("Failed to connect")
                }
            }catch
            {
                
            }
        })
    }
    
    func getPath(urlString: String,
                 params: [String: AnyObject]?,
                 addToken: Bool = true,
                 successBlock success:@escaping (AnyObject) -> (),
                 failureBlock failure: @escaping (String) -> ()){
        
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        
        if let sessionID = UserDefaults.standard.value(forKey: "token") as? String , addToken == true {
            manager.requestSerializer.setValue("Bearer \(sessionID)", forHTTPHeaderField: "Authorization")
        }
        
        
        manager.get((NSURL(string: urlString, relativeTo: self.baseURL)?.absoluteString)!, parameters: params, progress: nil, success: {
            (sessionTask, responseObject) -> () in
            print(responseObject ?? "")
            success(responseObject! as AnyObject)
        }, failure: {
            (sessionTask, error) -> () in
            print(error)
            let err = error as NSError
            do {
                if let data = err.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? Data {
                    let dictionary = try JSONSerialization.jsonObject(with: data,
                        options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: String]
                    failure(dictionary["detail"]!)
                }
                else{
                    failure("Failed to connect")
                }
            }catch
            {
                
            }
            
        })
    }
    
    
    
    func signUpUser(param: [String: Any], successBlock success:@escaping ([String: AnyObject]) -> (),
                    failureBlock failure:@escaping (String) -> ()){
        self.postPath(urlString: Constant.registrationURL, params: param as [String : AnyObject],addToken: false, successBlock: { (response) in
            print(response)
            success(response as! [String : AnyObject])
        }) { (error) in
            failure(error)
        }
    }
    
    func loginUser(param: [String: Any], successBlock success:@escaping ([String: AnyObject]) -> (),
                   failureBlock failure:@escaping (String) -> ()){
        self.postPath(urlString: Constant.loginURL, params: param as [String : AnyObject],addToken: false, successBlock: { (response) in
            print(response)
            success(response as! [String : AnyObject])
        }) { (error) in
            failure(error)
        }
    }
    
    func verifyUser(param: [String: Any], successBlock success:@escaping ([String: AnyObject]) -> (),
                    failureBlock failure:@escaping (String) -> ()){
        self.postPath(urlString: "auth/verify/", params: param as [String : AnyObject], successBlock: { (response) in
            print(response)
            success(response as! [String : AnyObject])
        }) { (error) in
            failure(error)
        }
    }
    
    func editUser(param: [String: Any],image: UIImage?, successBlock success:@escaping ([String: AnyObject]) -> (),
                  failureBlock failure:@escaping (String) -> ()){
        
        let url = ApplicationManager.sharedInstance.userType == .Patient ? "patient/" : "doctor/"
        
        self.multipartPost(urlString: url, params: param as [String : AnyObject], image: image, successBlock: { (response) in
            success(response as! [String : AnyObject])
        }) { (error) in
            failure(error)
        }
    }
    
    func getCities(query: String, successBlock success:@escaping ([[String: AnyObject]]) -> (),
                   failureBlock failure:@escaping (String) -> ()){
        self.getPath(urlString: "city/", params: ["query":query as AnyObject], successBlock: { (response) in
            print(response)
            success(response as! [[String : AnyObject]])
        }) { (error) in
            failure(error)
        }
    }
    
    func getServices(query: String, successBlock success:@escaping ([[String: AnyObject]]) -> (),
                   failureBlock failure:@escaping (String) -> ()){
        self.getPath(urlString: "service/", params: ["query":query as AnyObject], successBlock: { (response) in
            print(response)
            success(response as! [[String : AnyObject]])
        }) { (error) in
            failure(error)
        }
    }
    
    func getSpecializations(query: String, successBlock success:@escaping ([[String: AnyObject]]) -> (),
                   failureBlock failure:@escaping (String) -> ()){
        self.getPath(urlString: "specialization/", params: ["query":query as AnyObject], successBlock: { (response) in
            print(response)
            success(response as! [[String : AnyObject]])
        }) { (error) in
            failure(error)
        }
    }
    
    func getCountries(query: String, successBlock success:@escaping ([[String: AnyObject]]) -> (),
                      failureBlock failure:@escaping (String) -> ()){
        self.getPath(urlString: "country/", params: ["query":query as AnyObject], successBlock: { (response) in
            print(response)
            success(response as! [[String : AnyObject]])
        }) { (error) in
            failure(error)
        }
    }
    
    func getOccupations(query: String, successBlock success:@escaping ([[String: AnyObject]]) -> (),
                        failureBlock failure:@escaping (String) -> ()){
        self.getPath(urlString: "occupation/", params: ["query":query as AnyObject], successBlock: { (response) in
            print(response)
            success(response as! [[String : AnyObject]])
        }) { (error) in
            failure(error)
        }
    }
    
    func getDoctorsList( params: [String: Any], successBlock success:@escaping ([[String: AnyObject]]) -> (),
                         failureBlock failure:@escaping (String) -> ()){
        
        var params = params
        params["active"] = "true"
        
        self.getPath(urlString: "doctor/list/", params: params as [String : AnyObject], successBlock: { (response) in
            print(response)
            success(response as! [[String : AnyObject]])
        }) { (error) in
            failure(error)
        }
    }
    
    func getClinicsList(successBlock success:@escaping ([[String: AnyObject]]) -> (),
                         failureBlock failure:@escaping (String) -> ()){
        
        
        let url = ApplicationManager.sharedInstance.userType == .Patient ? "patient/clinic" : "doctor/clinic"
        
        self.getPath(urlString: url, params: [:], successBlock: { (response) in
            print(response)
            success(response as! [[String : AnyObject]])
        }) { (error) in
            failure(error)
        }
    }
    
    func addClinic( params: [String: Any], successBlock success:@escaping ([[String: AnyObject]]) -> (),
                         failureBlock failure:@escaping (String) -> ()){
        
        let url = ApplicationManager.sharedInstance.userType == .Patient ? "patient/clinic" : "doctor/clinic"
        
        self.getPath(urlString: url, params: params as [String : AnyObject], successBlock: { (response) in
            print(response)
            success(response as! [[String : AnyObject]])
        }) { (error) in
            failure(error)
        }
    }

   
    
}
