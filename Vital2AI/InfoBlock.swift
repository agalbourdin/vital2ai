import SwiftUI

struct InfoBlock: View {
    var icon: String? = nil
    let title: LocalizedStringKey
    let description: LocalizedStringKey
    var color: Color = .brandPrimary
    var borderColor: Color? = nil
    var backgroundColor: Color? = nil
    var action: (() -> Void)? = nil
    var actionLabel: LocalizedStringKey? = nil
    var customActionLabelColor: Color? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: icon != nil ? 16 : 0) {
                if let icon = icon {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(color.opacity(0.15))
                            .frame(width: 44, height: 44)

                        Image(systemName: icon)
                            .foregroundColor(color)
                            .font(.system(size: 20))
                    }
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)

                    Text(description)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.8))
                        .lineSpacing(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            if let action = action, let label = actionLabel {
                Button(action: action) {
                    HStack {
                        Text(label)
                            .font(.system(size: 13, weight: .semibold))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 10, weight: .bold))
                    }
                    .foregroundColor(customActionLabelColor ?? color)
                    .padding(.top, 4)
                }
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(backgroundColor ?? Color(red: 19/255, green: 18/255, blue: 30/255))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(borderColor ?? color.opacity(0.2), lineWidth: 1.5)
        )
    }
}
