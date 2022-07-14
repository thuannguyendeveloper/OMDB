//
//  MovieCell.swift
//  Movie
//
//  Created by ThuanNguyen on 7/14/22.
//

import UIKit
import SDWebImage

class MovieCell: UICollectionViewCell {
    
    static let identifier = "MovieCell"
    
    @IBOutlet weak var wrapView: UIView!
    @IBOutlet weak var wrapTitleView: UIView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        wrapTitleView.backgroundColor = .clear
        wrapView.layer.cornerRadius = 6
    }

    func configData(movie: Movie) {
        let image = UIImage(named: "img_placeholder")
        guard let url = URL(string: movie.poster) else {
            return
        }
        movieImageView.sd_setImage(with: url,
                             placeholderImage: image)
        titleLabel.text = movie.title
    }
    
}
