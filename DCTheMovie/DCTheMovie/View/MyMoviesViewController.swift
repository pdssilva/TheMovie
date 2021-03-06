//
//  MyMoviesViewController.swift
//  DCTheMovie
//
//  Created by Daniel Colnaghi on 30/11/17.
//  Copyright © 2017 Cold Mass Digital Entertainment. All rights reserved.
//

import UIKit

class MyMoviesViewController: UIViewController {

    var myMoviesVM = MyMoviesViewModel()
    @IBOutlet weak var tblMovies: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        myMoviesVM.reloadData()
        tblMovies.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MovieDetailsViewController {
            if let sender = sender as? Movie {
                vc.movieDetailVM = MovieDetailViewModel(movie: sender)
            }
        }
    }
}

extension MyMoviesViewController: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myMoviesVM.countMovies
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "moviecell") as? MyMovieCell else {
            return UITableViewCell()
        }
        
        cell.loadCellWithMovie(myMoviesVM.movieAtIndex(indexPath.row)!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = myMoviesVM.movieAtIndex(indexPath.row)
        performSegue(withIdentifier: "segueMyMovies", sender: data)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let act1 = UITableViewRowAction(style: .normal, title: "Watched") { (rowAction, index) in
            if let movie = self.myMoviesVM.movieAtIndex(indexPath.row) {

                // Add movie to watched list
                self.myMoviesVM.moveToWatchedList(Movie: movie)
                self.myMoviesVM.removeMovie(movie)
                
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
        act1.backgroundColor = UIColor.blue
        
        let act2 = UITableViewRowAction(style: .destructive, title: "Delete") { (rowAction, index) in
            if let movie = self.myMoviesVM.movieAtIndex(indexPath.row) {

                // Remove movie from must watch list
                self.myMoviesVM.removeMovie(movie)
                
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
        // Set Watched and Delete action
        return [act2, act1]
    }
}
