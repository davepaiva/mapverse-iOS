//
//  NodeInfoBottomSheet.swift
//  Mapverse
//
//  Created by Dave Paiva on 27/06/25.
//

import SwiftUI

struct NodeInfoBottomSheet: View {
    @Binding var showNodeInfoBottomSheet: Bool
    let selectedPOIAttributes: MapFeatureAttributes?
    let selectedPOIOSMInfo: OSMPOIInfoResponse?
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private var formattedPOIInfo: String {
        let type = selectedPOIAttributes?.poiType.rawValue
        let id = selectedPOIAttributes?.poiId
        return "\(type ?? "") #\(String(describing: id))"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                Button("Done") {
                    showNodeInfoBottomSheet = false
                }
                .modifier(ButtonViewModifier(variant: .text))
            }
            .padding(.bottom, 16)
            
            Text("Details")
                .font(.title)
                .padding(.bottom, 8)
            
            Text(formattedPOIInfo)
                .foregroundColor(.gray)
                .padding(.bottom, 24)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    if let tags = selectedPOIAttributes?.tags as? [String: String],
                       !tags.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Tags")
                                .font(.headline)
                                .padding(.bottom, 4)
                    
                            LazyVGrid(columns: columns, spacing: 12) {
                                ForEach(Array(tags.sorted(by: { $0.key < $1.key })), id: \.key) { key, value in
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(key)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        Text(value)
                                            .font(.body)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(16)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                                }
                            }
                        }
                    }
                    
                    if let poiInfo = selectedPOIOSMInfo?.elements.first {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Metadata")
                                .font(.headline)
                                .padding(.bottom, 4)
                
                            LazyVGrid(columns: columns, spacing: 12) {
                                // Last Modified
                                MetadataCard(title: "Last Modified", value: poiInfo.timestamp.formatDateTimeString())
                                
                                // Version
                                MetadataCard(title: "Version", value: "\(poiInfo.version)")
                                
                                // Changeset
                                MetadataCard(title: "Changeset", value: "\(poiInfo.changeset)")
                                
                                // User
                                MetadataCard(title: "Modified By", value: poiInfo.user)
                            }
                        }
                    } else {
                        VStack {
                            ProgressView()
                                .modifier(ProgressViewModifier(color: .black))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

struct MetadataCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(value)
                .font(.body)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var showSheet = true
        
        var body: some View {
            ZStack {
                Color.gray.opacity(0.3)
                    .ignoresSafeArea()
                
                Text("Background View")
                    .font(.title)
                    .foregroundColor(.gray)
            }
            .sheet(isPresented: $showSheet) {
                NodeInfoBottomSheet(
                    showNodeInfoBottomSheet: $showSheet,
                    selectedPOIAttributes: DeveloperPreview.shared.selectedPOIAttributes,
                    selectedPOIOSMInfo: DeveloperPreview.shared.selectedPOIOSMInfo
                )
//                .presentationDetents([.medium, .large])
//                .presentationDragIndicator(.visible)
            }
        }
    }
    
    return PreviewWrapper()
}
