//
//  YoutubeSearchResponse.swift
//  Movio
//
//  Created by iMac on 07/03/2024.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}


struct VideoElement: Codable {
    let id: IdVideoElement
}


struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}

/*
 items =     (
             {
         etag = "hRDnezx4LRSTgVpV-pRPp6iUe5o";
         id =             {
             channelId = "UChPRO1CB_Hvd0TvKRU62iSQ";
             kind = "youtube#channel";
         };
         kind = "youtube#searchResult";
     },
 */
