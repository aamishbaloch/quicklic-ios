//
//  Router.swift
//  Map Hunt
//
//  Created by Danial Zahid on 16/08/2017.
//  Copyright © 2017 Fitsmind. All rights reserved.
//

import UIKit

class Router: NSObject {
    
    static let sharedInstance = Router()
    
    var centralRootViewController : RESideMenu!
    
    func showDashboardAsRoot(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let contentViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: PatientDashboardViewController.storyboardID)
        
        let leftMenuViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: LeftMenuViewController.storyboardID)
        
        centralRootViewController = RESideMenu(contentViewController: contentViewController, leftMenuViewController: leftMenuViewController, rightMenuViewController: nil)
        
        centralRootViewController?.menuPreferredStatusBarStyle = UIStatusBarStyle.lightContent
        centralRootViewController?.contentViewShadowColor = UIColor.white
        centralRootViewController?.contentViewShadowOffset = CGSize(width: 0, height: 0)
        centralRootViewController?.contentViewShadowOpacity = 0.6
        centralRootViewController?.contentViewShadowRadius = 12
        centralRootViewController?.contentViewInPortraitOffsetCenterX = 40.0
        centralRootViewController?.contentViewShadowEnabled = true
        
        appDelegate.window?.rootViewController = centralRootViewController
    }
    
    func showPatientDashboard() {
        let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: PatientDashboardViewController.storyboardID)
        centralRootViewController.setContentViewController(controller, animated: true)
        centralRootViewController.hideViewController()
    }
    
    func showLandingPage() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()
        
        appDelegate.window?.rootViewController = controller
    }
    
    func showPatientEditProfile() {
        let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: EditProfileViewController.storyboardID)
        centralRootViewController.setContentViewController(controller, animated: true)
        centralRootViewController.hideViewController()
        
    }
    
    func showSearchDoctor() {
        let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: SearchDoctorViewController.storyboardID)
        centralRootViewController.setContentViewController(controller, animated: true)
        centralRootViewController.hideViewController()
    }
    
    func showAppointmentHistory() {
        let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: AppointmentsHistoryViewController.storyboardID)
        centralRootViewController.setContentViewController(controller, animated: true)
        centralRootViewController.hideViewController()
    }
    
    func showPatientsList() {
        let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: PatientsListViewController.storyboardID)
        centralRootViewController.setContentViewController(controller, animated: true)
        centralRootViewController.hideViewController()
    }
    
    func hideSideMenu() {
        centralRootViewController.hideViewController()
    }
    
    func showAppointmentDetails(fromController: UIViewController) {
        let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: AppointmentDetailsViewController.storyboardID)
        fromController.present(controller, animated: false, completion: nil)
    }
    
    func showHospitalDetails(fromController: UIViewController) {
        let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: HospitalDetailsViewController.storyboardID)
        fromController.present(controller, animated: false, completion: nil)
    }
}
