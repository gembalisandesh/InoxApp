//
//  Model.swift
//  InoxApp
//
//  Created by Equipp on 08/09/24.
//

import Foundation

struct MovieData: Codable {
    let movieDetails: [MovieDetails]
    let schedules: [Schedule]
    let theatres: [Theatre]
}

struct MovieDetails: Codable {
    let filmcommonId: String
    let filmName: String
    let PGRating: String
    let runTime: String
    let filmGenre: String
    let filmStatus: String
    let castCrew: String
    let director: String
    let synopsis: String
    let movieIds: [[String]]
    let languages: [Language]
}

struct Language: Codable {
    let language: String
    let potraitPoster: String
    let landscapePoster: String
    let filmFormats: [String]
    let PosMovieId: [String]
    let trailerLink: String
    let releaseDate: String

    enum CodingKeys: String, CodingKey {
        case language
        case potraitPoster
        case landscapePoster
        case filmFormats
        case PosMovieId
        case trailerLink
        case releaseDate
    }
}


struct Schedule: Codable {
    let day: String
    var showTimings: [[String?]]
    
    init(day: String, showTimings: [[String?]]) {
        self.day = day
        self.showTimings = showTimings
    }
}

struct ShowTiming {
    let bookingID: String?
    let movieID: String?
    let showTime: String?
    let showDate: String?
    let showStatus: String?
    let seatsAvailable: String?
    let filmFormat: String?
    let screenName: String?
    let additionalInfo: String?
    let theatreID: String?

    init?(from array: [String?]) {
        guard array.count >= 9 else { return nil }

        self.bookingID = array[0]
        self.movieID = array[1]

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = dateFormatter.date(from: array[2] ?? "") {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            self.showTime = dateFormatter.string(from: date)

            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.showDate = dateFormatter.string(from: date)
        } else {
            self.showTime = nil
            self.showDate = nil
        }

        self.showStatus = array[3]
        self.seatsAvailable = array[4]
        self.filmFormat = array[5]
        self.screenName = array[6]
        self.additionalInfo = array[7]
        self.theatreID = array[8]
    }

    func toStringArray() -> [String?] {
        return [bookingID, movieID, showTime, showDate, showStatus, seatsAvailable, filmFormat, screenName, additionalInfo, theatreID]
    }
}

struct Theatre: Codable {
    let id: String
    let posCityID: String
    let posTheatreID: String
    let theatreName: String
    let address1: String
    let address2: String
    let lat: String
    let long: String
    let isOnline: Bool
    let imagesArr: [String]
    let galleryArr: [String]

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case posCityID = "PosCityID"
        case posTheatreID = "PosTheatreID"
        case theatreName = "TheatreName"
        case address1 = "Address1"
        case address2 = "Address2"
        case lat = "Lat"
        case long = "Long"
        case isOnline = "IsOnline"
        case imagesArr = "ImagesArr"
        case galleryArr = "GalleryArr"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        posCityID = try container.decode(String.self, forKey: .posCityID)
        posTheatreID = try container.decode(String.self, forKey: .posTheatreID)
        theatreName = try container.decode(String.self, forKey: .theatreName)
        address1 = try container.decode(String.self, forKey: .address1)
        address2 = try container.decode(String.self, forKey: .address2)
        lat = try container.decode(String.self, forKey: .lat)
        long = try container.decode(String.self, forKey: .long)
        
        let isOnlineString = try container.decode(String.self, forKey: .isOnline)
        isOnline = (isOnlineString.lowercased() == "true")
        
        imagesArr = try container.decode([String].self, forKey: .imagesArr)
        galleryArr = try container.decode([String].self, forKey: .galleryArr)
    }
}

