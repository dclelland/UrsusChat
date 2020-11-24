//
//  GraphViewApp.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 24/11/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Alamofire
import UrsusAirlock

extension Airlock {
    
    func graphView(ship: Ship) -> GraphViewApp {
        return app(ship: ship, app: "graph-view-action")
    }
    
}

class GraphViewApp: AirlockApp {
    
    #warning("TODO: Finish GraphViewApp")
    
//    private viewAction(threadName: string, action: any) {
//      return this.spider('graph-view-action', 'json', threadName, action);
//    }
    
//    createManagedGraph(
//      name: string,
//      title: string,
//      description: string,
//      group: Path,
//      mod: string
//    ) {
//      const associated = { group: resourceFromPath(group) };
//      const resource = makeResource(`~${window.ship}`, name);
//
//      return this.viewAction('graph-create', {
//        "create": {
//          resource,
//          title,
//          description,
//          associated,
//          "module": mod,
//          mark: moduleToMark(mod)
//        }
//      });
//    }

//    createUnmanagedGraph(
//      name: string,
//      title: string,
//      description: string,
//      policy: Enc<GroupPolicy>,
//      mod: string
//    ) {
//      const resource = makeResource(`~${window.ship}`, name);
//
//      return this.viewAction('graph-create', {
//        "create": {
//          resource,
//          title,
//          description,
//          associated: { policy },
//          "module": mod,
//          mark: moduleToMark(mod)
//        }
//      });
//    }

//    joinGraph(ship: Patp, name: string) {
//      const resource = makeResource(ship, name);
//      return this.viewAction('graph-join', {
//        join: {
//          resource,
//          ship,
//        }
//      });
//    }

//    deleteGraph(name: string) {
//      const resource = makeResource(`~${window.ship}`, name);
//      return this.viewAction('graph-delete', {
//        "delete": {
//          resource
//        }
//      });
//    }

//    leaveGraph(ship: Patp, name: string) {
//      const resource = makeResource(ship, name);
//      return this.viewAction('graph-leave', {
//        "leave": {
//          resource
//        }
//      });
//    }

//    groupifyGraph(ship: Patp, name: string, toPath?: string) {
//      const resource = makeResource(ship, name);
//      const to = toPath && resourceFromPath(toPath);
//
//      return this.viewAction('graph-groupify', {
//        groupify: {
//          resource,
//          to
//        }
//      });
//    }
    
}
