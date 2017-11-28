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
                failure(error.localizedDescription)
            }
            
        })
    }
    
    func deletePath(urlString: String,
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
        manager.delete((NSURL(string: urlString, relativeTo: self.baseURL)?.absoluteString)!, parameters: params, success: {
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
                failure(error.localizedDescription)
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
                failure(error.localizedDescription)
            }
        })
    }
    
    
    
    
    func multipartPut(urlString: String,
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
        
        let request = manager.requestSerializer.multipartFormRequest(withMethod: "PUT", urlString: (NSURL(string: urlString, relativeTo: self.baseURL)?.absoluteString)!, parameters: params, constructingBodyWith: { (data) in
            if let imageData = UIImagePNGRepresentation(image ?? UIImage()) {
                data.appendPart(withFileData: imageData, name: "avatar", fileName: "profile", mimeType: "image/jpeg")
            }
        }, error: nil)
        
        let uploadTask = manager.uploadTask(withStreamedRequest: request as URLRequest, progress: { (progress) in
            //progress here
        }) { (response, responseObject, error) in
            if error == nil {
                print(response)
                print(responseObject ?? "")
                success(responseObject! as AnyObject)
            }
            else{
                print(error!)
                let err = error! as NSError
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
                    failure(err.localizedDescription)
                }
            }
        }
        
        uploadTask.resume()
        
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
                failure(error.localizedDescription)
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
        
        var url = ApplicationManager.sharedInstance.userType == .Patient ? "patient/" : "doctor/"
        url.append(ApplicationManager.sharedInstance.user.id!)
        self.multipartPut(urlString: url, params: param as [String : AnyObject], image: image, successBlock: { (response) in
            success(response as! [String : AnyObject])
        }) { (error) in
            failure(error)
        }
    }
    
