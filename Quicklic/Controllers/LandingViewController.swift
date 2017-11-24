//
//  LandingViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 30/08/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if let phone = UserDefaults.standard.value(forKey: "loggedIn") as? Bool, phone != false {
            Router.sharedInstance.showDashboardAsRoot()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnnouncementCollectionViewCell.identifier, for: indexPath) as! AnnouncementCollectionViewCell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.collectionView.bounds.width, height: self.collectionView.bounds.height);
    }
    
    @IBAction func showHospitalDetails(_ sender: Any) {
//        Router.sharedInstance.showHospitalDetails(fromController: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
