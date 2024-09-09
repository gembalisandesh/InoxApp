//
//  MovieCollectionViewCell.swift
//  InoxApp
//
//  Created by Equipp on 08/09/24.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    private var movieDetail: MovieDetails?
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    private let pgRatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textAlignment = .left
        label.textColor = .darkGray
        return label
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textAlignment = .left
        label.textColor = .darkGray
        label.numberOfLines = 1
        return label
    }()
    
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textAlignment = .left
        label.textColor = .darkGray
        return label
    }()
    
    private let bookTicketButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Book Tickets", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return button
    }()
    
    private let infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "info.circle"), for: .normal)
        button.tintColor = .darkGray
        return button
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.clipsToBounds = true

        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(pgRatingLabel)
        contentView.addSubview(genreLabel)
        contentView.addSubview(languageLabel)
        contentView.addSubview(bookTicketButton)
        contentView.addSubview(infoButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.57),
                      
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 2),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            pgRatingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            pgRatingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            genreLabel.leadingAnchor.constraint(equalTo: pgRatingLabel.trailingAnchor, constant: 10),
            genreLabel.centerYAnchor.constraint(equalTo: pgRatingLabel.centerYAnchor),
            
            languageLabel.topAnchor.constraint(equalTo: pgRatingLabel.bottomAnchor, constant: 4),
            languageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            languageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            bookTicketButton.topAnchor.constraint(equalTo: languageLabel.bottomAnchor, constant: 8),
            bookTicketButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            bookTicketButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            bookTicketButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7),
            bookTicketButton.heightAnchor.constraint(equalToConstant: 36),
            
            infoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            infoButton.centerYAnchor.constraint(equalTo: bookTicketButton.centerYAnchor),
            infoButton.widthAnchor.constraint(equalToConstant: 36),
            infoButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }


    private func setupActions() {
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        bookTicketButton.addTarget(self, action: #selector(bookTicketButtonTapped), for: .touchUpInside)
    }

    @objc private func bookTicketButtonTapped() {
        guard let movieDetail = movieDetail else { return }
        let bookingVC = BookingViewController(movieDetails: movieDetail)
        if let viewController = self.findViewController() {
            viewController.navigationController?.pushViewController(bookingVC, animated: true)
        }
    }

    func configure(with movieDetail: MovieDetails) {
        self.movieDetail = movieDetail
        titleLabel.text = movieDetail.filmName
        pgRatingLabel.text = movieDetail.PGRating
        genreLabel.text = movieDetail.filmGenre
        languageLabel.text = "Language: \(movieDetail.languages.first?.language ?? "N/A")"
        
        if let portraitPoster = movieDetail.languages.first?.potraitPoster, !portraitPoster.isEmpty {
            imageView.loadImage(from: portraitPoster)
        } else {
            imageView.image = UIImage(named: "moviePlaceholder")
        }
    }
    
    @objc private func infoButtonTapped() {
        guard let movieDetail = movieDetail else { return }
        
        let detailsVC = MovieDetailsViewController(movieDetails: movieDetail)
        if let viewController = self.findViewController() {
            viewController.present(detailsVC, animated: true, completion: nil)
        }
    }
}

