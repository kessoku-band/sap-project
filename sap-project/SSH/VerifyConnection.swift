//
//  VerifyConnection.swift
//  sap-project
//
//  Created by Brandon Li on 26/11/23.
//

import Foundation
import KeychainAccess
import Citadel
import Crypto
import SwiftUI

enum ConnectionTest {
	case untested
	case testing
	case success
	case failed
}


class ConnectionTestHandler: ObservableObject {
	var tryingText: String = ""
	
	public func verifyConnection(server: Server, keys: [PrivateKey]? = nil) async -> ConnectionTest {
		var authSuccess: Bool = false
		
		switch server.authMethod {
		case .privateKey:
			let privateKeyKeychain = Keychain(service: "com.simonfalke.privatekeys")
			
			let keyTexts: [String] = server.keyIDs?
				.map { privateKeyKeychain[$0.uuidString] ?? "" } ?? []
			let keyTypes: [String] = keys?
				.filter { key in server.keyIDs?.contains(key.id) ?? false }
				.map { $0.keyType } ?? []
			let keyNames: [String] = keys?
				.filter { key in server.keyIDs?.contains(key.id) ?? false }
				.map { $0.name } ?? []
			
			let keys = zip(keyTexts, zip(keyTypes, keyNames))
			
			print(keys)
			
		keyLoop: for (keyText, (keyType, keyName)) in keys {
			tryingText = "Trying \(keyType) key \(keyName)"
			switch keyType {
			case "rsa":
				guard let _ = try? await SSHClient.connect(
					host: server.hostname,
					port: server.port,
					authenticationMethod: .rsa(username: server.username, privateKey: Insecure.RSA.PrivateKey(sshRsa: keyText)),
					hostKeyValidator: .acceptAnything(),
					reconnect: .never
				) else {
					tryingText = "Failed to authenticate with \(keyType) key \(keyName)."
					continue
				}
				
				tryingText = "Successfully authenticated with \(keyType) key \(keyName)."
				authSuccess = true
				break keyLoop
			default:
				print(server.hostname)
				print(server.port)
				print(server.username)
				print(keyText)
				guard let _ = try? await SSHClient.connect(
					host: server.hostname,
					port: server.port,
					authenticationMethod: .ed25519(username: server.username, privateKey: Curve25519.Signing.PrivateKey(sshEd25519: keyText)),
					hostKeyValidator: .acceptAnything(),
					reconnect: .never
				) else {
					tryingText = "Failed to authenticate with \(keyType) key \(keyName)."
					continue
				}
				
				tryingText = "Successfully authenticated with \(keyType) key \(keyName)."
				authSuccess = true
				break keyLoop
			}
		}
		case .password:
			tryingText = "Trying to connect"
			let passwordKeychain = Keychain(service: "com.simonfalke.passwords")
			
			let password = passwordKeychain[server.passwordID?.uuidString ?? ""] ?? ""
			
			guard let _ = try? await SSHClient.connect(
				host: server.hostname,
				authenticationMethod: .passwordBased(username: server.username, password: password),
				hostKeyValidator: .acceptAnything(),
				reconnect: .once
			) else {
				print("wtf???????")
				tryingText = "Failed to authenticate."
				break
			}
			
			tryingText = "Successfully authenticated."
			authSuccess = true
		}
		
		switch authSuccess {
		case true:
			return ConnectionTest.success
		case false:
			return ConnectionTest.failed
		}
	}
}
