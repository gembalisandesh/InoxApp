//
//  MovieBookingView.swift
//  InoxApp
//
//  Created by Equipp on 09/09/24.
//

import UIKit

class MovieBookingView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {

    weak var delegate: MovieBookingViewDelegate?
    
    let segmentedControl = UISegmentedControl(items: ["Movie", "Theater"])
    let movieTextField = UITextField()
    let cinemaTextField = UITextField()
    let dateTextField = UITextField()
    let timeTextField = UITextField()
    
    let moviePicker = UIPickerView()
    let cinemaPicker = UIPickerView()
    let timePicker = UIPickerView()
    let datePicker = UIPickerView()
    
    var movieNames: [String] = []
    var cinemaNames: [String] = []
    var times: [String] = []
    var scheduleDays: [String] = []
    
    var selectedMovie: String?
    var selectedCinema: String?
    var selectedDate: String?
    var selectedTime: String?
    
    private var isMovieSelected: Bool = true

    private let stackView = UIStackView()
    private let buttonStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setMovieNames(_ names: [String]) {
        self.movieNames = names
        moviePicker.reloadAllComponents()
    }
    
    func setCinemaNames(_ names: [String]) {
        self.cinemaNames = names
        cinemaPicker.reloadAllComponents()
    }
    
    func setTimes(_ times: [String]) {
        self.times = times
        timePicker.reloadAllComponents()
    }
    
    func setScheduleDays(_ days: [String]) {
        self.scheduleDays = days
        datePicker.reloadAllComponents()
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        moviePicker.delegate = self
        moviePicker.dataSource = self
        cinemaPicker.delegate = self
        cinemaPicker.dataSource = self
        timePicker.delegate = self
        timePicker.dataSource = self
        datePicker.delegate = self
        datePicker.dataSource = self
        
        setupSegmentedControl()
        setupTextFields()
        setupStackView()
        setupButtons()
        layoutUI(isMovieSelected: true)
    }
    
    private func setupSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    private func setupTextFields() {
        configureTextField(movieTextField, placeholder: "Select Movie", inputView: moviePicker)
        configureTextField(cinemaTextField, placeholder: "Select Cinema", inputView: cinemaPicker)
        configureTextField(dateTextField, placeholder: "Select Date", inputView: datePicker)
        configureTextField(timeTextField, placeholder: "Select Time", inputView: timePicker)
        
        let toolBar = createPickerToolBar()
        movieTextField.inputAccessoryView = toolBar
        cinemaTextField.inputAccessoryView = toolBar
        dateTextField.inputAccessoryView = toolBar
        timeTextField.inputAccessoryView = toolBar
    }
    
    private func configureTextField(_ textField: UITextField, placeholder: String, inputView: UIView) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.inputView = inputView
        textField.textAlignment = .center
    }
    
    private func createPickerToolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        toolBar.setItems([doneButton], animated: true)
        return toolBar
    }
    
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    private func setupButtons() {
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 20
        buttonStackView.distribution = .fillEqually
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let searchButton = UIButton(type: .system)
        searchButton.setTitle("Search", for: .normal)
        searchButton.addTarget(self, action: #selector(searchPressed), for: .touchUpInside)
        
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        
        buttonStackView.addArrangedSubview(searchButton)
        buttonStackView.addArrangedSubview(cancelButton)
        
        addSubview(buttonStackView)
        
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    private func layoutUI(isMovieSelected: Bool) {
        stackView.arrangedSubviews.forEach { stackView.removeArrangedSubview($0); $0.removeFromSuperview() }
        
        if isMovieSelected {
            stackView.addArrangedSubview(movieTextField)
            stackView.addArrangedSubview(dateTextField)
            stackView.addArrangedSubview(cinemaTextField)
        } else {
            stackView.addArrangedSubview(cinemaTextField)
            stackView.addArrangedSubview(dateTextField)
            stackView.addArrangedSubview(movieTextField)
        }
        
        stackView.addArrangedSubview(timeTextField)
        
        resetFields()
    }
    
    func resetFields() {
        movieTextField.text = selectedMovie
        cinemaTextField.text = selectedCinema
        dateTextField.text = selectedDate
        timeTextField.text = selectedTime
        
        moviePicker.selectRow(movieNames.firstIndex(of: selectedMovie ?? "") ?? 0, inComponent: 0, animated: false)
        cinemaPicker.selectRow(cinemaNames.firstIndex(of: selectedCinema ?? "") ?? 0, inComponent: 0, animated: false)
        timePicker.selectRow(times.firstIndex(of: selectedTime ?? "") ?? 0, inComponent: 0, animated: false)
        datePicker.selectRow(scheduleDays.firstIndex(of: selectedDate ?? "") ?? 0, inComponent: 0, animated: false)
    }
    func reloadView() {
        // Reload all pickers
        moviePicker.reloadAllComponents()
        cinemaPicker.reloadAllComponents()
        timePicker.reloadAllComponents()
        datePicker.reloadAllComponents()
        
        // Reset selections
        resetFields()
    }


    
    private func resetAllValues() {
        
        selectedMovie = nil
        selectedCinema = nil
        selectedDate = nil
        selectedTime = nil
        
        
        movieTextField.text = nil
        cinemaTextField.text = nil
        dateTextField.text = nil
        timeTextField.text = nil
        
        
        moviePicker.selectRow(0, inComponent: 0, animated: false)
        cinemaPicker.selectRow(0, inComponent: 0, animated: false)
        timePicker.selectRow(0, inComponent: 0, animated: false)
        datePicker.selectRow(0, inComponent: 0, animated: false)
        
        
        delegate?.didSelectMovie("")
        delegate?.didSelectCinema("")
        delegate?.didSelectDate("")
        delegate?.didSelectTime("")
    }
    
    @objc private func segmentChanged() {
        isMovieSelected = segmentedControl.selectedSegmentIndex == 0
        layoutUI(isMovieSelected: isMovieSelected)
        resetAllValues() 
        delegate?.didChangeSegment(isMovieSelected: isMovieSelected) 
    }
    
    @objc private func donePressed() {
        endEditing(true)
    }
    
    @objc private func searchPressed() {
        delegate?.searchButtonPressed(selectedMovie: selectedMovie, selectedCinema: selectedCinema, selectedDate: selectedDate, selectedTime: selectedTime)
    }
    
    @objc private func cancelPressed() {
        delegate?.cancelButtonPressed()
    }
}
