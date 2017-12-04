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
       //UserDefaults.standard.set(nil, forKey: "userPhone")
       //UserDefaults.standard.set(nil, forKey: "userPassword")
        UserDefaults.standard.set("", forKey: "token")
        UserDefaults.standard.set(nil, forKey: "loggedIn")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()
        
        appDelegate.window?.rootViewController = controller
    }
    
    func showProfile() {
        let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ProfileViewController.storyboardID) as! UINavigationController
       // let vc = controller.viewControllers.first as! ProfileViewController
       // vc.editable = false
        centralRootViewController.setContentViewController(controller, animated: true)
        centralRootViewController.hideViewController()
        
    }
    
    func showEditProfile(fromController: UIViewController) {
        let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: EditProfileViewController.storyboardID) as! EditProfileViewController
        
        controller.editable = true
        fromController.show(controller, sender: fromController)
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
    
    func showVerification(fromController: UIViewController) {
    let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: VerificationViewController.storyboardID)
    fromController.show(controller, sender: nil)
    }
    
    func hideSideMenu() {
        centralRootViewController.hideViewController()
    }
    
    func showAppointmentDetails(appointment: Appointment, appointmentIndex: Int, fromController: UIViewController) {
        let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: AppointmentDetailsViewController.storyboardID) as! AppointmentDetailsViewController
        controller.appointment = appointment
        controller.appointmentIndex = appointmentIndex
        
        if let from = fromController as? AppointmentStatusDelegate {
            controller.delegate = from
        }
       
        fromController.present(controller, animated: false, completion: nil)
    }
    
    func showHospitalDetails(clinic: Clinic, fromController: UIViewController) {
        let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: HospitalDetailsViewController.storyboardID) as! HospitalDetailsViewController
        controller.clinic = clinic
        controller.delegate = fromController as? HospitalDeletionDelegate
        fromController.present(controller, animated: false, completion: nil)
    }
    
    func showClinicsList() {
        let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ClinicListViewController.storyboardID)
        centralRootViewController.setContentViewController(controller, animated: true)
        centralRootViewController.hideViewController()
    }
    
    func showLabsList() {
        let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ClinicListViewController.storyboardID) as! UINavigationController
        let vc = controller.viewControllers.first as! ClinicListViewController
        vc.isLab = true
        centralRootViewController.setContentViewController(controller, animated: true)
        centralRootViewController.hideViewController()
    }
    
    func showDoctorDetails(doctor: User, fromController: UIViewController) {
        let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: DoctorDetailViewController.storyboardID) as! DoctorDetailViewController
        if let from = fromController as? DoctorDetailDelegate {
            controller.delegate = from
        }
        controller.doctor = doctor
        fromController.present(controller, animated: false, completion: nil)
    }
    
    
    //-->> Furqan
    func createAppointment(doctor: User, fromController: UIViewController) {
        let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: CreateAppointmentViewController.storyboardID) as! CreateAppointmentViewController
        controller.doctor = doctor
       fromController.present(controller, animated: false, completion: nil)
    }
    
    func addReview(appointment: Appointment, fromController: UIViewController) {
        let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: AddReviewViewController.storyboardID) as! AddReviewViewController
        controller.appointment = appointment
        fromController.present(controller, animated: false, completion: nil)
    }
    
    func showTests(clinic: Clinic, fromController: UIViewController) {
        let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: TestListViewController.storyboardID) as! TestListViewController
        controller.clinic = clinic
        fromController.navigationController?.show(controller, sender: nil)
    }
    
    func showTestDetail(test: Test, fromController: UIViewController) {
        let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: TestDetailViewController.storyboardID) as! TestDetailViewController
        controller.test = test
        fromController.navigationController?.show(controller, sender: nil)
    }
    
    func reasonSelection(fromController: UIViewController) {
        let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ReasonSelectionViewController.storyboardID) as! UINavigationController
        let vc = controller.viewControllers.first as! ReasonSelectionViewController
        if let from = fromController as? ReasonSelectionDelegate {
            vc.delegate = from
        }
        
        fromController.present(controller, animated: true, completion: nil)
    }
    
    func showConfirmation(appointment: Appointment, fromController: UIViewController) {
        let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ConfirmationViewController.storyboardID) as! ConfirmationViewController
          controller.appointment = appointment
        
        fromController.show(controller, sender: nil)
    }
    
    func showReviews(/*doctor:User*/) {
        let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ReviewsViewController.storyboardID) as! UINavigationController
//         let vc = controller.viewControllers.first as! ReviewsViewController
      
        centralRootViewController.setContentViewController(controller, animated: true)
        centralRootViewController.hideViewController()
        
    }
 
    
}
