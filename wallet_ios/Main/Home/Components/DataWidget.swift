//
//  DataWidget.swift
//  mPayAppHaha
//
//  Created by Appiness on 28/11/25.
//

import SwiftUI

struct DataWidget: View {
    
    var body: some View {
        ZStack {
            StockLikeBackgroundShape()
                .fill(Color(red: 1, green: 1, blue: 1))
                .overlay(
                    StockLikeBackgroundShape()
                        .stroke(Color(red: 0.61, green: 0.82, blue: 1.0).opacity(0.9), lineWidth: 12)
                        .blur(radius: 12)
                        .mask(StockLikeBackgroundShape())
                        .mask(
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: .white, location: 0.0),  // fully visible at top
                                    .init(color: .white.opacity(0.0), location: 1.0) // fades out quickly
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .mask(StockLikeBackgroundShape()) // also keep it inside the shape
                        )
                )
                .frame(height: 180)   // 👈 important!
                .clipShape(RoundedRectangle(cornerRadius: 20))


					VStack(alignment: .leading, spacing: 4) {

						Text("Portfolio")
							.font(.headline)

						Text("$12,487.22")
							.font(.title.bold())

					}
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(16)


        }
        
    }
    
    struct Constants {
      static let SceneL5: Color = Color(red: 1, green: 1, blue: 0.99)
    }
}

#Preview {
    DataWidget()
}

