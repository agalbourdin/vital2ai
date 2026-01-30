import SwiftUI

struct ContentView: View {
    @StateObject private var healthKitManager = HealthKitManager()
    @StateObject private var biometricManager = BiometricManager()
    @State private var selectedMonths: Set<ExportMonth> = []
    @State private var availableMonths: [ExportMonth] = []
    @State private var isExporting = false
    @State private var shareURLs: [URL] = []
    @State private var showShareSheet = false
    @State private var errorMessage: String?
    @State private var exportHealthData = true
    @State private var exportWorkouts = true
    @State private var showInfoPage = false
    @State private var exportedURLs: [URL]? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView {
                    ScrollViewReader { proxy in
                        VStack(spacing: 24) {
                            headerSection
                                .padding(.top, -10)
                                .id("top")
                            dataTypesSection
                            monthSelectionSection
                            actionButtonSection
                            disclaimerSection
                        }
                        .onAppear {
                            generateAvailableMonths(proxy: proxy)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    infoButton
                }
            }
            .sheet(isPresented: $showInfoPage) {
                InfoView()
            }
            .navigationDestination(item: $exportedURLs) { urls in
                ExportSuccessView(shareURLs: urls)
            }
        }
    }

    private var headerSection: some View {
        VStack(spacing: 12) {
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 100)

            Text("app_name")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)

            Text("app_tagline")
                .font(.system(size: 12, weight: .semibold))
                .tracking(1.5)
                .foregroundColor(.secondaryText)
        }
        .padding(.bottom, 20)
    }

    private var dataTypesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("select_data_types")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.white)

            VStack(spacing: 12) { // Stacked vertically for better small screen support
                DataTypeToggle(
                    icon: "heart.fill",
                    title: "health",
                    isOn: $exportHealthData,
                    color: .cyan
                )

                DataTypeToggle(
                    icon: "dumbbell.fill",
                    title: "workouts",
                    isOn: $exportWorkouts,
                    color: .purple
                )
            }
        }
        .padding(20)
        .background(Color.cardBackground.opacity(0.5))
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
        .padding(.horizontal)
    }

    private var monthSelectionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("select_export_period")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)

                Spacer()

                if selectedMonths.isEmpty {
                    Button(String(localized: "select_all")) {
                        selectedMonths = Set(availableMonths.prefix(15))
                    }
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.brandPrimary)
                } else {
                    Button(String(localized: "clear_all")) {
                        selectedMonths.removeAll()
                    }
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.brandPrimary)
                }
            }

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(availableMonths.prefix(15)) { month in
                    MonthButton(
                        month: month,
                        isSelected: selectedMonths.contains(month),
                        gradient: LinearGradient.brandGradient
                    ) {
                        if selectedMonths.contains(month) {
                            selectedMonths.remove(month)
                        } else {
                            selectedMonths.insert(month)
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(Color.cardBackground.opacity(0.5))
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
        .padding(.horizontal)
    }

    private var actionButtonSection: some View {
        VStack(spacing: 16) {
            if isExporting {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .brandPrimary))
                    .scaleEffect(1.2)
                    .padding()
            } else {
                Button(action: startExport) {
                    HStack(spacing: 8) {
                        Image(systemName: "gearshape.fill")
                        Text("generate_csv_export")
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        Group {
                        if selectedMonths.isEmpty || (!exportHealthData && !exportWorkouts) {
                                Color.gray.opacity(0.3)
                            } else {
                                LinearGradient.brandGradient
                            }
                        }
                    )
                    .cornerRadius(16)
                    .shadow(color: (selectedMonths.isEmpty || (!exportHealthData && !exportWorkouts)) ? .clear : .brandPrimary.opacity(0.3), radius: 15, x: 0, y: 5)
                }
                .disabled(selectedMonths.isEmpty || (!exportHealthData && !exportWorkouts))
            }

            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal)
    }

    private var disclaimerSection: some View {
        VStack(spacing: 8) {
            Text("home_privacy_disclaimer")
                .font(.system(size: 13))
                .foregroundColor(.secondaryText)
                .multilineTextAlignment(.center)

            Button {
                showInfoPage = true
            } label: {
                Text("home_learn_more")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 40)
        .padding(.bottom, 40)
    }

    private var infoButton: some View {
        Button {
            showInfoPage = true
        } label: {
            Image(systemName: "info.circle")
                .foregroundColor(.brandPrimary)
        }
    }

    private func startExport() {
        isExporting = true
        errorMessage = nil

        biometricManager.authenticate { result in
            Task { @MainActor in
                switch result {
                case .success:
                    await self.performExport()
                case .failure(let error):
                    self.errorMessage = error.errorDescription
                    self.isExporting = false
                }
            }
        }
    }

    @MainActor
    private func performExport() async {
        // Global safety timeout
        let timeoutTask = Task {
            try? await Task.sleep(nanoseconds: 45 * 1_000_000_000)
            if !Task.isCancelled {
                self.errorMessage = String(localized: "error_export_timeout")
                self.isExporting = false
            }
        }

        defer { timeoutTask.cancel() }

        do {
            let success = try await healthKitManager.requestAuthorization()
            guard success else {
                self.errorMessage = String(localized: "error_healthkit_auth_failed")
                self.isExporting = false
                return
            }

            let monthsArray = Array(selectedMonths).sorted(by: { $0.date < $1.date })
            let medicalID = await healthKitManager.fetchMedicalID()

            var allSummaries: [DailySummary] = []
            var allWorkouts: [WorkoutSummary] = []

            // Fetch data in parallel
            if exportHealthData && exportWorkouts {
                async let summaries = healthKitManager.fetchDailySummaries(for: monthsArray)
                async let workouts = healthKitManager.fetchWorkouts(for: monthsArray, medicalID: medicalID)
                allSummaries = await summaries
                allWorkouts = await workouts
            } else if exportHealthData {
                allSummaries = await healthKitManager.fetchDailySummaries(for: monthsArray)
            } else if exportWorkouts {
                allWorkouts = await healthKitManager.fetchWorkouts(for: monthsArray, medicalID: medicalID)
            }

            // Check if any actual data was found for the selected types
            let hasAnyHealthData = exportHealthData && allSummaries.contains(where: { $0.hasActualData })
            let hasAnyWorkoutData = exportWorkouts && !allWorkouts.isEmpty

            guard hasAnyHealthData || hasAnyWorkoutData else {
                errorMessage = String(localized: "error_no_data_found")
                isExporting = false
                return
            }

            // Move file generation to a background task
            let localExportHealthData = self.exportHealthData
            let localExportWorkouts = self.exportWorkouts

            let urls = await Task.detached(priority: .userInitiated) {
                var generatedURLs: [URL] = []

                if localExportHealthData {
                    if allSummaries.contains(where: { $0.hasActualData }) {
                        if let url = CSVManager.generateCSV(from: allSummaries) {
                            generatedURLs.append(url)
                        }
                    }
                }

                if localExportWorkouts {
                    if !allWorkouts.isEmpty {
                        if let url = CSVManager.generateWorkoutsCSV(from: allWorkouts) {
                            generatedURLs.append(url)
                        }
                    }
                }

                if let markdownURL = CSVManager.generateMetricsMarkdown(medicalID: medicalID) {
                    generatedURLs.append(markdownURL)
                }

                return generatedURLs
            }.value

            if !urls.isEmpty {
                self.exportedURLs = urls
                self.isExporting = false
            } else {
                self.errorMessage = String(localized: "error_export_failed")
                self.isExporting = false
            }

        } catch {
            self.errorMessage = error.localizedDescription
            self.isExporting = false
        }
    }

    private func generateAvailableMonths(proxy: ScrollViewProxy? = nil) {
        // Reset selections on home page entry
        selectedMonths.removeAll()
        exportHealthData = true
        exportWorkouts = true

        if let proxy = proxy {
            withAnimation {
                proxy.scrollTo("top", anchor: .top)
            }
        }

        let calendar = Calendar.current
        let now = Date()
        var months: [ExportMonth] = []

        for i in 0..<15 {
            if let date = calendar.date(byAdding: .month, value: -i, to: now),
               let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) {
                months.append(ExportMonth(date: firstOfMonth))
            }
        }

        availableMonths = months.sorted(by: { $0.date > $1.date })
    }
}

