import PlatformCore

public protocol ImageExportRepository {
    func save(images: [PImage]) async -> [Bool]
}
