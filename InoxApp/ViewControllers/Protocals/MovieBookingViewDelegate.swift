//
//  MovieBookingViewDelegate.swift
//  InoxApp
//
//  Created by Equipp on 09/09/24.
//

import Foundation

protocol MovieBookingViewDelegate: AnyObject {
    func searchButtonPressed(selectedMovie: String?, selectedCinema: String?, selectedDate: String?, selectedTime: String?)
    func cancelButtonPressed()
    func didSelectMovie(_ movie: String)
    func didSelectCinema(_ cinema: String)
    func didSelectTime(_ time: String)
    func didSelectDate(_ date: String)
    func didChangeSegment(isMovieSelected: Bool) 
}
