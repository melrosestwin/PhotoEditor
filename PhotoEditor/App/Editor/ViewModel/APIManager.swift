//
//  APIManager.swift
//  PhotoEditor
//

import Foundation
import Alamofire
import UIKit

class APIManager {
    
    private let apiKey: String
    private let baseURL: String = "https://api.stability.ai/v2beta"
    
    init() {
        apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
    }
    
    func fetchResults(generationId: String) async throws -> Data {
        guard let url = URL(string: baseURL + "/results/" + generationId) else { throw URLError(.badURL) }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]
        
        let interceptor = RetryHandler(retryLimit: 3, retryDelay: 1.0)
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .get, headers: headers, interceptor: interceptor)
                .validate(contentType: ["image/png", "image/jpeg", "image/*", "application/json"])
                .responseData { response in
                    switch response.result {
                    case .success(let value):
                        continuation.resume(returning: value)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    func replaceBackground(for image: UIImage, with prompt: String) async throws -> String {
        guard let imageData = image.pngData() else { throw APIError.invalidImageData }
        guard let promptData = prompt.data(using: .utf8) else { throw APIError.invalidPromptData }
        
        let data = MultipartFormData()
        data.append(imageData, withName: "subject_image", fileName: "image.png", mimeType: "image/png")
        data.append(promptData, withName: "background_prompt")
        
        return try await replaceBackground(multipartFormData: data)
    }
    
    func replaceBackground(for image: UIImage, with reference: UIImage) async throws -> String {
        guard let imageData = image.pngData(),
              let referenceData = reference.pngData() else { throw APIError.invalidImageData }
        
        let data = MultipartFormData()
        data.append(imageData, withName: "subject_image", fileName: "image.png", mimeType: "image/png")
        data.append(referenceData, withName: "background_reference", fileName: "reference.png", mimeType: "image/png")
        
        return try await replaceBackground(multipartFormData: data)
    }
    
    private func replaceBackground(multipartFormData: MultipartFormData) async throws -> String {
        guard let url = URL(string: baseURL + "/stable-image/edit/replace-background-and-relight") else { throw URLError(.badURL) }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "multipart/form-data",
            "Accept": "image/*",
        ]
        
        return try await AF.upload(
            multipartFormData: multipartFormData,
            to: url,
            method: .post,
            headers: headers)
        .validate(contentType: ["application/json"])
        .serializingDecodable(APIResponse.self)
        .result
        .get()
        .id
    }
    
    func removeBackground(for image: UIImage) async throws -> Data {
        guard let url = URL(string: baseURL + "/stable-image/edit/remove-background") else { throw URLError(.badURL) }
        guard let data = image.pngData() else { throw APIError.invalidImageData }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "multipart/form-data",
            "Accept": "image/*",
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(data, withName: "image", fileName: "image.png", mimeType: "image/png")
                },
                to: url,
                method: .post,
                headers: headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func inpaint(for image: UIImage, with prompt: String, using mask: UIImage?) async throws -> Data {
        guard let url = URL(string: baseURL + "/stable-image/edit/inpaint") else { throw URLError(.badURL) }
        guard let imageData = image.pngData() else { throw APIError.invalidImageData }
        guard let promptData = prompt.data(using: .utf8) else { throw APIError.invalidPromptData }
        let maskData = mask?.pngData()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "multipart/form-data",
            "Accept": "image/*",
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(imageData, withName: "image", fileName: "image.png", mimeType: "image/png")
                    multipartFormData.append(promptData, withName: "prompt")
                    if let maskData {
                        multipartFormData.append(maskData, withName: "mask", fileName: "mask.png", mimeType: "image/png")
                    }
                    multipartFormData.append("png".data(using: .utf8)!, withName: "output_format")
                },
                to: url,
                method: .post,
                headers: headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

enum APIError: Error {
    case invalidImageData
    case invalidPromptData
}

struct APIResponse: Decodable {
    let id: String
    let status: String?
}

final class RetryHandler: RequestInterceptor {
    let retryLimit: Int
    let retryDelay: TimeInterval

    init(retryLimit: Int = 3, retryDelay: TimeInterval = 2.0) {
        self.retryLimit = retryLimit
        self.retryDelay = retryDelay
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        let retryCount = request.retryCount
        if retryCount < retryLimit {
            print("Retrying request (\(retryCount + 1)) after \(retryDelay) seconds...")
            completion(.retryWithDelay(retryDelay))
        } else {
            completion(.doNotRetry)
        }
    }
}
