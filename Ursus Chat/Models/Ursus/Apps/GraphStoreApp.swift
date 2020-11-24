//
//  GraphStoreApp.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 24/11/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Alamofire
import UrsusAirlock

extension Airlock {
    
    func graphStore(ship: Ship) -> GraphStoreApp {
        return app(ship: ship, app: "graph-store")
    }
    
}

class GraphStoreApp: AirlockApp {
    
    @discardableResult func keysSubscribeRequest(handler: @escaping (SubscribeEvent<Result<SubscribeResponse, Error>>) -> Void) -> DataRequest {
        return subscribeRequest(path: "/keys", handler: handler)
    }
    
//    private storeAction(action: any): Promise<any> {
//      return this.action('graph-store', 'graph-update', action)
//    }
    
//    addGraph(ship: Patp, name: string, graph: any, mark: any) {
//      return this.storeAction({
//        'add-graph': {
//          resource: { ship, name },
//          graph,
//          mark
//        }
//      });
//    }
    
//    getKeys() {
//      return this.scry<any>('graph-store', '/keys')
//        .then((keys) => {
//          this.store.handleEvent({
//            data: keys
//          });
//        });
//    }

//    getTags() {
//      return this.scry<any>('graph-store', '/tags')
//        .then((tags) => {
//          this.store.handleEvent({
//            data: tags
//          });
//        });
//    }

//    getTagQueries() {
//      return this.scry<any>('graph-store', '/tag-queries')
//        .then((tagQueries) => {
//          this.store.handleEvent({
//            data: tagQueries
//          });
//        });
//    }

//    getGraph(ship: string, resource: string) {
//      return this.scry<any>('graph-store', `/graph/${ship}/${resource}`)
//        .then((graph) => {
//          this.store.handleEvent({
//            data: graph
//          });
//        });
//    }

//    getGraphSubset(ship: string, resource: string, start: string, end: string) {
//      return this.scry<any>(
//        'graph-store',
//        `/graph-subset/${ship}/${resource}/${end}/${start}`
//      ).then((subset) => {
//        this.store.handleEvent({
//          data: subset
//        });
//      });
//    }

//    getNode(ship: string, resource: string, index: string) {
//      const idx = index.split('/').map(numToUd).join('/');
//      return this.scry<any>(
//        'graph-store',
//        `/node/${ship}/${resource}${idx}`
//      ).then((node) => {
//        this.store.handleEvent({
//          data: node
//        });
//      });
//    }
    
}

extension GraphStoreApp {
    
    enum SubscribeResponse: Decodable {
        
        case graphUpdate(GraphUpdate)
        
        enum CodingKeys: String, CodingKey {
            
            case graphUpdate = "graph-update"
            
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            switch Set(container.allKeys) {
            case [.graphUpdate]:
                self = .graphUpdate(try container.decode(GraphUpdate.self, forKey: .graphUpdate))
            default:
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
            }
        }
        
    }
    
}

/*
import BaseApi from './base';
import { StoreState } from '../store/type';
import { Patp, Path, PatpNoSig } from '~/types/noun';
import _ from 'lodash';
import {makeResource, resourceFromPath} from '../lib/group';
import {GroupPolicy, Enc, Post, NodeMap, Content} from '~/types';
import { numToUd, unixToDa } from '~/logic/lib/util';

export const createBlankNodeWithChildPost = (
  parentIndex: string = '',
  childIndex: string = '',
  contents: Content[]
) => {
  const date = unixToDa(Date.now()).toString();
  const nodeIndex = parentIndex + '/' + date;

  const childGraph = {};
  childGraph[childIndex] = {
    post: {
      author: `~${window.ship}`,
      index: nodeIndex + '/' + childIndex,
      'time-sent': Date.now(),
      contents,
      hash: null,
      signatures: []
    },
    children: { empty: null }
  };

  return {
    post: {
      author: `~${window.ship}`,
      index: nodeIndex,
      'time-sent': Date.now(),
      contents: [],
      hash: null,
      signatures: []
    },
    children: {
      graph: childGraph
    }
  };
};

export const createPost = (
  contents: Content[],
  parentIndex: string = '',
  childIndex:string = 'DATE_PLACEHOLDER'
) => {
  if (childIndex === 'DATE_PLACEHOLDER') {
    childIndex = unixToDa(Date.now()).toString();
  }
  return {
    author: `~${window.ship}`,
    index: parentIndex + '/' + childIndex,
    'time-sent': Date.now(),
    contents,
    hash: null,
    signatures: []
  };
};

function moduleToMark(mod: string): string | undefined {
  if(mod === 'link') {
    return 'graph-validator-link';
  }
  if(mod === 'publish') {
    return 'graph-validator-publish';
  }
  return undefined;
}
*/
