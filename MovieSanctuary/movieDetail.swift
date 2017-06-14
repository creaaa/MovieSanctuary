//
//  movieDetail.swift
//  MovieSanctuary
//
//  Created by Mattia on 2017-06-08.
//  Copyright © 2017 masa. All rights reserved.
//

import UIKit

class movieDetail {

    var title: String
    var director: String
    var actors: String
    var genre: String
    var story: String
    var stars: Int
    
    
    var posterPath: String?
    
    init(title: String, director: String, genre: String, actors: String, story: String, stars: Int) {
        self.title = title
        self.director = director
        self.genre = genre
        self.actors = actors
        self.story = story
        self.stars = stars
        
    }
    
    
}
