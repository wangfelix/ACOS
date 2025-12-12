import Foundation

struct BlabladorRequest: Codable {
    let model: String
    let messages: [Message]
    let temperature: Double
    let topP: Double
    let topK: Int
    let n: Int
    let maxTokens: Int
    let stop: [String]?
    let stream: Bool
    let presencePenalty: Double
    let frequencyPenalty: Double
    let user: String
    let seed: Int?

    enum CodingKeys: String, CodingKey {
        case model, messages, temperature
        case topP = "top_p"
        case topK = "top_k"
        case n
        case maxTokens = "max_tokens"
        case stop, stream
        case presencePenalty = "presence_penalty"
        case frequencyPenalty = "frequency_penalty"
        case user, seed
    }
}

struct Message: Codable {
    let role: String
    let content: String
}

struct BlabladorResponse: Codable {
    let choices: [Choice]

    struct Choice: Codable {
        let message: Message
    }
}

class BackgroundResearchService {
    
    private let baseURL = URL(string: "https://api.helmholtz-blablador.fz-juelich.de/v1/chat/completions")!
    // TODO: Replace with actual token or secure storage retrieval
    private let apiToken = "YOUR_TOKEN"

    func performResearch(for query: String) async throws -> String {
        let messages = [
            Message(role: "system", content: "You are a helpful research assistant."),
            Message(role: "user", content: query)
        ]

        let payload = BlabladorRequest(
            model: "alias-large",
            messages: messages,
            temperature: 0.7,
            topP: 1.0,
            topK: -1,
            n: 1,
            maxTokens: 1000,
            stop: nil,
            stream: false,
            presencePenalty: 0,
            frequencyPenalty: 0,
            user: "macos-client",
            seed: 42
        )

        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try JSONEncoder().encode(payload)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            if let responseString = String(data: data, encoding: .utf8) {
                 print("Blablador Error: \(responseString)")
            }
            throw NSError(domain: "BackgroundResearchService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Request failed"])
        }

        let blabladorResponse = try JSONDecoder().decode(BlabladorResponse.self, from: data)
        
        guard let firstChoice = blabladorResponse.choices.first else {
             throw NSError(domain: "BackgroundResearchService", code: 2, userInfo: [NSLocalizedDescriptionKey: "No choices returned"])
        }

        return firstChoice.message.content
    }
}
