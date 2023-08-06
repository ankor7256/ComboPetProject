//
//  FTDetailsView.swift
//  ComboPetProject
//
//  Created by Andrew K on 8/6/23.
//

import SwiftUI

@available(iOS 13.0.0, *)
struct FTDetailsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(feature.rawValue)
                .bold()
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)

            let binding = Binding<Bool>(
                get: { self.isFTEnabled },
                set: {
                    self.isFTEnabled = $0
                })

            Toggle(isOn: binding) {
                Text("Is Enabled")
            }
            Group {
                Text("[Description]")
                    .foregroundColor(.blue)
                Text(feature.desc)
            }
            Group {
                Text("[Task]")
                    .foregroundColor(.blue)
                Text(feature.task)
            }
            Group {
                Text("[Author]")
                    .foregroundColor(.blue)
                Text(feature.author)
            }
            Spacer()
        }
        .padding(16)
        .navigationBarTitle("Feature Details")
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarTitle("Feature Details", displayMode: .inline)
        .onAppear {
            self.isFTEnabled = service.getValue(for: feature).isEnabled
        }
    }

    init(feature: FeatureToggles, service: FeatureTogglesService) {
        self.service = service
        self.feature = feature
    }

    private var service: FeatureTogglesService
    private var feature: FeatureToggles
    @State private var isFTEnabled: Bool = false {
        didSet {
            guard oldValue != isFTEnabled else { return }
            service.overrideLocal(value: isFTEnabled, for: feature)
        }
    }
}

@available(iOS 13.0.0, *)
struct FTDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FTDetailsView(feature: .mockAPI, service: FeatureTogglesFactory.sharedService)
        }
    }
}
