//
//  StoresView.swift
//  Sales
//
//  Created by José Ruiz on 24/7/24.
//

import MessageUI
import SwiftUI
import UIKit

struct StoresView: View {
    @State private var result: Result<MFMailComposeResult, Error>? = nil
    @State private var isShowingMailView = false
    @State private var isShowingAlert = false
    
    @State private var subject: String = ""
    @State private var description: String = ""
    
    @EnvironmentObject var viewModel: StoreViewModel
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.stores ?? []) { store in
                            NavigationLink(value: store) {
                                StoreRowView(store: store)
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                                    .padding(.horizontal)
                                    .padding(.top, 4)
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText)
            .onChange(of: searchText) { _, newValue in
                viewModel.searchStoresByName(for: newValue)
            }
            .navigationTitle("Stores")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: Store.self) { store in
                StoreView(store: store)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        if MFMailComposeViewController.canSendMail() {
                            self.isShowingAlert.toggle()
                        } else {
                            // Handle the error - e.g., show an alert to the user
                            print("Cannot send mail")
                        }
                    }) {
                        Text("Send Email")
                    }
                }
            }
            .refreshable {
                viewModel.removeAllStores()
            }
            .sheet(isPresented: $isShowingMailView) {
                MailView(result: self.$result,
                         recipients: ["example@example.com"],
                         subject: self.subject,
                         body: self.description)
            }
            .alert("Compose Email", isPresented: $isShowingAlert, actions: {
                TextField("Subject", text: $subject)
                TextField("Message", text: $description)
                Button("Cancel", role: .cancel, action: {
                    self.isShowingAlert = false
                })
                Button("Send", action: {
                    self.isShowingMailView.toggle()
                })
            }, message: {
                Text("Enter the subject and message for the email.")
            })
        }
    }
}
