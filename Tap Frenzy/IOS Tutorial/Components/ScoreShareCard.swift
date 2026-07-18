//
//  ScoreShareCard.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-08.
//

import SwiftUI
import UIKit

struct ScoreShareData{
    let mode: GameMode
    let score: Int
    let headline: String
    let stageLevel: Int?
    let starsEarned: Int?
    let worldTitle: String?
    let subtitle: String?
    
    var shareCaption: String{
        if let stageLevel, let starsEarned {
            return Const.txtIErned + " \(starsEarned) " + Const.txtStarOn + " \(mode.title) " + Const.txtLevel + " \(stageLevel) " + Const.txtWith + " \(score) " + Const.txtPtsInNeonArc
        }
        return Const.txtIScored + " \(score) " + Const.txtOn + " \(mode.rawValue) " + Const.txtInNeonArc
    }
}

struct ScoreShareCardView: View {
    
    let data: ScoreShareData
    
    private var accent: Color{
        switch data.mode{
        case .tapFrenzy: return .yellow
        case .lightItUp: return .neonBlue
        case .quizRush: return .neonPurple
        }
    }
    
    var body: some View {
        ZStack{
            Color(red: 0.05, green: 0.05, blue: 0.10)
            
            LinearGradient(
                colors: [
                    accent.opacity(0.18),
                    Color(red: 0.03, green: 0.05, blue: 0.12),
                    Color.black
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 0){
                Text(Const.txtHomeTitle)
                    .font(.system(size: 13, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(colors:[.neonBlue, .neonPurple], startPoint: .leading, endPoint: .trailing)
                    )
                    .tracking(2)
                    .padding(.top, 32)
                
                Spacer().frame(height: 20)
                
                ZStack{
                    
                    Circle()
                        .fill(accent.opacity(0.2))
                        .frame(width: 88, height: 88)
                    Image(systemName: data.mode.icon)
                        .font(.system(size: 36, weight: .semibold))
                        .foregroundStyle(accent)
                }
                
                Spacer().frame(height: 14)
                
                Text(data.mode.title)
                    .font(.title3.bold())
                    .foregroundColor(.white)
                
                if let stageLevel = data.stageLevel{
                    Text(Const.txtLevel.capitalized + " \(stageLevel)" + (data.worldTitle.map { " . \($0)"} ?? ""))
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.65))
                        .padding(.top, 4)
                }
                
                Spacer().frame(height: 16)
                
                Text(data.headline.uppercased())
                    .font(.caption2.bold())
                    .foregroundColor(accent)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(accent.opacity(0.18)))
                
                Spacer().frame(height: 18)
                
                Text("\(data.score)")
                    .font(.system(size:64, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
                
                Text(Const.txtPoints.uppercased())
                    .font(.caption2.bold())
                    .foregroundColor(.white.opacity(0.45))
                    .tracking(2)
                    .padding(.top, 2)
                
                if let stars = data.starsEarned{
                    StarRatingView(stars: stars, size: 22)
                        .padding(.top, 14)
                }
                
                if let subtitle = data.subtitle, !subtitle.isEmpty{
                    Text(subtitle)
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.5))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .padding(.horizontal, 24)
                        .padding(.top,10)
                }
                
                Spacer()
                
                Text(Const.txtShareCardFooter)
                    .font(.caption2.bold())
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.bottom, 28)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: 400, height: 560)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay{
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(accent.opacity(0.45), lineWidth: 2)
        }
        .preferredColorScheme(.dark)
    }
    
}

@MainActor
enum ScoreShareRenderer {
    static func makeImage(for data: ScoreShareData) -> UIImage? {
        let card = ScoreShareCardView(data: data)
        let renderer = ImageRenderer(content: card)
        renderer.scale = 2.0
        renderer.proposedSize = ProposedViewSize(width:400, height: 560)
        return renderer.uiImage
    }
    
}

@MainActor
enum SharePresenter {
    static func present(items:[Any]){
        guard
            let scene = UIApplication.shared.connectedScenes.compactMap({$0 as? UIWindowScene}).first,
            let window = scene.windows.first(where: \.isKeyWindow),
            let root = window.rootViewController
        else { return }
        
        var presenter = root
        while let presented = presenter.presentedViewController {
            presenter = presented
        }
        
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        if let popover = controller.popoverPresentationController {
            popover.sourceView = presenter.view
            popover.sourceRect = CGRect(
                x: presenter.view.bounds.midX,
                y: presenter.view.bounds.midY,
                width: 1,
                height: 1
            )
            popover.permittedArrowDirections = []
        }
        presenter.present(controller, animated: true)
    }
}

enum ResultButtonStyle {
    case primary
    case secondary
    case share
}

struct ResultActionButton : View {
    let title: String
    let icon: String
    var style: ResultButtonStyle = .primary
    let action: () -> Void
                 
    var body: some View {
        Button{
            AudioManager.shared.playSFX(.button)
            action()
        } label: {
            Label(title, systemImage: icon)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(background)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private var background: some View {
        switch style {
        case .primary:
            LinearGradient(colors: [.neonGreen, .neonBlue], startPoint: .leading, endPoint: .trailing)
        case .secondary:
            LinearGradient(colors: [.neonBlue, .neonPurple], startPoint: .leading, endPoint: .trailing)
        case .share:
            LinearGradient(colors: [.neonPurple, .neonPink], startPoint: .leading, endPoint: .trailing)
        }
    }
}

struct ShareScoreButton: View {
    let data: ScoreShareData
    var compact: Bool = false
    
    var body: some View {
        ResultActionButton(
            title: compact ? Const.txtShare : Const.txtShareScore,
            icon: Const.squareAndArrowIcon,
            style: .share
        ){
            guard let image = ScoreShareRenderer.makeImage(for: data) else { return }
            SharePresenter.present(items: [image, data.shareCaption])
        }
    }
}

#Preview {
    ScoreShareCardView(
        data: ScoreShareData(
            mode: .tapFrenzy,
            score: 42,
            headline: Const.txtLevelCompleted.uppercased(),
            stageLevel: 3,
            starsEarned: 4,
            worldTitle: Const.sunsetArena,
            subtitle: Const.comboZone,
            )
        )
    .padding()
}
