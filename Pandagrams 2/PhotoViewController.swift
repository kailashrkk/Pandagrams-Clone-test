//
//  PhotoViewController.swift
//  Pandagrams 2
//
//  Created by Kailash Ramaswamy on 30/09/15.
//  Copyright © 2015 NCh. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet weak var photoView: UIImageView!
    
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photoView.image = image
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButton(sender: AnyObject) {
        
    }

    @IBAction func saveButton(sender: AnyObject) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        
        dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
