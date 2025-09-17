//
//  SettingsView.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 14/9/25.
//

import SwiftUI

struct SettingsView: View {
    @State private var showTerms = false
    @State private var showPrivacy = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            // Section 2: Support
            Section(header: Text("Support")) {
                Button(action: {
                    if let url = URL(string: "mailto:developer@minimetlab.com") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    HStack {
                        Label {
                            Text("Contact Us")
                                .foregroundStyle(.accent)
                        } icon: {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.green)
                        }
                        Spacer()
                        Image(systemName: "chevron.forward")
                            .foregroundStyle(.gray)
                    }
                }
            }

            // Section 3: Legal
            Section(header: Text("Legal")) {
                Button(action: {
                    showTerms = true
                }) {
                    HStack {
                        Label {
                            Text("Terms & Conditions")
                                .foregroundStyle(.accent)
                        } icon: {
                            Image(systemName: "doc.text.fill")
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Image(systemName: "chevron.forward")
                            .foregroundStyle(.gray)
                    }
                }
                .sheet(isPresented: $showTerms) {
                    VDWebView(urlString: kTermsURL)
                        .ignoresSafeArea()
                }

                Button(action: {
                    showPrivacy = true
                }) {
                    HStack {
                        Label {
                            Text("Privacy Policy")
                                .foregroundStyle(.accent)
                        } icon: {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.blue)
                        }
                        Spacer()
                        Image(systemName: "chevron.forward")
                            .foregroundStyle(.gray)
                    }
                }
                .sheet(isPresented: $showPrivacy) {
                    VDWebView(urlString: kPolicyURL)
                        .ignoresSafeArea()
                }
            }

            // Section 4: About
            Section {
                Button(action: {
                    // Action to rate the app on App Store
                    if let url = URL(string: "https://apps.apple.com/app/id\(kAppId)") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    HStack {
                        Label {
                            Text("Rate on App Store")
                                .foregroundStyle(.accent)
                        } icon: {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        }
                        Spacer()
                        Image(systemName: "chevron.forward")
                            .foregroundStyle(.gray)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle()) // Apple-style list
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        } //: LIST VIEW
    }
}
