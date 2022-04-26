//
//  ScrumStore.swift
//  Scrumdinger
//
//  Created by Zoe Schmitt on 4/25/22.
//

import Foundation
import SwiftUI

// ObservableObject is a class-constrained protocol for connecting external model data to SwiftUI views.
// An ObservableObject includes an objectWillChange publisher that emits when one of its @Published properties is about to change. Any view observing an instance of ScrumStore will render again when the scrums value changes.
class ScrumStore: ObservableObject {
    @Published var scrums: [DailyScrum] = []

    // Scrumdinger will load and save scrums to a file in the user’s Documents folder. You’ll add a function that makes accessing that file more convenient.
    private static func fileURL() throws -> URL {
        // You use the shared instance of the FileManager class to get the location of the Documents directory for the current user.
        // Call appendingPathComponent(_:) to return the URL of a file named scrums.data.
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
            .appendingPathComponent("scrums.data")
    }

    // -- MARK: ASYNC OLD WAY W DISPATCH

    // Result is a single type that represents the outcome of an operation, whether it’s a success or failure. The load function accepts a completion closure that it calls asynchronously with either an array of scrums or an error.
    // dispatch queues to choose which tasks run on the main thread or background threads.
    static func load(completion: @escaping (Result<[DailyScrum], Error>)->Void) {
        // Dispatch queues are first in, first out (FIFO) queues to which your application can submit tasks. Background tasks have the lowest priority of all tasks.
        // Because scrums.data doesn’t exist when a user launches the app for the first time, you call the completion handler with an empty array if there’s an error opening the file handle.
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let dailyScrums = try JSONDecoder().decode([DailyScrum].self, from: file.availableData)
                print(dailyScrums)
                // You perform the longer-running tasks of opening the file and decoding its contents on a background queue. When those tasks complete, you switch back to the main queue.
                DispatchQueue.main.async {
                    completion(.success(dailyScrums))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    static func save(scrums: [DailyScrum], completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(scrums)
                print(data)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(scrums.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }


    // -- MARK: ASYNC NEW WAY W ASYNC

    static func load() async throws -> [DailyScrum] {
        // Calling withCheckedThrowingContinuation suspends the load function, then passes a continuation into a closure that you provide. A continuation is a value that represents the code after an awaited function.
        try await withCheckedThrowingContinuation { continuation in
            load { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let scrums):
                    continuation.resume(returning: scrums)
                }
            }
        }
    }

    // The save function returns a value that callers of the function may not use. The @discardableResult attribute disables warnings about the unused return value.
    @discardableResult
    static func save(scrums: [DailyScrum]) async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            save(scrums: scrums) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let scrumsSaved):
                    continuation.resume(returning: scrumsSaved)
                }
            }
        }
    }
}
