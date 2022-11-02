//
//  Member.swift
//  [iOS] MemberList
//
//  Created by 유현이 on 2022/11/01.
//

import Foundation
import UIKit

struct Member {
    lazy var memberImage: UIImage? = {
        guard let name = name else {
            return UIImage(systemName: "person")
        }
        return UIImage(named: "\(name).png") ?? UIImage(systemName: "person")
    }()
    
    static var memberNumbers: Int = 0
    
    let memberID: Int
    var name: String?
    var age: Int?
    var phone: String?
    var address: String?
    
    init(name: String?, age: Int?, phone: String?, address: String?) {
        self.memberID = Member.memberNumbers
        self.name = name
        self.age = age
        self.phone = phone
        self.address = address
        Member.memberNumbers += 1
    }
}
