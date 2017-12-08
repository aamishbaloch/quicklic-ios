//
//  AddCommentViewController.swift
//  Quicklic
//
//  Created by Furqan Nadeem on 12/8/17.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit


protocol commentDelegate{
    func  comments(textdata:String)
}

class AddCommentViewController: UIViewController,UITextViewDelegate {

    static let storyboardID = "addComentViewController"
    
    @IBOutlet weak var textView: UITextView!
    
    var delegate:commentDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        textView.text = "Type here"
        textView.textColor = UIColor.lightGray
        textView.layer.cornerRadius = 1
        textView.clipsToBounds = false
        textView.layer.shadowOpacity=0.4
        textView.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true) {
            self.delegate?.comments(textdata: self.textView.text)
        }
        
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Type here"
            textView.textColor = UIColor.lightGray
        }
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
