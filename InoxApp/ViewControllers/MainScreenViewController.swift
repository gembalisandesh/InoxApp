//
//  MainScreenViewController.swift
//  InoxApp
//
//  Created by Equipp on 08/09/24.
//


import UIKit
import CoreLocation

class MainScreenViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate, MovieBookingViewDelegate {
    private var movieData: MovieData?
    private var movies: [MovieDetails] = []
    private var cinemas : [Theatre] = []
    private let locationManager = CLLocationManager()
    private var longitude: Double?
    private var latitude: Double?
    private let geocoder = CLGeocoder()
    private var selectedMovie: MovieDetails?
    var selectedMoviePicker: String?
    var selectedCinemaPicker: String?
    var selectedTimePicker: String?
    var selectedDatePicker: String?
    private var isMovieSelected: Bool = true
    
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private let movieBookingView: MovieBookingView = {
        let view = MovieBookingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.text = "You are here:"
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        label.textColor = .gray
        label.numberOfLines = 1
        return label
    }()
    
    private let quickBookLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "QUICK BOOK"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 24, weight: .bold)
        ]
        navigationController?.navigationBar.titleTextAttributes = attributes
        
        title = "INOX APP"
        view.backgroundColor = .white
        
        view.addSubview(quickBookLabel)
        view.addSubview(movieBookingView)
        view.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        movieBookingView.delegate = self
        movieBookingView.movieNames = DataManager.shared.fetchAllMovieNames()
        
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCell")
        
        setupConstraints()
        
        fetchMovieData()
        
        checkLocationAuthorizationStatus()
        
        setupNavigationBar()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            quickBookLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            quickBookLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            quickBookLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            
            movieBookingView.topAnchor.constraint(equalTo: quickBookLabel.bottomAnchor, constant: 10),
            movieBookingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieBookingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieBookingView.heightAnchor.constraint(equalToConstant: 300),
            
            
            collectionView.topAnchor.constraint(equalTo: movieBookingView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: containerView)
        
        containerView.addSubview(locationLabel)
        containerView.addSubview(addressLabel)
        
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            addressLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 2),
            addressLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            addressLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            addressLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    private func fetchMovieData() {
        DataManager.shared.fetchCinemaData { [weak self] result in
            guard let self = self else {
                print("Self is nil")
                return
            }
            
            switch result {
            case .success(let movieData):
                self.movieData = movieData
                self.movies = movieData.movieDetails
                self.collectionView.reloadData()
            case .failure(let error):
                print("Failed to fetch movie data: \(error)")
            }
        }
    }
    
    private func checkLocationAuthorizationStatus() {
        
        DispatchQueue.main.async {
            if CLLocationManager.locationServicesEnabled() {
                DispatchQueue.global(qos: .background).async {
                    self.locationManager.delegate = self
                    self.locationManager.requestWhenInUseAuthorization()
                }
            } else {
                print("Location services not enabled")
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async {
            switch manager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                self.locationManager.startUpdatingLocation()
            case .denied, .restricted:
                print("Location services not authorized")
            default:
                print("Unknown location authorization status")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self, let location = locations.last else { return }
            
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
            
            UserDefaults.standard.set(self.latitude, forKey: "currentLatitude")
            UserDefaults.standard.set(self.longitude, forKey: "currentLongitude")
            UserDefaults.standard.synchronize()
            
            print("Location updated: \(self.latitude ?? 0), \(self.longitude ?? 0)")
            self.reverseGeocodeLocation(location)
        }
    }
    
    
    private func reverseGeocodeLocation(_ location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                print("Error in reverse geocoding: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.addressLabel.text = "\(self?.latitude ?? 0), \(self?.longitude ?? 0)"
                }
                return
            }
            
            if let placemark = placemarks?.first, let locality = placemark.locality {
                let limitedLocality = String(locality.prefix(15))
                print("Geocoded locality: \(limitedLocality)")
                DispatchQueue.main.async {
                    self?.addressLabel.text = limitedLocality
                }
            } else {
                print("No locality found")
                DispatchQueue.main.async {
                    self?.addressLabel.text = "\(self?.latitude ?? 0), \(self?.longitude ?? 0)"
                }
            }
        }
    }
    func searchButtonPressed(selectedMovie: String?, selectedCinema: String?, selectedDate: String?, selectedTime: String?) {
        if let selectedMovie = selectedMovie,
           let selectedDate = selectedDate,
           let selectedTime = selectedTime {
            if let movie = DataManager.shared.fetchMovies(byName: selectedMovie)?.first {
                let bookingVC = BookingViewController(movieDetails: movie)
                
                bookingVC.selectedDate = selectedDate
                bookingVC.selectedTime = selectedTime
                
                let showScreens = DataManager.shared.fetchScreenNames(movieID: movie.filmcommonId, showDate: selectedDate, showTime: selectedTime)
                bookingVC.showScreens = showScreens
                
                if let firstShowScreen = showScreens.first {
                    bookingVC.selectedShowScreen = firstShowScreen
                }
                
                DispatchQueue.main.async {
                    bookingVC.datePickerView.selectRow(bookingVC.availableDates.firstIndex(of: selectedDate) ?? 0, inComponent: 0, animated: false)
                    bookingVC.timePickerView.selectRow(bookingVC.showTimings.firstIndex(of: selectedTime) ?? 0, inComponent: 0, animated: false)
                    bookingVC.showScreenPickerView.selectRow(0, inComponent: 0, animated: false)
                    
                    bookingVC.datePickerView.reloadAllComponents()
                    bookingVC.timePickerView.reloadAllComponents()
                    bookingVC.showScreenPickerView.reloadAllComponents()
                }
                
                navigationController?.pushViewController(bookingVC, animated: true)
            }
        } else if let selectedMovie = selectedMovie {
            movies = DataManager.shared.fetchMovies(byName: selectedMovie) ?? []
            collectionView.reloadData()
        } else {
            fetchMovieData()
            collectionView.reloadData()
        }
    }
    
    
    func cancelButtonPressed() {
        resetView()
        movieBookingView.resetFields()
        movieBookingView.reloadView()
    }
    
    private func resetView() {
        selectedMoviePicker = nil
        selectedCinemaPicker = nil
        selectedDatePicker = nil
        selectedTimePicker = nil
        
        fetchMovieData()
        collectionView.reloadData()
    }
    
    func didSelectMovie(_ movie: String) {
        selectedMoviePicker = movie
        print("Selected Movie: \(selectedMoviePicker ?? "None")")
        if isMovieSelected {
            if let selectedMoviePicker = selectedMoviePicker {
                
                if let showDays = DataManager.shared.fetchMovieShowDays(byMovieName: selectedMoviePicker) {
                    
                    movieBookingView.scheduleDays = showDays
                    print("Show days for \(selectedMoviePicker): \(movieBookingView.scheduleDays)")
                    
                    
                } else {
                    print("No show days found for \(selectedMoviePicker)")
                    
                    movieBookingView.scheduleDays = []
                    
                }
            }
        } else {
            if let selectedDatePicker = selectedDatePicker , let selectedMoviePicker = selectedMoviePicker {
                if let times = DataManager.shared.fetchShowtimes(byMovieName: selectedMoviePicker, forScheduleDay: selectedDatePicker) {
                    movieBookingView.times = times
                    movieBookingView.timePicker.reloadAllComponents()
                    
                    
                    movieBookingView.timeTextField.text = nil
                    movieBookingView.selectedTime = nil
                }
            }
        }
        
    }
    
    func didSelectCinema(_ cinema: String) {
        selectedCinemaPicker = cinema
        print("Selected Cinema: \(selectedCinemaPicker ?? "None")")
        
        if isMovieSelected {
            if let selectedDatePicker = selectedDatePicker , let selectedMoviePicker = selectedMoviePicker {
                if let times = DataManager.shared.fetchShowtimes(byMovieName: selectedMoviePicker, forScheduleDay: selectedDatePicker) {
                    movieBookingView.times = times
                    movieBookingView.timePicker.reloadAllComponents()
                    
                    movieBookingView.timeTextField.text = nil
                    movieBookingView.selectedTime = nil
                }
            }
        } else {
            movieBookingView.scheduleDays = DataManager.shared.fetchAllUniqueDays()
            
        }
        
    }
    
    func didSelectTime(_ time: String) {
        selectedTimePicker = time
        print("Selected time : \(selectedTimePicker ?? "None")")
        
    }
    
    func didSelectDate(_ date: String) {
        selectedDatePicker = date
        print("Selected Date: \(selectedDatePicker ?? "None")")
        if isMovieSelected {
            movieBookingView.cinemaNames = ["EPIX CINEMA, DANA MALL"]
            if let selectedDatePicker = selectedDatePicker {
                if let movies = DataManager.shared.fetchMovieNamesBySceduleDay(forScheduleDay: selectedDatePicker) {
                    movieBookingView.movieNames = movies
                }
            }
            
        } else {
            if let selectedDatePicker = selectedDatePicker , let selectedMoviePicker = selectedMoviePicker {
                if let times = DataManager.shared.fetchShowtimes(byMovieName: selectedMoviePicker, forScheduleDay: selectedDatePicker) {
                    movieBookingView.times = times
                    movieBookingView.timePicker.reloadAllComponents()
                    
                    
                    movieBookingView.timeTextField.text = nil
                    movieBookingView.selectedTime = nil
                }
            }
        }
        
        
        
        
        
    }
    
    func didChangeSegment(isMovieSelected: Bool) {
        
        self.isMovieSelected = isMovieSelected
        
        if isMovieSelected {
            print("Movie segment selected")
            movieBookingView.movieNames = DataManager.shared.fetchAllMovieNames()
            movieBookingView.cinemaNames = ["EPIX CINEMA, DANA MALL"]
            resetView()
        } else {
            print("Theater segment selected")
            
            movieBookingView.cinemaNames = ["EPIX CINEMA, DANA MALL"]
            resetView()
            
        }
        
    }
    
}

extension MainScreenViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCollectionViewCell
        let movie = movies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 30) / 2
        return CGSize(width: width, height: 200)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMovie = movies[indexPath.row]
        
        print("Selected movie: \(selectedMovie?.filmName ?? "Unknown")")
        
    }
}
