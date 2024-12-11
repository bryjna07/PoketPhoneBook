//
//  Networking.swift
//  PoketPhoneBook
//
//  Created by Watson22_YJ on 12/9/24.
//

import Alamofire
import UIKit

//MARK: - Networking (서버와 통신하는) 클래스 모델

final class NetworkManager {
    
    // 사용하게될 API 문자열
    let requestUrl = "https://pokeapi.co/api/v2/pokemon/"
    
    // 여러화면에서 통신을 한다면, 일반적으로 싱글톤으로 만듦
    static let shared = NetworkManager()
    // 여러객체를 추가적으로 생성하지 못하도록 설정
    private init() {}
    
    // Alamofire 를 사용해서 서버 데이터를 불러오는 메서드
    func fetchDateByAlamofire<T: Decodable>(url: URL, completion: @escaping (Result<T, AFError>) -> Void) {
        AF.request(url).responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
    
    // 서버에서 포켓몬 데이터를 받아오는 메서드
    func fetchPoketmonData(completion: @escaping (Result<PoketmonData,AFError>) -> Void) {
        let randomNum = Int.random(in: 1...1000)
        let url = URL(string: "\(requestUrl)\(randomNum)")
        guard let urlString = url else {
            print("잘못된 URL")
            return
        }
        
        fetchDateByAlamofire(url: urlString) { [weak self] (result: Result<PoketmonData, AFError>) in
            _ = self
            completion(result)
        }
    }
}
