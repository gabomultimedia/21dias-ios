import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidData
    case serverError(Int)
    case decodingError(Error)
    case noData
    case unauthorized
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "URL inválida"
        case .invalidResponse: return "Respuesta inválida del servidor"
        case .invalidData: return "Datos inválidos"
        case .serverError(let code): return "Error del servidor: \(code)"
        case .decodingError: return "Error al decodificar datos"
        case .noData: return "No se recibieron datos"
        case .unauthorized: return "No autorizado"
        case .networkError(let error): return error.localizedDescription
        }
    }
}

class APIClient {
    static let shared = APIClient()
    
    // Configurable base URL - cambiar a IP del VPS cuando esté listo
    var baseURL: String {
        get { UserDefaults.standard.string(forKey: "api_base_url") ?? "https://api.21dias.app" }
        set { UserDefaults.standard.set(newValue, forKey: "api_base_url") }
    }
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: config)
        
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder.dateDecodingStrategy = .iso8601
    }
    
    func request<T: Decodable>(_ endpoint: APIEndpoint, body: [String: Any]? = nil) async throws -> T {
        guard let url = URL(string: baseURL + endpoint.path) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = KeychainHelper.shared.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        if httpResponse.statusCode == 401 {
            throw NetworkError.unauthorized
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    func requestVoid(_ endpoint: APIEndpoint, body: [String: Any]? = nil) async throws {
        guard let url = URL(string: baseURL + endpoint.path) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = KeychainHelper.shared.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        if httpResponse.statusCode == 401 {
            throw NetworkError.unauthorized
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        
        if data.isEmpty { return }
        
        let emptyResponse = try? decoder.decode(EmptyResponse.self, from: data)
        if emptyResponse == nil && !data.isEmpty {
            throw NetworkError.invalidData
        }
    }
    
    // MARK: - Streak
    func getStreak() async throws -> Streak {
        try await request(.streak)
    }
    
    // MARK: - Referral
    func getReferralInfo() async throws -> ReferralInfo {
        try await request(.getReferralInfo)
    }
    
    func useReferralCode(_ code: String) async throws {
        try await requestVoid(.useReferralCode(code: code))
    }
    
    // MARK: - Leaderboard
    func getLeaderboard(period: String) async throws -> [LeaderboardUser] {
        try await request(.getLeaderboard(period: period))
    }
}

struct EmptyResponse: Decodable {}
