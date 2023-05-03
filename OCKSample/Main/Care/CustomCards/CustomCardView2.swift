//
//  CustomCardView.swift
//  OCKSample
//
//  Created by Corey Baker on 4/25/23.
//  Copyright © 2023 Network Reconnaissance Lab. All rights reserved.
//

import SwiftUI
import CareKitUI
import CareKitStore

struct CustomCardView2: View {
    @Environment(\.careKitStyle) var style
    @StateObject var viewModel: CustomCardViewModel2

    var body: some View {
        CardView {
            VStack(alignment: .leading,
                   spacing: style.dimension.directionalInsets1.top) {
                /*
                 // Example of custom content that looks something like Header.
                 VStack(alignment: .leading, spacing: style.dimension.directionalInsets1.top / 4.0) {
                    Text(viewModel.taskEvents.firstEventTitle)
                        .font(.headline)
                        .fontWeight(.bold)
                    Text(viewModel.taskEvents.firstEventDetail ?? "")
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .foregroundColor(Color.primary)
                */
                // Can look through HeaderView for creating custom
                HeaderView(title: Text(viewModel.taskEvents.firstEventTitle),
                           detail: Text(viewModel.taskEvents.firstEventDetail ?? ""))
                Divider()
                HStack(alignment: .center,
                       spacing: style.dimension.directionalInsets2.trailing) {

                    /*
                     // Example of custom content.
                     */

                    Spacer()

                    TextField("QOTD", text: $viewModel.valueAsString)
                        .keyboardType(.default)
                        .font(Font.title.weight(.thin))
                        .fontWidth(.compressed)

                        .foregroundColor(.accentColor)

                    Spacer()

                }
                Button(action: {
                    Task {
                        await viewModel.action(viewModel.value)
                    }
                    // swiftlint:disable:next multiple_closures_with_trailing_closure
                }) {
                    CircularCompletionView(isComplete: viewModel.taskEvents.isFirstEventComplete) {
                        Image(systemName: "projective") // Can place any view type here
                            .resizable()
                            .padding()
                            .frame(width: 50, height: 50) // Change size to make larger/smaller
                    }
                }
            }
            .padding()
        }
        .onReceive(viewModel.$taskEvents) { taskEvents in
            /*
             DO NOT CHANGE THIS. The viewModel needs help
             from view to update "value" since taskEvents
             can't be overriden in viewModel.
             */
            viewModel.checkIfValueShouldUpdate(taskEvents)
        }
        .onReceive(viewModel.$error) { error in
            /*
             DO NOT CHANGE THIS. The viewModel needs help
             from view to update "currentError" since taskEvents
             can't be overriden in viewModel.
             */
            viewModel.setError(error)
        }
    }
}

struct CustomCardView2_Previews: PreviewProvider {
    static var previews: some View {
        CustomCardView(viewModel: .init(storeManager: .init(wrapping: OCKStore(name: Constants.noCareStoreName,
                                                                               type: .inMemory))))
    }
}
