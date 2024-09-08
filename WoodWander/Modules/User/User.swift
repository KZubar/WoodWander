//
//  User.swift
//  WoodWander
//
//  Created by k.zubar on 7.07.24.
//

import Foundation

//FIXME: - скелет класса User

open class User {

    public typealias CompletionHandler = (Bool) -> Void

    // MARK: Class Properties
    // --------------------------------------------------------------------------
    var authenticationToken: String = ""
    
    var firstName: String = ""
    var lastName: String = ""
    var phone: String = ""
    var email: String = ""
    var addressStreet: String = ""
    var addressCity: String = ""
    var addressState: String = ""
    var addressCountry: String = ""
    var addressZip: UInt64 = 0
    
    // MARK: Static Functions
    // --------------------------------------------------------------------------
    static func create(
        email: String,
        password: String,
        completion: CompletionHandler?
    ) {
        let user = User()
        user.email = email
    }
    
}
