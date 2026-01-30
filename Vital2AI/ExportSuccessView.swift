import SwiftUI

struct ExportSuccessView: View {
    let shareURLs: [URL]
    @State private var showingShareSheet = false
    @State private var showingCopyFeedback = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 32) {
                    successHeader
                        .padding(.top, -10)
                    actionButtons
                    instructionsSection
                }
            }

            if showingCopyFeedback {
                copyFeedbackOverlay
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(activityItems: shareURLs)
        }
        .onDisappear {
            CSVManager.cleanupTemporaryFiles(urls: shareURLs)
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .background {
                CSVManager.cleanupTemporaryFiles(urls: shareURLs)
                dismiss()
            }
        }
    }

    private var successHeader: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [.brandPrimary.opacity(0.8), .brandSecondary.opacity(0.8)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 4
                    )
                    .frame(width: 80, height: 80)

                VStack {
                    Image(systemName: "checkmark")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.black)
                        .frame(width: 50, height: 50)
                        .background(LinearGradient.brandGradient)
                        .clipShape(Circle())
                        .shadow(color: .brandPrimary.opacity(0.4), radius: 10, x: 0, y: 0)
                }
            }

            Text("success_title")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            Text("success_subtitle")
                .font(.system(size: 16))
                .foregroundColor(.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
    }

    private var actionButtons: some View {
        Button(action: { showingShareSheet = true }) {
            HStack(spacing: 8) {
                Image(systemName: "square.and.arrow.down")
                Text("success_download_button")
            }
            .font(.system(size: 15, weight: .bold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(LinearGradient.brandGradient)
            .cornerRadius(12)
            .shadow(color: .brandPrimary.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .padding(.horizontal)
    }

    private var instructionsSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.brandPrimary.opacity(0.1))
                        .frame(width: 36, height: 36)

                    Image(systemName: "sparkles")
                        .foregroundColor(.brandPrimary)
                        .font(.system(size: 18))
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("success_how_to_title")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)

                    Text("success_how_to_subtitle")
                        .font(.system(size: 13))
                        .foregroundColor(.secondaryText)
                }
            }

            VStack(spacing: 24) {
                StepRow(number: "1", title: "success_step_1_title", description: "success_step_1_desc")
                StepRow(number: "2", title: "success_step_2_title", description: "success_step_2_desc")
                StepRow(number: "3", title: "success_step_3_title", description: "success_step_3_desc")
            }

            recommendedPromptBox

            Text("ai_accuracy_disclaimer")
                .font(.system(size: 13))
                .foregroundColor(.secondaryText)
                .padding(.horizontal, 4)
        }
        .padding(24)
        .background(Color.cardBackground.opacity(0.5))
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
        .padding(.horizontal)
        .padding(.bottom, 40)
    }

    private var recommendedPromptBox: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("success_recommended_prompt_title")
                    .font(.system(size: 11, weight: .bold))
                    .tracking(0.5)
                    .foregroundColor(.secondaryText)

                Spacer()

                Button(action: copyPrompt) {
                    HStack(spacing: 4) {
                        Image(systemName: "doc.on.doc")
                        Text("success_copy_snippet")
                    }
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.brandPrimary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white.opacity(0.03))

            Text(String(localized: "success_llm_prompt_content"))
                .font(.system(size: 14, weight: .medium))
                .italic()
                .lineSpacing(6)
                .foregroundColor(.white.opacity(0.8))
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.black.opacity(0.3))
        }
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
    }

    private var copyFeedbackOverlay: some View {
        VStack {
            Spacer()
            Text("Copied!")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.black)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.brandPrimary)
                .cornerRadius(20)
                .padding(.bottom, 50)
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                Text("Done")
            }
            .foregroundColor(.brandPrimary)
        }
    }

    private func copyPrompt() {
        UIPasteboard.general.string = String(localized: "success_llm_prompt_content")
        withAnimation {
            showingCopyFeedback = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showingCopyFeedback = false
            }
        }
    }
}

struct StepRow: View {
    let number: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.05))
                    .frame(width: 24, height: 24)

                Text(number)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.brandPrimary)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(LocalizedStringKey(title))
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)

                Text(LocalizedStringKey(description))
                    .font(.system(size: 13))
                    .foregroundColor(.secondaryText)
                    .lineLimit(nil)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    NavigationStack {
        ExportSuccessView(shareURLs: [])
    }
}
