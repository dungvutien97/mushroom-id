//
//  SupabaseRepository.swift
//  poca
//
//  Created by Tien Dung Vu on 1/6/25.
//

import Foundation
import Supabase
import UIKit

protocol SupabaseRepository {
    func invoke(image: UIImage, name: String) async throws -> MushroomAttributes
    func signInAnonymously() async throws -> UUID
}

final class SupabaseRepositoryImpl {
    private let client: SupabaseClient
    private let storageBucket = "mushroom-id"
    private let edgeFunctionName = "mushroom-id"

    init() {
        let url = URL(string: K_PROJECT_URL)!
        client = SupabaseClient(supabaseURL: url, supabaseKey: K_ANON_KEY)
    }

    func signOut() async throws {
        try await client.auth.signOut()
    }

    func fetchAuth() async throws -> AuthClient {
        return client.auth
    }

    func uploadImage(_ image: UIImage) async throws -> String {
        guard let imageData = image.pngData() else {
            throw NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to PNG"])
        }

        let userID = client.auth.currentUser?.id.uuidString ?? UUID().uuidString
        let timestamp = Int(Date().timeIntervalSince1970)
        let fileName = "\(storageBucket)-\(userID)-\(timestamp).png"

        let response = try await client.storage.from(storageBucket).upload(fileName, data: imageData)
        return response.path
    }
}

extension SupabaseRepositoryImpl: SupabaseRepository {
    @discardableResult
    func signInAnonymously() async throws -> UUID {
        if let currentUser = client.auth.currentUser {
            return currentUser.id
        } else {
            let session = try await client.auth.signInAnonymously()
            return session.user.id
        }
    }

    func invoke(image: UIImage, name: String) async throws -> MushroomAttributes {
        let imagePath = try await uploadImage(image)

        // Create public URL for the image
        let publicURL = try client.storage.from(storageBucket).getPublicURL(path: imagePath, download: false)

        let prompt = mushroomJSONPrompt()

        let params = [
            "image_url": publicURL.absoluteString,
            "prompt": prompt
        ]

        let response: SupaResponse = try await client.functions
            .invoke(edgeFunctionName, options: FunctionInvokeOptions(body: params))

        return response.analysis
    }
}

extension SupabaseRepositoryImpl {
    // Hàm tạo prompt JSON cho MushroomAttributes
    func mushroomJSONPrompt(language: String = Locale.current.languageCode ?? "en") -> String {
        print("Prompt for \(language)")

        return """
        You are an expert mycologist. Please  Identify the mushroom I sent and create a **JSON object** describing a mushroom species in \(language), using the following structure:

        {
          "name": "Mushroom name",
          "otherNames": "Other common names",
          "family": "Mushroom family",
          "scientificName": "Scientific name",
          "habitat": "Habitat",
          "season": "Season of appearance",
          "region": "Region distribution",
          "capShape": "Cap shape",
          "capColour": "Cap colour",
          "capDiameter": "Cap diameter (cm)",
          "stemHeight": "Stem height (cm)",
          "stemWidth": "Stem width (cm)",
          "gillAttachment": "Gill attachment",
          "gillColour": "Gill colour",
          "distinctiveFeatures": "Distinctive features for identification",
          "sporeColour": "Spore colour",
          "sporePrintNotes": "Spore print notes",
          "smellTaste": "Smell and taste",
          "edibility": "Edibility",
          "toxicityWarning": "Toxicity warning",
          "edibilityNotes": "Additional notes on edibility"
        }

        Requirements:
        2. All names and parameters should be realistic and plausible.
        3. Return **ONLY JSON**, no explanations or extra text.
        4. Use \(language) for all text values.
        """
    }
}
