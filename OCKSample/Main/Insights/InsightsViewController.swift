//
//  InsightsViewController.swift
//  OCKSample
//
//  Created by Corey Baker on 4/25/23.
//  Copyright © 2023 Network Reconnaissance Lab. All rights reserved.
//

/*
 You should notice this looks like CareViewController and
 MyContactViewController combined,
 but only shows charts instead.
*/

import UIKit
import CareKitStore
import CareKitUI
import CareKit
import ParseSwift
import ParseCareKit
import os.log

class InsightsViewController: OCKListViewController {

    /// The manager of the `Store` from which the `Contact` data is fetched.
    public let storeManager: OCKSynchronizedStoreManager

    /// Initialize using a store manager. All of the contacts in the store manager will be queried and dispalyed.
    ///
    /// - Parameters:
    ///   - storeManager: The store manager owning the store whose contacts should be displayed.
    public init(storeManager: OCKSynchronizedStoreManager) {
        self.storeManager = storeManager
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Insights"

        Task {
            await displayTasks(Date())
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        Task {
            await displayTasks(Date())
        }
    }

    override func appendViewController(_ viewController: UIViewController, animated: Bool) {
        super.appendViewController(viewController, animated: animated)

        // Make sure this contact card matches app style when possible
        if let carekitView = viewController.view as? OCKView {
            carekitView.customStyle = CustomStylerKey.defaultValue
        }
    }

    @MainActor
    func fetchTasks(on date: Date) async -> [OCKAnyTask] {
        /**
         TODOq: How would you modify this to fetch all of your tasks?
         Hint - you should look at the same function in CareViewController. If you
         understand queries and filters, this will be straightforward.
         */
        var query = OCKTaskQuery(for: date)
        query.excludesTasksWithNoEvents = true
        do {
            let tasks = try await storeManager.store.fetchAnyTasks(query: query)
            return tasks.filter { $0.id != Onboard.identifier() }
        } catch {
            Logger.insights.error("\(error.localizedDescription, privacy: .public)")
            return []
        }
    }

    /*
     TODOq: Plot all of your tasks in this method. Note that you can combine multiple
     tasks into one chart (like the Nausea/Doxlymine chart if they are related.
    */

    func taskViewController(for task: OCKAnyTask,
                            on date: Date) -> [UIViewController]? {
        /*
         TODOq: CareKit has 3 plotType's: .bar, .scatter, and .line.
         You should have a 3 types in your InsightView meaning you
         should have at least 3 charts. Remember that all of your
         tasks need to be graphed so you may have more. The solution
         for not this should not be to show all 3 plot types for a
         single task. Your code should be flexible enough to determine
         a graph type. Instead, you should look extend OCKTask and OCKAnyTask
         to add a "graph" property similar to "card". This means you probably
         should create a "GraphCard" enum similar to "CareKitCard" and allow
         the user to select the specific graph when adding a new task.
         Hint - you should look at the same function in CareViewController
         to determine how to switch graphs on an enum.
         */

        let survey = CheckIn() // Only used for example.
        let surveyTaskID = survey.identifier() // Only used for example.

        let workout = Workout()
        let workoutTaskID = workout.identifier()

        let weight = Weight()
        let weightTaskID = weight.identifier()

        switch task.id {
        case workoutTaskID:
            let firstBarGradient = TintColorFlipKey.defaultValue
            let secondBarGradient = TintColorKey.defaultValue
            let meanWorkoutMinutesDataSeries = OCKDataSeriesConfiguration(
                taskID: workoutTaskID,
                legendTitle: "Workout Minutes",
                gradientStartColor: firstBarGradient,
                gradientEndColor: firstBarGradient,
                markerSize: 10,
                eventAggregator: .aggregatorMean(Workout.workoutItemIdentifier))

            let meanGoalMinutesDataSeries = OCKDataSeriesConfiguration(
                taskID: workoutTaskID,
                legendTitle: "Goal Minutes",
                gradientStartColor: secondBarGradient,
                gradientEndColor: secondBarGradient,
                markerSize: 10,
                eventAggregator: .aggregatorMean(Workout.goalItemIdentifier))

            let insightsCard = OCKCartesianChartViewController(
                plotType: .bar,
                selectedDate: date,
                configurations: [meanWorkoutMinutesDataSeries, meanGoalMinutesDataSeries],
                storeManager: self.storeManager)

            insightsCard.chartView.headerView.titleLabel.text = "Workout/Goal Minutes"
            insightsCard.chartView.headerView.detailLabel.text = "This week"
            insightsCard.chartView.headerView.accessibilityLabel = "Minutes, This Week"

            return [insightsCard]

        case TaskID.logWorkout:
            var cards = [UIViewController]()
            // dynamic gradient colors
            let firstGradient = TintColorFlipKey.defaultValue

            // Create a plot comparing nausea to medication adherence.
            let logDataSeries = OCKDataSeriesConfiguration(
                taskID: TaskID.logWorkout,
                legendTitle: "Log Meals",
                gradientStartColor: firstGradient,
                gradientEndColor: firstGradient,
                markerSize: 10,
                eventAggregator: OCKEventAggregator.countOutcomeValues)

            let insightsCard = OCKCartesianChartViewController(
                plotType: .scatter,
                selectedDate: date,
                configurations: [logDataSeries],
                storeManager: self.storeManager)

            insightsCard.chartView.headerView.titleLabel.text = "Meals Logged"
            insightsCard.chartView.headerView.detailLabel.text = "This Week"
            insightsCard.chartView.headerView.accessibilityLabel = "Number meals, This Week"
            cards.append(insightsCard)

            return cards

        case TaskID.activeEnergy:
            var cards = [UIViewController]()
            // dynamic gradient colors
            let firstGradient = TintColorFlipKey.defaultValue

            // Create a plot comparing nausea to medication adherence.
            let logDataSeries = OCKDataSeriesConfiguration(
                taskID: TaskID.activeEnergy,
                legendTitle: "Energy Burned",
                gradientStartColor: firstGradient,
                gradientEndColor: firstGradient,
                markerSize: 10,
                eventAggregator: OCKEventAggregator.countOutcomeValues)

            let insightsCard = OCKCartesianChartViewController(
                plotType: .bar,
                selectedDate: date,
                configurations: [logDataSeries],
                storeManager: self.storeManager)

            insightsCard.chartView.headerView.titleLabel.text = "Energy Burned, Large Calories"
            insightsCard.chartView.headerView.detailLabel.text = "This Week"
            insightsCard.chartView.headerView.accessibilityLabel = "Large Calories, This Week"
            cards.append(insightsCard)

            return cards

        case TaskID.flightsClimbed:
            var cards = [UIViewController]()
            // dynamic gradient colors
            let firstGradient = TintColorFlipKey.defaultValue

            // Create a plot comparing nausea to medication adherence.
            let logDataSeries = OCKDataSeriesConfiguration(
                taskID: TaskID.flightsClimbed,
                legendTitle: "Flights Climbed",
                gradientStartColor: firstGradient,
                gradientEndColor: firstGradient,
                markerSize: 10,
                eventAggregator: OCKEventAggregator.countOutcomeValues)

            let insightsCard = OCKCartesianChartViewController(
                plotType: .line,
                selectedDate: date,
                configurations: [logDataSeries],
                storeManager: self.storeManager)

            insightsCard.chartView.headerView.titleLabel.text = "Flights Climbed"
            insightsCard.chartView.headerView.detailLabel.text = "This Week"
            insightsCard.chartView.headerView.accessibilityLabel = "Flights climbed, This Week"
            cards.append(insightsCard)

            return cards

        case weightTaskID:
            let firstBarGradient = TintColorFlipKey.defaultValue

            let meanWeightDataSeries = OCKDataSeriesConfiguration(
                taskID: weightTaskID,
                legendTitle: "Weight, kg",
                gradientStartColor: firstBarGradient,
                gradientEndColor: firstBarGradient,
                markerSize: 10,
                eventAggregator: .aggregatorMean(Weight.currentWeightItemIdentifier))

            let insightsCard = OCKCartesianChartViewController(
                plotType: .line,
                selectedDate: date,
                configurations: [meanWeightDataSeries],
                storeManager: self.storeManager)

            insightsCard.chartView.headerView.titleLabel.text = "Current Weight"
            insightsCard.chartView.headerView.detailLabel.text = "This week"
            insightsCard.chartView.headerView.accessibilityLabel = "kg, This Week"

            return [insightsCard]

        case surveyTaskID:

            /*
             Note that that there's a small bug for the check in graph because
             it averages all of the "Pain + Sleep" hours. This okay for now. If
             you are collecting ResearchKit input that only collects 1 value per
             survey, you won't have this problem.
             */

            // dynamic gradient colors
            let meanGradientStart = TintColorFlipKey.defaultValue
            let meanGradientEnd = TintColorKey.defaultValue

            // Create a plot comparing mean to median.
            let meanDataSeries = OCKDataSeriesConfiguration(
                taskID: surveyTaskID,
                legendTitle: "Mean",
                gradientStartColor: meanGradientStart,
                gradientEndColor: meanGradientEnd,
                markerSize: 10,
                eventAggregator: .aggregatorMean(CheckIn.sleepItemIdentifier))

            let medianDataSeries = OCKDataSeriesConfiguration(
                taskID: surveyTaskID,
                legendTitle: "Median",
                gradientStartColor: .systemGray2,
                gradientEndColor: .systemGray,
                markerSize: 10,
                eventAggregator: .aggregatorMedian(CheckIn.sleepItemIdentifier))

            let insightsCard = OCKCartesianChartViewController(
                plotType: .line,
                selectedDate: date,
                configurations: [meanDataSeries, medianDataSeries],
                storeManager: self.storeManager)

            insightsCard.chartView.headerView.titleLabel.text = "Sleep Mean & Median"
            insightsCard.chartView.headerView.detailLabel.text = "This Week"
            insightsCard.chartView.headerView.accessibilityLabel = "Mean & Median, This Week"

            return [insightsCard]
            
        default:
            return nil
        }
    }

    @MainActor
    func displayTasks(_ date: Date) async {

        let tasks = await fetchTasks(on: date)
        self.clear() // Clear after pulling tasks from database
        tasks.compactMap {
            let cards = self.taskViewController(for: $0, on: date)
            cards?.forEach {
                if let carekitView = $0.view as? OCKView {
                    carekitView.customStyle = CustomStylerKey.defaultValue
                }
            }
            return cards
        }.forEach { (cards: [UIViewController]) in
            cards.forEach {
                self.appendViewController($0, animated: false)
            }
        }
    }
}
