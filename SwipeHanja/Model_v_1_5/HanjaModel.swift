//
//  HanjaModel.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 12/21/24.
//
import Foundation

///스프레드시트 JSON 디코딩 모델
struct HanjaModel: Codable, Hashable {
    ///한자 글자 고유 ID
    let _id: UUID
    ///한자 급수
    let level: Decimal
    ///한자 급수내 순서
    let index: Int
    ///한자 글자
    let character: String
    ///한자 정의(음과 뜻)
    let definition: String
    ///한자 총획수
    let strokeCount: String
    ///한자 부수
    let radical: String
    ///한자 부수 정의(음과뜻)
    let radicalDefinition: String

}
