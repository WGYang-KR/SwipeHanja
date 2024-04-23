//
//  KolodaCardStorage.swift
//  Pods
//
//  Created by Eugene Andreyev on 3/30/16.
//
//

import Foundation
import UIKit

extension KolodaView {
    
    func createCard(at index: Int, frame: CGRect? = nil) -> DraggableCardView {
        let cardView = generateCard(frame ?? frameForTopCard())
        configureCard(cardView, at: index)
        
        return cardView
    }
    
    func generateCard(_ frame: CGRect) -> DraggableCardView {
        let cardView = DraggableCardView(frame: frame)
        cardView.delegate = self
        
        return cardView
    }
    
    func configureCard(_ card: DraggableCardView, at index: Int) {
        let contentView = dataSource!.koloda(self, viewForCardAt: index)
        let backContentView = dataSource!.koloda(self, backViewForCardAt: index)
        //TODO: Default 카드방향 설정
        card.configure(contentView, backContentView: backContentView, overlayView: dataSource?.koloda(self, viewForCardOverlayAt: index), defaultPosition: .front)

        //Reconfigure drag animation constants from Koloda instance.
        if let rotationMax = self.rotationMax {
            card.rotationMax = rotationMax
        }
        if let rotationAngle = self.rotationAngle {
            card.rotationAngle = rotationAngle
        }
        if let scaleMin = self.scaleMin {
            card.scaleMin = scaleMin
        }
    }
    
}
