//
//  APIs.swift
//  SCMP Project
//
//  Created by Anson Wong on 21/1/2024.
//

import Foundation

let API_DELAY_TIME = "?delay=5"

struct APIs {
    //MARK: POST
    static let login = basicAPIHost + "login" + API_DELAY_TIME
    
    //MARK: GET
    static let getUserList = basicAPIHost + "users?page="
}
