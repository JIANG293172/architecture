import Foundation

/**
 3. Task Await with Closure-based Networking
 
 Interview Question: How do you bridge legacy closure-based async APIs to Modern Swift Concurrency?
 
 Answer: 
 You use 'withCheckedContinuation' or 'withCheckedThrowingContinuation'. 
 These functions provide a 'continuation' object that you resume exactly once with either 
 a value or an error, effectively turning a callback into an awaited result.
 */

// Simulating a legacy network service
class LegacyNetworkService {
    func fetchData(completion: @escaping (Result<String, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
            let success = true
            if success {
                completion(.success("Legacy Data successfully fetched"))
            } else {
                completion(.failure(NSError(domain: "NetworkError", code: 404)))
            }
        }
    }
}

class AsyncClosureDemo {
    private let service = LegacyNetworkService()
    
    // Wrapper function to convert closure to async/await
    func fetchDataAsync() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            service.fetchData { result in
                switch result {
                case .success(let data):
                    // Resume exactly once with the value
                    continuation.resume(returning: data)
                case .failure(let error):
                    // Resume exactly once with the error
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func runDemo() {
        Task {
            print("Converting closure-based call to async...")
            do {
                let data = try await fetchDataAsync()
                print("Fetched data using await: \(data)")
            } catch {
                print("Failed with error: \(error)")
            }
        }
    }
}
