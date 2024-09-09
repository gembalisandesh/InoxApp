//
//  MovieDetailsViewController.swift
//  InoxApp
//
//  Created by Equipp on 08/09/24.
//

import UIKit
import SafariServices

class MovieDetailsViewController: UIViewController {

    private let movieDetails: MovieDetails

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        return label
    }()

    private let pgRatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .darkGray
        return label
    }()

    private let runTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .darkGray
        return label
    }()

    private let genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .darkGray
        return label
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .darkGray
        return label
    }()

    private let castCrewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        return label
    }()

    private let directorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        return label
    }()

    private let synopsisLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        return label
    }()

    private let languagesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        return label
    }()

    private let trailerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Watch Trailer", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()

    private let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()

    init(movieDetails: MovieDetails) {
        self.movieDetails = movieDetails
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        configure(with: movieDetails)
    }

    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(pgRatingLabel)
        view.addSubview(runTimeLabel)
        view.addSubview(genreLabel)
        view.addSubview(statusLabel)
        view.addSubview(castCrewLabel)
        view.addSubview(directorLabel)
        view.addSubview(synopsisLabel)
        view.addSubview(languagesLabel)
        view.addSubview(trailerButton)
        view.addSubview(dismissButton)

        
        trailerButton.addTarget(self, action: #selector(trailerButtonTapped), for: .touchUpInside)
        dismissButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            pgRatingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            pgRatingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            runTimeLabel.topAnchor.constraint(equalTo: pgRatingLabel.bottomAnchor, constant: 8),
            runTimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            genreLabel.topAnchor.constraint(equalTo: runTimeLabel.bottomAnchor, constant: 8),
            genreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            statusLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            castCrewLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 16),
            castCrewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            castCrewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            directorLabel.topAnchor.constraint(equalTo: castCrewLabel.bottomAnchor, constant: 16),
            directorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            directorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            synopsisLabel.topAnchor.constraint(equalTo: directorLabel.bottomAnchor, constant: 16),
            synopsisLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            synopsisLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            languagesLabel.topAnchor.constraint(equalTo: synopsisLabel.bottomAnchor, constant: 16),
            languagesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            languagesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            trailerButton.topAnchor.constraint(equalTo: languagesLabel.bottomAnchor, constant: 16),
            trailerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            dismissButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func configure(with movieDetails: MovieDetails) {
        titleLabel.text = movieDetails.filmName
        pgRatingLabel.text = "PG Rating: \(movieDetails.PGRating)"
        runTimeLabel.text = "Runtime: \(movieDetails.runTime)"
        genreLabel.text = "Genre: \(movieDetails.filmGenre)"
        statusLabel.text = "Status: \(movieDetails.filmStatus)"
        castCrewLabel.text = "Cast & Crew: \(movieDetails.castCrew)"
        directorLabel.text = "Director: \(movieDetails.director)"
        synopsisLabel.text = "Synopsis: \(movieDetails.synopsis)"
        
        let languagesText = movieDetails.languages.map { lang in
            var details = "\(lang.language)"
            let formats = lang.filmFormats.joined(separator: ", ")
            if !formats.isEmpty {
                details += "\nFormats: \(formats)"
            }
            return details
        }.joined(separator: "\n")

        languagesLabel.text = "Languages:\n\(languagesText)"
        
        if let trailerLink = movieDetails.languages.first?.trailerLink {
            trailerButton.isHidden = false
            trailerButton.accessibilityHint = trailerLink
        } else {
            trailerButton.isHidden = true
        }
    }

    @objc private func trailerButtonTapped() {
        if let trailerLink = trailerButton.accessibilityHint, let url = URL(string: trailerLink) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }

    @objc private func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
}
