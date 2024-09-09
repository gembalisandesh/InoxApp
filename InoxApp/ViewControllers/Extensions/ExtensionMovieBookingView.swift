//
//  ExtensionMovieBookingView.swift
//  InoxApp
//
//  Created by Equipp on 09/09/24.
//

import Foundation
import UIKit

extension MovieBookingView {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case moviePicker:
            return movieNames.count
        case cinemaPicker:
            return cinemaNames.count
        case timePicker:
            return times.count
        case datePicker:
            return scheduleDays.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print("Picker view: \(pickerView), Row: \(row), Component: \(component)")
        switch pickerView {
        case moviePicker:
            
            return row < movieNames.count ? movieNames[row] : nil
        case cinemaPicker:
           
            return row < cinemaNames.count ? cinemaNames[row] : nil
        case timePicker:
           
            return row < times.count ? times[row] : nil
        case datePicker:
            
            return row < scheduleDays.count ? scheduleDays[row] : nil
        default:
            return nil
        }
    }

    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Selected row: \(row), Component: \(component)")
        
        switch pickerView {
        case moviePicker:
            if row < movieNames.count {
                print("Selected movie: \(movieNames[row])")
                selectedMovie = movieNames[row]
                movieTextField.text = selectedMovie
                delegate?.didSelectMovie(selectedMovie ?? "")
            }
        case cinemaPicker:
            if row < cinemaNames.count {
                print("Selected cinema: \(cinemaNames[row])")
                selectedCinema = cinemaNames[row]
                cinemaTextField.text = selectedCinema
                delegate?.didSelectCinema(selectedCinema ?? "")
            }
        case timePicker:
            if row < times.count {
                print("Selected time: \(times[row])")
                selectedTime = times[row]
                timeTextField.text = selectedTime
                delegate?.didSelectTime(selectedTime ?? "")
            }
        case datePicker:
            if row < scheduleDays.count {
                print("Selected date: \(scheduleDays[row])")
                selectedDate = scheduleDays[row]
                dateTextField.text = selectedDate
                delegate?.didSelectDate(selectedDate ?? "")
            }
        default:
            break
        }
    }
}

extension UICollectionViewCell {
    func findViewController() -> UIViewController? {
        var viewResponder: UIResponder? = self
        while let responder = viewResponder {
            if let viewController = responder as? UIViewController {
                return viewController
            }
            viewResponder = responder.next
        }
        return nil
    }
}

extension UIImageView {
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL string.")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Failed to load image: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("No data or failed to create image.")
                return
            }
            
            DispatchQueue.main.async {
                self?.image = image
            }
        }.resume()
    }
}
