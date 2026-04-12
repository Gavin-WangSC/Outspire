import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
    case requestFailed(Error)
    case serverError(Int)
    case unauthorized

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case let .decodingError(error):
            return "Failed to decode response: \(error.localizedDescription)"
        case let .requestFailed(error):
            return "Request failed: \(error.localizedDescription)"
        case let .serverError(code):
            return "Server error with code: \(code)"
        case .unauthorized:
            return "Unauthorized access"
        }
    }
}
