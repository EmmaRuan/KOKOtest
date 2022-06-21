//
//  KoKoStruct.swift
//  KOKO_Friends
//
//  Created by EmmaRuan on 2022/6/20.
//

import Foundation

// MARK: - ProfileInfo
struct Profile: Decodable {
    let response: [response]
}

struct response: Decodable {
    let name, kokoid: String
}


// MARK: - Friends
struct Friends: Decodable {
    let response: [Response]
}
struct Response: Decodable {
    let name: String
    let status: Int
    let isTop, fid, updateDate: String
}