//    func newEditUser(param: [String: Any],image: UIImage?, successBlock success:@escaping ([String: AnyObject]) -> (),
//                     failureBlock failure:@escaping (String) -> ()){
//
//        self.
//
//    }
    
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
        
        self.getPath(urlString: "patient/\(ApplicationManager.sharedInstance.user.id ?? "0")/doctor/", params: params as [String : AnyObject], successBlock: { (response) in
            print(response)
            success(response["results"] as! [[String : AnyObject]])
        }) { (error) in
            failure(error)
        }
    }
    
    func getClinicsList(successBlock success:@escaping ([[String: AnyObject]]) -> (),
                         failureBlock failure:@escaping (String) -> ()){
        
        
        let url = ApplicationManager.sharedInstance.userType == .Patient ? "patient/\(ApplicationManager.sharedInstance.user.id ?? "0")/clinic/" : "doctor/\(ApplicationManager.sharedInstance.user.id ?? "0")/clinic/"
        
        self.getPath(urlString: url, params: [:], successBlock: { (response) in
            print(response)
            success(response["results"] as! [[String : AnyObject]])
        }) { (error) in
            failure(error)
        }
    }
    
    func getLabsList(successBlock success:@escaping ([[String: AnyObject]]) -> (),
                        failureBlock failure:@escaping (String) -> ()){
        
        
        let url = "test/lab/"
        
        self.getPath(urlString: url, params: [:], successBlock: { (response) in
            print(response)
            success(response["results"] as! [[String : AnyObject]])
        }) { (error) in
            failure(error)
        }
    }
    
    func getTestsList(clinicID: String, successBlock success:@escaping ([[String: AnyObject]]) -> (),
                     failureBlock failure:@escaping (String) -> ()){
        
        
        let url = "clinic/\(clinicID)/test/"
        
        self.getPath(urlString: url, params: [:], successBlock: { (response) in
            print(response)
            success(response["results"] as! [[String : AnyObject]])
        }) { (error) in
            failure(error)
        }
    }
    
    func addClinic( params: [String: Any], successBlock success:@escaping ([String: AnyObject]) -> (),
                         failureBlock failure:@escaping (String) -> ()){
        
        let url = ApplicationManager.sharedInstance.userType == .Patient ? "patient/\(ApplicationManager.sharedInstance.user.id ?? "0")/clinic/" : "doctor/\(ApplicationManager.sharedInstance.user.id ?? "0")/clinic/"

        self.postPath(urlString: url, params: params as [String : AnyObject], successBlock: { (response) in
            print(response)
            success(response as! [String : AnyObject])
        }) { (error) in
            failure(error)
        }
    }
    
    func deleteClinic( clinicID: String, successBlock success:@escaping ([String: AnyObject]) -> (),
                    failureBlock failure:@escaping (String) -> ()){
        let url = String("patient/\(ApplicationManager.sharedInstance.user.id ?? "0")/clinic/") + clinicID
        self.deletePath(urlString: url, params: [:], successBlock: { (response) in
            print(response)
            success(response as! [String : AnyObject])
        }) { (error) in
            failure(error)
        }
    }
    
    func getReasonsList( params: [String: Any], successBlock success:@escaping ([[String: AnyObject]]) -> (),
                         failureBlock failure:@escaping (String) -> ()){
        
        self.getPath(urlString: "reason/", params: params as [String : AnyObject], successBlock: { (response) in
            print(response)
            success(response as! [[String : AnyObject]])
        }) { (error) in
            failure(error)
        }
    }
    
    func getDoctorClinicsList(doctorID: String, successBlock success:@escaping ([[String: AnyObject]]) -> (),
                         failureBlock failure:@escaping (String) -> ()){
        
        self.getPath(urlString: "patient/\(ApplicationManager.sharedInstance.user.id ?? "0")/doctor/\(doctorID)/clinic/", params: [:] as [String : AnyObject], successBlock: { (response) in
            print(response)
            success(response["results"] as! [[String : AnyObject]])
        }) { (error) in
            failure(error)
        }
    }
   
    func getTimeList(doctorID: String, params: [String: Any], successBlock success:@escaping ([[String: AnyObject]]) -> (),
                              failureBlock failure:@escaping (String) -> ()){
        
        self.getPath(urlString: "doctor/\(doctorID)/appointment_slots/", params: params as [String : AnyObject], successBlock: { (response) in
            print(response)
            success(response as! [[String : AnyObject]])
        }) { (error) in
            failure(error)
        }
    }
    
    /*
     {
     clinic =     {
     id = 1;
     image = "http://staging.quicklic.com/media/uploads/clinics/cvs-minute-clinic-walk-in-clinic-review_J61uC7B.jpg";
     name = "Baloch Clinic";
     };
     "created_at" = "2017-11-16T12:21:28.542223";
     doctor =     {
     avatar = "<null>";
     "first_name" = Dr;
     id = 2;
     "last_name" = "Jim Jones";
     phone = "+923214170655";
     specialization =         {
     id = 2;
     name = Radiology;
     };
     };
     "end_datetime" = "2017-11-15T12:50:00";
     id = 24;
     "is_active" = 1;
     notes = "<null>";
     patient =     {
     avatar = "<null>";
     "first_name" = Danial;
     id = 10;
     "last_name" = Zahid;
     phone = "+13349821389";
     };
     qid = "10-2-1900";
     reason =     {
     id = 2;
     name = "Followup Appointment";
     };
     "start_datetime" = "2017-11-15T12:00:00";
     status = 2;
     }
     */
    func createAppointment( params: [String: Any], successBlock success:@escaping ([String: AnyObject]) -> (), failureBlock failure:@escaping (String) -> ()){
        
        self.postPath(urlString: "appointment/", params: params as [String : AnyObject], successBlock: { (response) in
            print(response)
            success(response as! [String : AnyObject])
        }) { (error) in
            failure(error)
        }
    }
    
    func getAppointments(params: [String: Any],successBlock success:@escaping ([[String: AnyObject]]) -> (),
                                failureBlock failure:@escaping (String) -> ()){
        
        let url = ApplicationManager.sharedInstance.userType == .Patient ? "patient/\(ApplicationManager.sharedInstance.user.id ?? "0")/appointment/" : "doctor/\(ApplicationManager.sharedInstance.user.id ?? "0")/appointment/"
        
        self.getPath(urlString: url, params: params as [String : AnyObject], successBlock: { (response) in
            print(response)
            success(response["results"] as! [[String : AnyObject]])
        }) { (error) in
            failure(error)
        }
    }
   
    func appointmentStatus(doctorID: String ,appointmentID:String ,params: [String: Any], successBlock success:@escaping ([String: AnyObject]) -> (), failureBlock failure:@escaping (String) -> ()){
        
        self.postPath(urlString: "doctor/\(doctorID)/appointment/\(appointmentID)/status/", params: params as [String : AnyObject], successBlock: { (response) in
            print(response)
            success(response as! [String : AnyObject])
        }) { (error) in
            failure(error)
        }
    }
    
  
    
    
}
