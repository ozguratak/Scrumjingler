//
//  Constants.swift
//  Scrumdinger (iOS)
//
//  Created by ozgur.atak on 28.03.2023.
//

import Foundation
public var userID: String = ""
var storedScrums: [DailyScrum] = []
public var currentUserInformations: [String : Any] = [:]
//MARK: General constants
public var imageStorageLink = ""

//MARK: Keys for Firebase

public let keyUserPath = "User"
// Keys for User
public var currentEmail = ""
public let keyUserImages = "imageLink"
public let keyUserID = "unknownUser"
public let keyCurrentUser = "currentUser"
public let keyUserEmail = "Mail Adress"
public let keyUserName = "Name"
public let keyUserLastName = "Last Name"
public let keyUserOnBoard = "onBoard"
public let keyUserScrumsTranscripts = "Scrum's Transcripts"
public let keyUserScrums = "Daily Scrums"

//Keys for Scrum

public let keyScrumID = "ID"
public let keyScrumTitle = "Title"
public let keyScrumTheme = "Theme"
public let keyScrumHistory = "History"
public let keyScrumLength = "Length"
public let keyScrumAttendees = "Attendees"
