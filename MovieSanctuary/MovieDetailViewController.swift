//
//  MovieDetailViewController.swift
//  MovieSanctuary
//
//  Created by Mattia on 2017-06-08.
//  Copyright © 2017 masa. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    
   
    @IBOutlet weak var imgMovie: UIImageView!
    @IBOutlet weak var titleMovie: UITextView!
    @IBOutlet weak var directorMovie: UITextView!
    @IBOutlet weak var genreMovie: UITextView!
    @IBOutlet weak var starsMovie: UITextView!
    @IBOutlet weak var storyMovie: UITextView!
    @IBOutlet weak var stackStar: UIStackView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
