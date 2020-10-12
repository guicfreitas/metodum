//
//  DeviceDataPersistenceService.swift
//  metodum
//
//  Created by Gonzalo Ivan Santos Portales on 10/10/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import Foundation

enum LocalDirectories : String {
    case casesImages
    case methodsImages
}

private struct AcessibilityAtributes : Codable {
    var acessibilityLabel: String
    var acessibilityHint: String
    
    init(label: String,hint: String) {
        self.acessibilityLabel = label
        self.acessibilityHint = hint
    }
}

class DeviceDataPersistenceService {
    
    static var persistedImagesNames : [LocalDirectories : [String]] = [
        LocalDirectories.casesImages : [String](),
        LocalDirectories.methodsImages : [String]()
    ]
    
    static func write(acessibilityImage: AcessibilityImage, named imageName: String,on directory: LocalDirectories) {
        let documentsDirectory = getURLOf(directory: directory.rawValue)

        let dataPath = documentsDirectory.appendingPathComponent(imageName)
        do {
            try acessibilityImage.data.write(to: dataPath, options: [])
            let acessibilityAtributes =
                AcessibilityAtributes (
                    label: acessibilityImage.acessibilityLabel,
                    hint: acessibilityImage.acessibilityHint
                )
            try UserDefaults.standard.setObject(acessibilityAtributes,forKey: imageName)
            persistedImagesNames[directory]!.append(imageName)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func getImage(named imageName: String, on directory: LocalDirectories) -> AcessibilityImage? {
        let documentsDirectory = getURLOf(directory: directory.rawValue)
        let dataPath = documentsDirectory.appendingPathComponent(imageName)
        print(documentsDirectory)
        print("foi aqui msm")
        do {
            let dataImage = try Data(contentsOf: dataPath)
            let acessibilityAtributes = try UserDefaults.standard.getObject(forKey: imageName, castTo: AcessibilityAtributes.self)
            return AcessibilityImage(
                data: dataImage, acessibilityLabel:
                acessibilityAtributes.acessibilityLabel,
                acessibilityHint: acessibilityAtributes.acessibilityHint
            )
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    static func directoryExists(named directory : LocalDirectories) -> Bool {
        let fullDirectoryPath = getURLOf(directory: directory.rawValue)
        var isDir : ObjCBool = true
        let exists = FileManager.default.fileExists(atPath: fullDirectoryPath.path, isDirectory: &isDir)
        print(exists)
        return exists
    }
    
    static func createDirectory(named directory: LocalDirectories) {
        let fullDirectoryPath = getURLOf(directory: directory.rawValue)
        do {
            try FileManager.default.createDirectory(atPath: fullDirectoryPath.path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print(error.localizedDescription);
        }
    }
    
    static func getAllPersistedImagesNames(from directory: LocalDirectories) -> [String] {
        let allUrls = getAllFilesURLFrom(directory: directory)
        var imageNames = [String]()
        
        for url in allUrls {
            let name = String(url.absoluteString.split(separator: "/").last!)
            imageNames.append(name)
        }
        persistedImagesNames[directory] = imageNames
        return imageNames
    }
    
    static private func getAllFilesURLFrom(directory: LocalDirectories) -> [URL] {
        let appDocumentsDirectory = getURLOf(directory: directory.rawValue)
        do {
            let urls = try FileManager.default.contentsOfDirectory(at: appDocumentsDirectory, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
            return urls
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    
    static private func getURLOf(directory : String) -> URL {
        let appDocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fullDirectoryPath = appDocumentsDirectory.appendingPathComponent(directory, isDirectory: true)
        return fullDirectoryPath
    }
}

enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    
    var errorDescription: String? {
        rawValue
    }
}

protocol ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}

extension UserDefaults: ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}
