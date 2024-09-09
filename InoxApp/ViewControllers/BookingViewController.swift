//
//  BookingViewController.swift
//  InoxApp
//
//  Created by Equipp on 08/09/24.
//

import UIKit
import CoreLocation

class BookingViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private let movieDetails: MovieDetails
    private let lat = "26.230134"
    private let long = "50.552661"
    var showTimings: [String] = []
    var availableDates: [String] = []
    var showScreens: [String] = []
    private let geocoder = CLGeocoder()
    
    var selectedDate: String? {
        didSet {
            fetchShowTimings(forDate: selectedDate ?? "")
        }
    }
    
    var selectedTime: String? {
        didSet {
            fetchShowScreens()
        }
    }
    var selectedShowScreen: String?
    
    let currentLatitude = UserDefaults.standard.double(forKey: "currentLatitude")
    let currentLongitude = UserDefaults.standard.double(forKey: "currentLongitude")
    
    // UI Elements
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    private let pgRatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    private let castLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    private let datePickerTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.text = "Select Date"
        return label
    }()
    
    private let timePickerTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.text = "Select Time"
        return label
    }()
    
    private let theaterDetailsTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.text = "Theater Details"
        return label
    }()
    
    let datePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.backgroundColor = .white
        return pickerView
    }()
    
    let timePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.backgroundColor = .white
        return pickerView
    }()
    
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    private let theaterNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        
        return label
    }()
    
    private let theaterAddressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    private let showScreenTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.text = "Select ShowScreen"
        return label
    }()
    
    let showScreenPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.backgroundColor = .white
        return pickerView
    }()
    
    
    
    
    private let bookButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Confirm Booking", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
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
        setupPickers()
        setupShowScreenPicker()
        fetchTheaterAddress()
        fetchAvailableDates()
        fetchShowScreens()
    }
    
    
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        view.addSubview(bookButton)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(genreLabel)
        contentView.addSubview(pgRatingLabel)
        contentView.addSubview(castLabel)
        contentView.addSubview(datePickerTitleLabel)
        contentView.addSubview(datePickerView)
        contentView.addSubview(theaterDetailsTitleLabel)
        contentView.addSubview(theaterNameLabel)
        contentView.addSubview(distanceLabel)
        contentView.addSubview(theaterAddressLabel)
        contentView.addSubview(timePickerTitleLabel)
        contentView.addSubview(timePickerView)
        contentView.addSubview(showScreenTitleLabel)
        contentView.addSubview(showScreenPickerView)
        
        stylePicker(datePickerView)
        stylePicker(timePickerView)
        stylePicker(showScreenPickerView)
    }
    
    private func stylePicker(_ pickerView: UIPickerView) {
        pickerView.layer.borderColor = UIColor.lightGray.cgColor
        pickerView.layer.borderWidth = 1
        pickerView.layer.cornerRadius = 10
        pickerView.backgroundColor = .white
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bookButton.topAnchor, constant: -16),
            
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
           
            genreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            genreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            genreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            
            pgRatingLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 8),
            pgRatingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            pgRatingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            
            castLabel.topAnchor.constraint(equalTo: pgRatingLabel.bottomAnchor, constant: 8),
            castLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            castLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            
            datePickerTitleLabel.topAnchor.constraint(equalTo: castLabel.bottomAnchor, constant: 16),
            datePickerTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            
            datePickerView.topAnchor.constraint(equalTo: datePickerTitleLabel.bottomAnchor, constant: 8),
            datePickerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            datePickerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            datePickerView.heightAnchor.constraint(equalToConstant: 150),
            
            
            theaterDetailsTitleLabel.topAnchor.constraint(equalTo: datePickerView.bottomAnchor, constant: 16),
            theaterDetailsTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            
            theaterNameLabel.topAnchor.constraint(equalTo: theaterDetailsTitleLabel.bottomAnchor, constant: 8),
            theaterNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            theaterNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
           
            distanceLabel.topAnchor.constraint(equalTo: theaterNameLabel.bottomAnchor, constant: 8),
            distanceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            distanceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            
            theaterAddressLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 8),
            theaterAddressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            theaterAddressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            
            timePickerTitleLabel.topAnchor.constraint(equalTo: theaterAddressLabel.bottomAnchor, constant: 16),
            timePickerTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            
            timePickerView.topAnchor.constraint(equalTo: timePickerTitleLabel.bottomAnchor, constant: 8),
            timePickerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            timePickerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            timePickerView.heightAnchor.constraint(equalToConstant: 150),
            
            
            showScreenTitleLabel.topAnchor.constraint(equalTo: timePickerView.bottomAnchor, constant: 16),
            showScreenTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            
            showScreenPickerView.topAnchor.constraint(equalTo: showScreenTitleLabel.bottomAnchor, constant: 8),
            showScreenPickerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            showScreenPickerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            showScreenPickerView.heightAnchor.constraint(equalToConstant: 150),
            
           
            contentView.bottomAnchor.constraint(equalTo: showScreenPickerView.bottomAnchor, constant: 16),
            
            
            bookButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            bookButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bookButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bookButton.heightAnchor.constraint(equalToConstant: 44)
            
        ])
        
    }
    
    
    private func configure(with movieDetails: MovieDetails) {
        titleLabel.text = movieDetails.filmName
        genreLabel.text = "Genre: \(movieDetails.filmGenre)"
        pgRatingLabel.text = "PG Rating: \(movieDetails.PGRating)"
        castLabel.text = "Cast: \(movieDetails.castCrew)"
        theaterNameLabel.text = "EPIX CINEMA, DANA MALL"
        
        if !availableDates.isEmpty {
            selectedDate = availableDates[0]
            datePickerView.selectRow(0, inComponent: 0, animated: false)
        }
        
        if !showTimings.isEmpty {
            selectedTime = showTimings[0]
            timePickerView.selectRow(0, inComponent: 0, animated: false)
        }
    }
    
    private func setupPickers() {
        datePickerView.dataSource = self
        datePickerView.delegate = self
        timePickerView.dataSource = self
        timePickerView.delegate = self
    }
    
    
    private func fetchTheaterAddress() {
        guard let latitude = Double(lat), let longitude = Double(long) else { return }
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching address: \(error.localizedDescription)")
                return
            }
            
            guard let placemark = placemarks?.first else {
                print("No address found")
                return
            }
            
            var addressString = ""
            if let name = placemark.name {
                addressString += name + ", "
            }
            if let locality = placemark.locality {
                addressString += locality + ", "
            }
            if let administrativeArea = placemark.administrativeArea {
                addressString += administrativeArea + ", "
            }
            if let country = placemark.country {
                addressString += country
            }
            
            self.theaterAddressLabel.text = addressString
            
            let distance = self.calculateDistanceInKilometers(lat1: Double(self.lat) ?? 0,
                                                              lon1: Double(self.long) ?? 0,
                                                              lat2: self.currentLatitude,
                                                              lon2: self.currentLongitude)
            self.distanceLabel.text = "\(distance)"
        }
    }
    
    private func fetchAvailableDates() {
        let movieID = movieDetails.filmcommonId
        availableDates = DataManager.shared.fetchAllDaysByMovieID(movieID: movieID)
        datePickerView.reloadAllComponents()
        if !availableDates.isEmpty {
            selectedDate = availableDates[0]
            datePickerView.selectRow(0, inComponent: 0, animated: false)
        }
    }
    
    private func fetchShowTimings(forDate date: String) {
        let movieName = movieDetails.filmName
        if let timings = DataManager.shared.fetchShowtimes(byMovieName: movieName, forScheduleDay: date) {
            showTimings = timings
            timePickerView.reloadAllComponents()
            if !showTimings.isEmpty {
                selectedTime = showTimings[0]
                timePickerView.selectRow(0, inComponent: 0, animated: false)
            }
        }
    }
    
    private func fetchShowScreens() {
        guard let date = selectedDate, let time = selectedTime else { return }
        showScreens = DataManager.shared.fetchScreenNames(movieID: movieDetails.filmcommonId, showDate: date, showTime: time)
        showScreenPickerView.reloadAllComponents()
    }
    private func setupShowScreenPicker() {
        showScreenPickerView.dataSource = self
        showScreenPickerView.delegate = self
    }
    
    
    func calculateDistanceInKilometers(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> String {
        let location1 = CLLocation(latitude: lat1, longitude: lon1)
        let location2 = CLLocation(latitude: lat2, longitude: lon2)
        
        
        let distanceInMeters = location1.distance(from: location2)
        
        
        let distanceInKilometers = distanceInMeters / 1000
        return String(format: "%.2f km", distanceInKilometers)
    }
    
}



extension BookingViewController {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == showScreenPickerView {
            return showScreens.count
        } else if pickerView == datePickerView {
            return availableDates.count
        } else {
            return showTimings.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == showScreenPickerView {
            return showScreens[row]
        } else if pickerView == datePickerView {
            return availableDates[row]
        } else {
            return showTimings[row]
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == datePickerView {
            selectedDate = availableDates[row]
            fetchShowTimings(forDate: selectedDate ?? "")
        } else if pickerView == timePickerView {
            selectedTime = showTimings[row]
        } else if pickerView == showScreenPickerView {
            selectedShowScreen = showScreens[row]
        }
    }
    
}


