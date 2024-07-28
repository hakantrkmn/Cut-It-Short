//
//  NetworkManager.swift
//  Cut It Short
//
//  Created by Hakan Türkmen on 28.07.2024.
//

import Foundation
import GoogleGenerativeAI
struct NetworkManager
{
    static let shared = NetworkManager()

     let model = GenerativeModel(name: "gemini-1.5-flash", apiKey: APIKey.default)

    func getResponse(userText : String) async throws -> String
    {
        let prompt = "\(String(describing: userText) ). asnwer the question .Your answer should be clear, concise, and to the point. and Your answer should be in the same language as the first sentence. "
        let response = try await model.generateContent(prompt)
        if var text = response.text {
            text.removeAll { ch in
                ch == "*"
            }
            return text
        }
        else
        {
            return "Something went wrong"
        }
    }
}
