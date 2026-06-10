import SwiftUI
import ClauchiCore

struct ToastView: View {
    let toast: ToastPresenter.Toast
    let onTap: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            if let grid = SpriteLibrary.spriteSet(for: toast.species, stage: toast.stage)
                .large[toast.expression] {
                Image(nsImage: SpriteImageFactory.image(
                    for: grid,
                    cacheKey: "L-\(toast.species.rawValue)-\(toast.stage.rawValue)-\(toast.expression.rawValue)"))
                    .resizable()
                    .interpolation(.none)
                    .frame(width: 48, height: 48)
            }
            Text(toast.text)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.white)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
        }
        .padding(14)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            UnevenRoundedRectangle(bottomLeadingRadius: 18, bottomTrailingRadius: 18)
                .fill(Color.black))
        .onTapGesture(perform: onTap)
    }
}
