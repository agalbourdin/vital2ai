import SwiftUI

struct InfoView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showPrivacyPolicy = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        InfoBlock(
                            title: "app_info_title",
                            description: "app_info_description",
                            color: .gray,
                            borderColor: .white.opacity(0.1),
                            backgroundColor: .white.opacity(0.05),
                            action: {
                                if let url = URL(string: "https://github.com/agalbourdin/vital2ai") {
                                    UIApplication.shared.open(url)
                                }
                            },
                            actionLabel: "view_on_github",
                            customActionLabelColor: .white
                        )

                        InfoBlock(
                            icon: "lock.fill",
                            title: "privacy_first",
                            description: "privacy_description",
                            color: .blue,
                            action: { showPrivacyPolicy = true },
                            actionLabel: "read_privacy_policy"
                        )

                        InfoBlock(
                            icon: "exclamationmark.shield.fill",
                            title: "ai_privacy_warning_title",
                            description: "ai_privacy_warning_description",
                            color: Color(red: 0.9, green: 0.7, blue: 0.0), // Dark Yellow
                            backgroundColor: Color(red: 0.12, green: 0.1, blue: 0.02) // Light Dark Yellow
                        )

                        InfoBlock(
                            icon: "exclamationmark.triangle.fill",
                            title: "medical_disclaimer_title",
                            description: "medical_disclaimer_description",
                            color: Color(red: 0.8, green: 0.2, blue: 0.2), // Dark Red
                            backgroundColor: Color(red: 0.12, green: 0.05, blue: 0.05) // Light Dark Red
                        )
                    }
                    .padding(20)
                }
            }
            .navigationTitle("information_title")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.brandPrimary)
                }
            }
            .sheet(isPresented: $showPrivacyPolicy) {
                PrivacyPolicyView()
            }
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    InfoView()
}
