//
//  CustomCardView.swift
//  OCKSample
//
//  Created by  on 4/25/23.
//  Copyright © 2023 Network Reconnaissance Lab. All rights reserved.
//

import SwiftUI
import CareKitUI
import CareKitStore

struct CustomCardView: View {
    @Environment(\.careKitStyle) var style
    @StateObject var viewModel: CustomCardViewModel

    var body: some View {

        CardView {
            VStack(alignment: .leading,
                   spacing: style.dimension.directionalInsets1.top) {
                // Can look through HeaderView for creating custom
                HeaderView(title: Text(viewModel.taskEvents.firstEventTitle),
                           detail: Text(viewModel.taskEvents.firstEventDetail ?? ""))
                Divider()

                HStack(alignment: .center,
                       spacing: style.dimension.directionalInsets2.trailing) {

                    Button(action: {
                        Task {
                            await viewModel.compareCalories()
                        }
                        // swiftlint:disable:next multiple_closures_with_trailing_closure
                    }) {
                        CircularCompletionView(isComplete: true) {
                            if viewModel.currentButton == .goalMet {
                                Image(systemName: "hand.thumbsup.fill") // Can place any view type here
                                    .resizable()
                                    .padding()
                                    .frame(width: 55, height: 55) // Change size to make larger/smaller
                            } else if viewModel.currentButton == .goalFailed {
                                Image(systemName: "hand.thumbsdown.fill") // Can place any view type here
                                    .resizable()
                                    .padding()
                                    .frame(width: 55, height: 55) // Change size to make larger/smaller
                            } else {
                                Image(systemName: "cursorarrow.click") // Can place any view type here
                                    .resizable()
                                    .padding()
                                    .frame(width: 55, height: 55) // Change size to make larger/smaller
                            }
                        }
                    }

                    Spacer()

                    Text("Cal: ")
                        .font(Font.headline)
                        .foregroundColor(Color(#colorLiteral(red: 0.7270685434, green: 0, blue: 0, alpha: 1)))
                    TextField("0",
                              value: $viewModel.userCaloriesAsInt,
                              formatter: viewModel.amountFormatter)
                    .foregroundColor(Color(#colorLiteral(red: 0.7270685434, green: 0, blue: 0, alpha: 1)))
                    .keyboardType(.numberPad)
                        .font(Font.title.weight(.bold))
                        .foregroundColor(.accentColor)

                    Spacer()

                    Text("Goal: ")
                        .font(Font.headline)
                        .foregroundColor(Color(#colorLiteral(red: 0.7270685434, green: 0, blue: 0, alpha: 1)))
                    TextField("0",
                              value: $viewModel.goalCaloriesAsInt,
                              formatter: viewModel.amountFormatter)
                    .foregroundColor(Color(#colorLiteral(red: 0.7270685434, green: 0, blue: 0, alpha: 1)))
                    .keyboardType(.numberPad)
                        .font(Font.title.weight(.bold))
                        .foregroundColor(.accentColor)

                  /*  Button(action: {
                        Task {
                            await viewModel.action(viewModel.value)
                        }
                        // swiftlin t:disable:next multiple_closures_with_trailing_closure
                    }) {
                        RectangularCompletionView(isComplete: viewModel.taskEvents.isFirstEventComplete) {
                            Image(systemName: "checkmark") // Can place any view type here
                                .resizable()
                                .padding()
                                .frame(width: 50, height: 50) // Change size to make larger/smaller
                        }
                    }*/

               /*     (viewModel.valueText ?? Text("0.0"))
                        .multilineTextAlignment(.trailing)
                        .font(Font.title.weight(.bold))
                        .foregroundColor(.accentColor)*/
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

struct CustomCardView_Previews: PreviewProvider {
    static var previews: some View {
        CustomCardView(viewModel: .init(storeManager: .init(wrapping: OCKStore(name: Constants.noCareStoreName,
                                                                               type: .inMemory))))
    }
}
