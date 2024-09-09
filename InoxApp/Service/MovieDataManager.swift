//
//  MovieDataManager.swift
//  InoxApp
//
//  Created by Equipp on 08/09/24.
//

import Foundation
import UIKit

class DataManager {
    static let shared = DataManager()
    
    private init() {}
    
    func fetchCinemaData(completion: @escaping (Result<MovieData, Error>) -> Void) {
        guard let url = Bundle.main.url(forResource: "jsonformatter", withExtension: "json") else {
            completion(.failure(DataManagerError.fileNotFound))
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let movieData = try decoder.decode(MovieData.self, from: data)
            
            let processedSchedules = movieData.schedules.map { schedule in
                let processedShowTimings = schedule.showTimings.compactMap { ShowTiming(from: $0) }
                return (day: schedule.day, showTimings: processedShowTimings)
            }
            
            let processedMovieData = MovieData(
                movieDetails: movieData.movieDetails,
                schedules: processedSchedules.map { Schedule(day: $0.day, showTimings: $0.showTimings.map { $0.toStringArray() }) },
                theatres: movieData.theatres
            )
            DispatchQueue.main.async {
                completion(.success(processedMovieData))
            }
            
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
            
        }
    }
    
    func fetchMovies(byName selectedMovie: String) -> [MovieDetails]? {
        guard let url = Bundle.main.url(forResource: "jsonformatter", withExtension: "json") else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let movieData = try decoder.decode(MovieData.self, from: data)
            
            let matchingMovies: [MovieDetails]
            if let movieID = fetchMovieID(byMovieName: selectedMovie) {
                matchingMovies = movieData.movieDetails.filter { $0.filmcommonId == movieID }
            } else {
                matchingMovies = movieData.movieDetails.filter { $0.filmName == selectedMovie }
            }
            
            return matchingMovies.isEmpty ? nil : matchingMovies
        } catch {
            print("Failed to fetch movies: \(error)")
            return nil
        }
    }
    
    func fetchMovieID(byMovieName movieName: String) -> String? {
        guard let url = Bundle.main.url(forResource: "jsonformatter", withExtension: "json") else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let movieData = try decoder.decode(MovieData.self, from: data)
            
            let matchingMovie = movieData.movieDetails.first(where: { $0.filmName == movieName })
            return matchingMovie?.filmcommonId
        } catch {
            return nil
        }
    }
    
    func fetchMovieShowDays(byMovieName movieName: String) -> [String]? {
        guard let url = Bundle.main.url(forResource: "jsonformatter", withExtension: "json") else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let movieData = try decoder.decode(MovieData.self, from: data)
            
            let matchingMovie: MovieDetails?
            if let movieID = fetchMovieID(byMovieName: movieName) {
                matchingMovie = movieData.movieDetails.first(where: { $0.filmcommonId == movieID })
            } else {
                matchingMovie = movieData.movieDetails.first(where: { $0.filmName == movieName })
            }
            
            if let matchingMovie = matchingMovie {
                let showDays = movieData.schedules.filter { schedule in
                    schedule.showTimings.contains(where: { showTiming in
                        showTiming[1] == matchingMovie.filmcommonId
                    })
                }.map { $0.day }
                return showDays
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    func fetchShowtimes(byMovieName movieName: String, forScheduleDay scheduleDay: String) -> [String]? {
        guard let url = Bundle.main.url(forResource: "jsonformatter", withExtension: "json") else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let movieData = try decoder.decode(MovieData.self, from: data)
            
            guard let movieID = fetchMovieID(byMovieName: movieName) else {
                return nil
            }
            
            let matchingSchedules = movieData.schedules.filter { $0.day == scheduleDay }
            var showtimes = [String]()
            
            for schedule in matchingSchedules {
                for showTiming in schedule.showTimings {
                    guard let showTimingObject = ShowTiming(from: showTiming) else {
                        continue
                    }
                    
                    if showTimingObject.movieID == movieID, let showTime = showTimingObject.showTime {
                        showtimes.append(showTime)
                    }
                }
            }
            
            return showtimes.isEmpty ? nil : showtimes
        } catch {
            return nil
        }
    }
    
    func fetchAllUniqueDays() -> [String] {
        guard let url = Bundle.main.url(forResource: "jsonformatter", withExtension: "json") else {
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let movieData = try decoder.decode(MovieData.self, from: data)
            
            let uniqueDays = Set(movieData.schedules.map { $0.day })
            return Array(uniqueDays).sorted()
        } catch {
            return []
        }
    }
    
    func fetchAllMovieNames() -> [String] {
        guard let url = Bundle.main.url(forResource: "jsonformatter", withExtension: "json") else {
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let movieData = try decoder.decode(MovieData.self, from: data)
            
            let movieNames = movieData.movieDetails.map { $0.filmName }
            return movieNames
        } catch {
            return []
        }
    }
    
    func fetchAllDaysByMovieID(movieID: String) -> [String] {
        guard let url = Bundle.main.url(forResource: "jsonformatter", withExtension: "json") else {
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let movieData = try decoder.decode(MovieData.self, from: data)
            
            var daysWithMovie: [String] = []
            
            for schedule in movieData.schedules {
                for showTiming in schedule.showTimings {
                    if let showTimingObject = ShowTiming(from: showTiming),
                       let showMovieID = showTimingObject.movieID, showMovieID == movieID {
                        daysWithMovie.append(schedule.day)
                        break
                    }
                }
            }
            
            return daysWithMovie
        } catch {
            return []
        }
    }
    func fetchScreenNames(movieID: String, showDate: String, showTime: String) -> [String] {
        guard let url = Bundle.main.url(forResource: "jsonformatter", withExtension: "json") else {
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let movieData = try decoder.decode(MovieData.self, from: data)
            
            var screenNames: [String] = []
            
            for schedule in movieData.schedules {
                for showTiming in schedule.showTimings {
                    if let showTimingObject = ShowTiming(from: showTiming),
                       showTimingObject.movieID == movieID,
                       showTimingObject.showDate == showDate,
                       showTimingObject.showTime == showTime {
                        if let screenName = showTimingObject.screenName {
                            screenNames.append(screenName)
                        }
                    }
                }
            }
            
            return screenNames
        } catch {
            print("Failed to fetch screen names: \(error)")
            return []
        }
    }
    func fetchMovieNamesBySceduleDay(forScheduleDay scheduleDay: String) -> [String]? {
        guard let url = Bundle.main.url(forResource: "jsonformatter", withExtension: "json") else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let movieData = try decoder.decode(MovieData.self, from: data)
            let movieIDs = movieData.schedules
                .first(where: { $0.day == scheduleDay })?
                .showTimings
                .compactMap { ShowTiming(from: $0)?.movieID }
           
            let movieNames = movieData.movieDetails
                .filter { movieIDs?.contains($0.filmcommonId) ?? false }
                .map { $0.filmName }
            
            return movieNames.isEmpty ? nil : movieNames
        } catch {
            print("Failed to fetch movie names for schedule day: \(error)")
            return nil
        }
    }

}

enum DataManagerError: Error {
    case fileNotFound
    case movieNotFound(movieName: String)
}
