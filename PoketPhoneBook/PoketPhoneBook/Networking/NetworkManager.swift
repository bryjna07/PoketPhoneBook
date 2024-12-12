//
//  Networking.swift
//  PoketPhoneBook
//
//  Created by Watson22_YJ on 12/9/24.
//

import UIKit

//MARK: - 네트워크에서 발생할 수 있는 에러 정의

enum NetworkError: Error {
    case networkingError
    case dataError
    case parseError
}

//MARK: - Networking (서버와 통신하는) 클래스 모델

final class NetworkManager {
    
    // 사용하게될 API 문자열
    let requestUrl = "https://pokeapi.co/api/v2/pokemon/"
    
    // 여러화면에서 통신을 한다면, 일반적으로 싱글톤으로 만듦
    static let shared = NetworkManager()
    // 여러객체를 추가적으로 생성하지 못하도록 설정
    private init() {}
    
    typealias NetworkCompletion = (Result<Poketmon, NetworkError>) -> Void
    
    // 네트워킹 요청하는 함수
    func fetchRandomPoketmonData(completion: @escaping NetworkCompletion) {
        let randomNum = Int.random(in: 1...1000)
        let urlString = "\(requestUrl)\(randomNum)"
        
        performRequest(with: urlString) { result in
            completion(result)
        }
    }
    
    // 실제 Request하는 함수 (비동기적 실행 ===> 클로저 방식으로 끝난 시점을 전달 받도록 설계)
    private func performRequest(with urlString: String, completion: @escaping NetworkCompletion) {
        print(#function)
        // URL구조체 만들기
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
        
        // get 만 쓸 때 -> dataTask(with: url)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                completion(.failure(.networkingError))
                return
            }
            guard let safeData = data else {
                completion(.failure(.dataError))
                return
            }
            
            // 데이터 분석하기
            if let poketmon = self.parseJSON(safeData) {
                print("Parse 실행")
                completion(.success(poketmon))
            } else {
                print("Parse 실패")
                completion(.failure(.parseError))
            }
        }
        task.resume()
    }
    
    // 받아본 데이터 분석하는 함수 (동기적 실행)
    private func parseJSON(_ data: Data) -> Poketmon? {
        print(#function)
        // 성공
        do {
            // 우리가 만들어 놓은 구조체(클래스 등)로 변환하는 객체와 메서드
            // (JSON 데이터 ====> PoketmonData 클래스)
            return try JSONDecoder().decode(Poketmon.self, from: data)
            
            // 실패
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