// Custom Components
struct DataTypeToggle: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool
    let color: Color

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 16))

            Text(LocalizedStringKey(title))
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: .brandPrimary))
                .scaleEffect(0.8)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.cardBackground)
        .cornerRadius(20) // More rounded
        .frame(maxWidth: .infinity)
    }
}

struct MonthButton: View {
    let month: ExportMonth
    let isSelected: Bool
    let gradient: LinearGradient
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(month.shortName)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18) // Increased height
                .background(
                    Group {
                        if isSelected {
                            gradient
                        } else {
                            Color(red: 0.1, green: 0.1, blue: 0.1)
                        }
                    }
                )
                .cornerRadius(100) // Pill-shaped
                .overlay(
                    RoundedRectangle(cornerRadius: 100)
                        .stroke(isSelected ? Color.clear : Color.white.opacity(0.05), lineWidth: 1)
                )
                .shadow(color: isSelected ? .brandPrimary.opacity(0.4) : .clear, radius: 8, x: 0, y: 0)
        }
    }
}

extension ExportMonth {
    var shortName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yy"
        return formatter.string(from: date)
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

extension Color {
    static let brandPrimary = Color(red: 0.34, green: 0.82, blue: 0.88)
    static let brandSecondary = Color(red: 0.56, green: 0.58, blue: 1.0)
    static let cardBackground = Color(red: 0.12, green: 0.12, blue: 0.14)
    static let secondaryText = Color(red: 0.6, green: 0.6, blue: 0.6)
}

extension LinearGradient {
    static let brandGradient = LinearGradient(
        gradient: Gradient(colors: [.brandPrimary, .brandSecondary]),
        startPoint: .leading,
        endPoint: .trailing
    )
}
