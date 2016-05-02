//
//  HODResponseObjects.swift
//  Response predefined objects
//
//  Created by Van Phong Vu on 10/1/15.
//  Copyright (c) 2015 Van Phong Vu. All rights reserved.
//

import Foundation

public class HODErrorObject:NSObject
{
    public var error:Int = 0
    public var reason:String = ""
    public var detail:String = ""
    public var jobID:String = ""
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                self.setValue(value, forKey: keyName)
            }
        }
    }
}

/************************************************************/
 //////////////////////////////////////////////////////////////
 /************************************************************/
public class SpeechRecognitionResponse : NSObject{
    public var document:NSMutableArray = [] // Document
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "document" {
                    for item in keyValue {
                        let p = Document(json: item as! NSDictionary)
                        self.document.addObject(p)
                    }
                }
            }
        }
    }
    public class Document:NSObject {
        public var offset:Int64 = 0
        public var content:String = ""
        public var confidence:Int = 0
        public var duration:Int = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////

/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class CancelConnectorScheduleResponse:NSObject {
    public var connector: String = ""
    public var stopped_schedule: Bool = false
    
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let v = checkValue(value) {
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(v, forKey: keyName)
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////

/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class ConnectorHistoryResponse:NSObject {
    public var history:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "history" {
                    for item in keyValue {
                        let p = History(json: item as! NSDictionary)
                        self.history.addObject(p)
                    }
                }
            }
        }
    }
    public class History:NSObject
    {
        public var connector: String = ""
        public var document_counts: Document_counts?
        public var error:String = ""
        public var failed:String = ""
        public var process_end_time: String = ""
        public var process_start_time: String = ""
        public var start_time: String = ""
        public var queued_time: String = ""
        public var status: String = ""
        public var time_in_queue: Double = 0
        public var time_processing: Double = 0
        public var token: String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.document_counts = Document_counts(json:keyValue)
                    }
                } else {
                    if let v = checkValue(value) {
                        if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                            self.setValue(v, forKey: keyName)
                        }
                    }
                }
            }
        }
    }
    public class Document_counts:NSObject {
        public var added: Int = 0
        public var deleted: Int = 0
        public var errors: Int = 0
        public var ingest_added: Int = 0
        public var ingest_deleted: Int = 0
        public var ingest_failed: Int = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    
}
//////////////////////----------------////////////////////////

/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class ConnectorStatusResponse:NSObject {
    public var connector: String = ""
    public var status: String = ""
    public var document_counts: Document_counts?
    public var error: String = ""
    public var failed: String = ""
    public var process_end_time: String = ""
    public var process_start_time: String = ""
    public var start_time: String = ""
    public var queued_time: String = ""
    public var time_in_queue: Int64 = 0
    public var time_processing: Int64 = 0
    public var token: String = ""
    public var schedule: Schedule?
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSDictionary {
                let keyValue:NSDictionary = (value as? NSDictionary)!
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    if keyName == "document_counts" {
                        self.document_counts = Document_counts(json:keyValue)
                    } else if keyName == "schedule" {
                        self.schedule = Schedule(json:keyValue)
                    }
                }
            } else {
                if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    public class Document_counts:NSObject
    {
        public var added: Int = 0
        public var deleted: Int = 0
        public var errors: Int = 0
        public var ingest_added: Int = 0
        public var ingest_deleted: Int = 0
        public var ingest_failed: Int = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    public class Schedule:NSObject
    {
        public var last_run_time: String = ""
        public var next_run_time: String = ""
        public var occurrences_remaining: Double = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////

/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class CreateConnectorResponse:NSObject {
    public var connector: String = ""
    public var download_link: Download_link?
    public var message: String = ""
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSDictionary {
                let keyValue:NSDictionary = (value as? NSDictionary)!
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    if keyName == "download_link" {
                        self.download_link = Download_link(json:keyValue)
                    }
                }
            } else {
                if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    public class Download_link:NSObject
    {
        public var linux_x86: String = ""
        public var linux_x86_64: String = ""
        public var windows_x86: String = ""
        public var windows_x86_64: String = ""
        
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////

/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class DeleteConnectorResponse:NSObject {
    public var connector: String = ""
    public var deleted: Bool = false
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let v = checkValue(value) {
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(v, forKey: keyName)
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class RetrieveConnectorConfigurationFileResponse:NSObject {
    public var name: String = ""
    public var flavor: String = ""
    public var config: String = ""
    public var licenseKey: String = ""
    public var validation: String = ""
    public var verification: String = ""
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let v = checkValue(value) {
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(v, forKey: keyName)
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////

// Solved the description conflict by changing it to _description
/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class RetrieveConnectorConfigurationAttrResponse:NSObject {
    public var name: String = ""
    public var flavor: String = ""
    public var config: Config!
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSDictionary {
                let keyValue:NSDictionary = (value as? NSDictionary)!
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    if keyName == "config" {
                        self.config = Config(json:keyValue)
                    }
                }
            } else {
                if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    public class Config:NSObject
    {
        public var config:ConfigObj!
        public var destination:DestinationObj!
        public var schedule:ScheduleObj!
        public var credentials:CredentialsObj!
        public var credentials_policy:CredentialsPolicy!
        public var _description:String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                var keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        if keyName == "config" {
                            self.config = ConfigObj(json:keyValue)
                        } else if keyName == "destination" {
                            self.destination = DestinationObj(json:keyValue)
                        } else if keyName == "schedule" {
                            self.schedule = ScheduleObj(json:keyValue)
                        } else if keyName == "credentials" {
                            self.credentials = CredentialsObj(json:keyValue)
                        } else if keyName == "credentials_policy" {
                            self.credentials_policy = CredentialsPolicy(json:keyValue)
                        }
                    }
                } else {
                    if keyName == "description" {
                        keyName = "_description"
                    }
                    if let v = checkValue(value) {
                        if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                            self.setValue(v, forKey: keyName)
                        }
                    }
                }
            }
        }
    }
    
    public class ConfigObj:NSObject
    {
        public var url:String = ""
        public var max_pages:Int64 = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    public class DestinationObj:NSObject
    {
        public var action:String = ""
        public var index:String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    public class ScheduleObj:NSObject
    {
        public var frequency:FrequencyObj!
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        if keyName == "frequency" {
                            self.frequency = FrequencyObj(json:keyValue)
                        }
                    }
                }
            }
        }
        public class FrequencyObj:NSObject
        {
            public var frequency_type:String = ""
            public var interval:Int64 = 0
            init(json:NSDictionary) {
                super.init()
                for (key, value) in json {
                    let keyName:String = (key as? String)!
                    if let v = checkValue(value) {
                        if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                            self.setValue(v, forKey: keyName)
                        }
                    }
                }
            }
        }
    }
    public class CredentialsObj:NSObject
    {
        public var login_value:String = ""
        public var password_value:String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    
    public class CredentialsPolicy:NSObject
    {
        public var notification_email:String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class StartConnectorResponse:NSObject {
    public var connector: String = ""
    public var token: String = ""
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let v = checkValue(value) {
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(v, forKey: keyName)
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////

/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class StopConnectorResponse:NSObject {
    public var connector: String = ""
    public var message: String = ""
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let v = checkValue(value) {
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(v, forKey: keyName)
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////

/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class UpdateConnectorResponse:NSObject {
    public var connector: String = ""
    public var message: String = ""
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let v = checkValue(value) {
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(v, forKey: keyName)
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////

/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class ExpandContainerResponse:NSObject {
    public var files:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "files" {
                    for item in keyValue {
                        let p = Files(json: item as! NSDictionary)
                        self.files.addObject(p)
                    }
                }
            }
        }
    }
    public class Files:NSObject
    {
        public var name: String = ""
        public var reference: String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////

/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class StoreObjectResponse:NSObject {
    public var reference: String = ""
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let v = checkValue(value) {
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(v, forKey: keyName)
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////

/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class ViewDocumentResponse:NSObject {
    public var document: String = ""
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let v = checkValue(value) {
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(v, forKey: keyName)
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
public class GetCommonNeighborsResponse:NSObject
{
    public var nodes:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "nodes" {
                    for item in keyValue {
                        let p = Nodes(json: item as! NSDictionary)
                        self.nodes.addObject(p)
                    }
                }
            }
        }
    }
    
    public class Nodes:NSObject
    {
        public var attributes:Attributes!
        public var id:Int64 = 0
        public var commonality: Int64 = 0
        public var sort_value:Int = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.attributes = Attributes(json:keyValue)
                    }
                } else {
                    if let v = checkValue(value) {
                        if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                            self.setValue(v, forKey: keyName)
                        }
                    }
                }
            }
        }
    }
    public class Attributes:NSObject
    {
        public var name: String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
public class GetNeighborsResponse:NSObject
{
    public var neighbors:NSMutableArray = [] //(array[Neighbors] , optional)
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "neighbors" {
                    for item in keyValue {
                        let p = Neighbors(json: item as! NSDictionary)
                        self.neighbors.addObject(p)
                    }
                }
            }
        }
    }
    public class Neighbors:NSObject
    {
        public var target: TargetOrSource!
        public var source: TargetOrSource!
        public var nodes:NSMutableArray = [] //(array[Nodes] )
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        if keyName == target {
                            self.target = TargetOrSource(json:keyValue)
                        } else if keyName == source {
                            self.source = TargetOrSource(json:keyValue)
                        }
                    }
                } else if let _ = value as? NSArray {
                    let keyValue:NSArray = (value as? NSArray)!
                    if keyName == "nodes" {
                        for item in keyValue {
                            let p = Nodes(json: item as! NSDictionary)
                            self.nodes.addObject(p)
                        }
                    }
                }
            }
        }
    }
    
    public class Nodes:NSObject
    {
        public var attributes: Attributes!
        public var id: Int64 = 0 //(integer )  Node ID
        public var sort_value: Double = 0.0 //(number , optional)
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.attributes = Attributes(json:keyValue)
                    }
                } else {
                    if let v = checkValue(value) {
                        if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                            self.setValue(v, forKey: keyName)
                        }
                    }
                }
            }
        }
    }
    public class Attributes:NSObject
    {
        public var name: String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    public class TargetOrSource:NSObject
    {
        public var id: Int64 = 0
        public var attributes: Attributes!
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.attributes = Attributes(json:keyValue)
                    }
                } else {
                    if let v = checkValue(value) {
                        if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                            self.setValue(v, forKey: keyName)
                        }
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
public class GetNodesResponse:NSObject
{
    public var nodes: NSMutableArray = [] //(array[Nodes] )
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "nodes" {
                    for item in keyValue {
                        let p = Nodes(json: item as! NSDictionary)
                        self.nodes.addObject(p)
                    }
                }
            }
        }
    }
    public class Nodes:NSObject
    {
        public var attributes: Attributes!
        public var id: Int64 = 0 //(integer )  Node ID
        public var sort_value: Double = 0.0 //(number , optional)
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.attributes = Attributes(json:keyValue)
                    }
                } else {
                    if let v = checkValue(value) {
                        if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                            self.setValue(v, forKey: keyName)
                        }
                    }
                }
            }
        }
    }
    public class Attributes:NSObject
    {
        public var name: String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
public class GetShortestPathResponse:NSObject
{
    public var edges: NSMutableArray = []
    public var nodes: NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "nodes" {
                    for item in keyValue {
                        let p = Nodes(json: item as! NSDictionary)
                        self.nodes.addObject(p)
                    }
                } else if keyName == "edges" {
                    for item in keyValue {
                        let p = Edges(json: item as! NSDictionary)
                        self.edges.addObject(p)
                    }
                }
            }
        }
    }
    public class Edges:NSObject
    {
        public var attributes: Attributes!
        public var length: Int64 = 0 //(number )  Length/weight/cost of edge.
        public var source: Int64 = 0 //( integer )  Source node ID.
        public var target: Int64 = 0 //( integer )  Target node ID.
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.attributes = Attributes(json:keyValue)
                    }
                } else {
                    if let v = checkValue(value) {
                        if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                            self.setValue(v, forKey: keyName)
                        }
                    }
                }
            }
        }
    }
    
    public class Attributes:NSObject
    {
        public var weight: Double = 0.0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    
    public class Nodes:NSObject
    {
        public var attributes: Attributes!
        public var id: Int64 = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.attributes = Attributes(json:keyValue)
                    }
                } else {
                    if let v = checkValue(value) {
                        if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                            self.setValue(v, forKey: keyName)
                        }
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
public class GetSubgraphResponse:NSObject
{
    public var edges: NSMutableArray = []
    public var nodes: NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "nodes" {
                    for item in keyValue {
                        let p = Nodes(json: item as! NSDictionary)
                        self.nodes.addObject(p)
                    }
                } else if keyName == "edges" {
                    for item in keyValue {
                        let p = Edges(json: item as! NSDictionary)
                        self.edges.addObject(p)
                    }
                }
            }
        }
    }
    
    public class Edges:NSObject
    {
        public var attributes: Attributes!
        public var source: Int64 = 0
        public var target: Int64 = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.attributes = Attributes(json:keyValue)
                    }
                } else if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    
    public class Attributes:NSObject
    {
        public var weight: Double = 0.0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    
    public class Nodes:NSObject
    {
        public var attributes: Attributes!
        public var id: Int64 = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.attributes = Attributes(json:keyValue)
                    }
                } else if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
public class SuggestLinksResponse:NSObject
{
    public var suggestions: NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "suggestions" {
                    for item in keyValue {
                        let p = Suggestions(json: item as! NSDictionary)
                        self.suggestions.addObject(p)
                    }
                }
            }
        }
    }
    
    public class Suggestions:NSObject
    {
        public var source : Source!
        public var nodes:NSMutableArray = []  //(array[Nodes] )
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.source = Source(json:keyValue)
                    }
                } else if let _ = value as? NSArray {
                    let keyValue:NSArray = (value as? NSArray)!
                    if keyName == "nodes" {
                        for item in keyValue {
                            let p = Nodes(json: item as! NSDictionary)
                            self.nodes.addObject(p)
                        }
                    }
                }
            }
        }
    }
    
    public class Source:NSObject
    {
        public var id: Int64 = 0
        public var attributes: Attributes!
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.attributes = Attributes(json:keyValue)
                    }
                } else if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    
    public class Attributes:NSObject
    {
        public var name: String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    
    public class Nodes:NSObject
    {
        public var attributes: Attributes!
        public var id: Int64 = 0
        public var sort_value: Double = 0.0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.attributes = Attributes(json:keyValue)
                    }
                } else if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
public class SummarizeGraphResponse:NSObject
{
    public var attributes: NSMutableArray = []
    public var edges: Int64 = 0
    public var nodes: Int64 = 0
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "attributes" {
                    for item in keyValue {
                        if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                            let c = Attributes(json: item as! NSDictionary)
                            self.attributes.addObject(c)
                        }
                    }
                }
            } else if let v = checkValue(value) {
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(v, forKey: keyName)
                }
            }
        }
    }
    public class Attributes:NSObject
    {
        public var data_type: String = ""
        public var element_type: String = ""
        public var name: String = ""
        public var number: Int64 = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class OCRDocumentResponse:NSObject {
    public var text_block:NSMutableArray = [] // TextBlock
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "text_block" {
                    for item in keyValue {
                        let p = TextBlock(json: item as! NSDictionary)
                        self.text_block.addObject(p)
                    }
                }
            }
        }
    }
    public class TextBlock:NSObject
    {
        public var text:String = ""
        public var left:Int = 0
        public var top:Int = 0
        public var width:Int = 0
        public var height:Int = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class RecognizeBarcodesResponse:NSObject {
    public var barcode:NSMutableArray = [] // Barcode
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "barcode" {
                    for item in keyValue {
                        let p = Barcode(json: item as! NSDictionary)
                        self.barcode.addObject(p)
                    }
                }
            }
        }
    }
    public class Barcode:NSObject
    {
        public var text:String = ""
        public var barcode_type:String = ""
        public var left:Int = 0
        public var top:Int = 0
        public var width:Int = 0
        public var height:Int = 0
        public var additional_information:AdditionalInformation?
        
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.additional_information = AdditionalInformation(json:keyValue)
                    }
                } else if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    public class AdditionalInformation:NSObject
    {
        public var country:String = ""
        
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class RecognizeImagesResponse : NSObject{
    public var object:NSMutableArray = [] // HODObject
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "object" {
                    for item in keyValue {
                        let p = HODObject(json: item as! NSDictionary)
                        self.object.addObject(p)
                    }
                }
            }
        }
    }
    public class HODObject:NSObject {
        public var unique_name:String = ""
        public var name:String = ""
        public var db:String = ""
        public var corners:NSMutableArray = []
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSArray {
                    let keyValue:NSArray = (value as? NSArray)!
                    for item in keyValue {
                        if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                            let c = Corners(json:item as! NSDictionary)
                            self.corners.addObject(c)
                        }
                    }
                } else if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    public class Corners:NSObject {
        public var x:Int = 0
        public var y:Int = 0
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class DetectFacesResponse : NSObject {
    public var face:NSMutableArray = []
    
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "face" {
                    for item in keyValue {
                        let p = Face(json: item as! NSDictionary)
                        self.face.addObject(p)
                    }
                }
            }
        }
    }
    
    public class Face:NSObject {
        public var left:Int = 0
        public var top:Int = 0
        public var width:Int = 0
        public var height:Int = 0
        public var additional_information:AdditionalInformation?
        
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.additional_information = AdditionalInformation(json:keyValue)
                    }
                } else if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    public class AdditionalInformation:NSObject {
        public var age:String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////

/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class PredictResponse:NSObject {
    public var fields:NSMutableArray = []
    public var values:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "fields" {
                    for item in keyValue {
                        let p = Fields(json: item as! NSDictionary)
                        self.fields.addObject(p)
                    }
                } else if keyName == "values" {
                    for item in keyValue {
                        let p = Values(json: item as! NSDictionary)
                        self.values.addObject(p)
                    }
                }
            }
        }
    }
    public class Fields:NSObject
    {
        public var name: String = ""
        public var order: Double = 0
        public var type: String = ""
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    public class Values:NSObject
    {
        public var row:NSMutableArray = []
        init(json : NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSArray {
                    let keyValue:NSArray = (value as? NSArray)!
                    if keyName == "row" {
                        for item in keyValue {
                            let p = item as! String
                            self.row.addObject(p)
                        }
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////

/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class RecommendResponse:NSObject
{
    public var allRecommendations:NSMutableArray = []
    public var fields:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "fields" {
                    for item in keyValue {
                        let p = Fields(json: item as! NSDictionary)
                        self.fields.addObject(p)
                    }
                } else if keyName == "allRecommendations" {
                    for item in keyValue {
                        let p = Allrecommendations(json: item as! NSDictionary)
                        self.allRecommendations.addObject(p)
                    }
                }
            }
        }
    }
    public class Allrecommendations:NSObject
    {
        public var originalValues:NSMutableArray = []
        public var recommendations:NSMutableArray = []
        init(json : NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSArray {
                    let keyValue:NSArray = (value as? NSArray)!
                    if keyName == "originalValues" {
                        for item in keyValue {
                            let p = item as! String
                            self.originalValues.addObject(p)
                        }
                    } else if keyName == "recommendations" {
                        for item in keyValue {
                            let p = Recommendations(json: item as! NSDictionary)
                            self.recommendations.addObject(p)
                        }
                    }
                }
            }
        }
    }
    public class Recommendations:NSObject
    {
        public var confidence:Double = 0
        public var distance:Double = 0
        public var new_prediction:String = ""
        public var recommendation:NSMutableArray = []
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSArray {
                    let keyValue:NSArray = (value as? NSArray)!
                    for item in keyValue {
                        if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                            let c = item as! String
                            self.recommendation.addObject(c)
                        }
                    }
                } else if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    public class Fields:NSObject
    {
        public var name:String = ""
        public var order:Int = 0
        public var type:String = ""
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class TrainPredictorResponse:NSObject
{
    public var message:String = ""
    public var service:String = ""
    init(json: NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let v = checkValue(value) {
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(v, forKey: keyName)
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class CreateQueryProfileResponse:NSObject
{
    public var message:String = ""
    public var query_profile:String = ""
    init(json: NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let v = checkValue(value) {
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(v, forKey: keyName)
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class DeleteQueryProfileResponse:NSObject
{
    public var message:String = ""
    public var query_profile:String = ""
    init(json: NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let v = checkValue(value) {
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(v, forKey: keyName)
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////

// Solved the description conflict by changing it to _description
/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class RetrieveQueryProfileResponse:NSObject
{
    public var query_profile:String = ""
    public var _description:String = ""
    public var query_manipulation_index:String = ""
    public var promotions_enabled:Bool = false
    public var promotion_categories:NSMutableArray = []
    public var promotions_identified:Bool = false
    public var synonyms_enabled:Bool = false
    public var synonym_categories:NSMutableArray = []
    public var blacklists_enabled:Bool = false
    public var blacklist_categories:NSMutableArray = []
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            var keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "promotion_categories" {
                    for item in keyValue {
                        if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                            let c = item as! String
                            self.promotion_categories.addObject(c)
                        }
                    }
                } else if keyName == "synonym_categories" {
                    for item in keyValue {
                        if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                            let c = item as! String
                            self.synonym_categories.addObject(c)
                        }
                    }
                } else if keyName == "blacklist_categories" {
                    for item in keyValue {
                        if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                            let c = item as! String
                            self.blacklist_categories.addObject(c)
                        }
                    }
                }
            } else {
                if let v = checkValue(value) {
                    if keyName == "description" {
                        keyName = "_description"
                    }
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class UpdateQueryProfileResponse:NSObject
{
    public var message:String = ""
    public var query_profile:String = ""
    init(json: NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let v = checkValue(value) {
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(v, forKey: keyName)
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class FindRelatedConceptsResponse:NSObject
{
    public var entities:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "entities" {
                    for item in keyValue {
                        let p = Entities(json: item as! NSDictionary)
                        self.entities.addObject(p)
                    }
                }
            }
        }
    }
    public class Entities:NSObject
    {
        public var cluster:Int64 = 0
        public var docs_with_all_terms:Int64 = 0
        public var docs_with_phrase:Int64 = 0
        public var occurrences:Int64 = 0
        public var text:String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class AutoCompleteResponse:NSObject
{
    public var words:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "words" {
                    for item in keyValue {
                        let p = item as! String
                        self.words.addObject(p)
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class ExtractConceptsResponse:NSObject
{
    public var concepts:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "concepts" {
                    for item in keyValue {
                        let p = Concepts(json: item as! NSDictionary)
                        self.concepts.addObject(p)
                    }
                }
            }
        }
    }
    public class Concepts:NSObject
    {
        public var concept:String = ""
        public var occurrences:Int64 = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class ExpandTermsResponse:NSObject
{
    public var terms:NSMutableArray = [] // ( array[Terms] )  The details of the expanded terms.
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "terms" {
                    for item in keyValue {
                        let p = Terms(json: item as! NSDictionary)
                        self.terms.addObject(p)
                    }
                }
            }
        }
    }
    public class Terms:NSObject
    {
        public var documents:Int64 = 0
        public var term:String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class HighlightTextResponse:NSObject
{
    public var text:String = ""
    init(json: NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let v = checkValue(value) {
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(v, forKey: keyName)
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class IdentifyLanguageResponse:NSObject
{
    public var encoding:String = ""
    public var language:String = ""
    public var language_iso639_2b:String = ""
    public var unicode_scripts:NSMutableArray = []
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "unicode_scripts" {
                    for item in keyValue {
                        if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                            let c = item as! String
                            self.unicode_scripts.addObject(c)
                        }
                    }
                }
            } else if let v = checkValue(value) {
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(v, forKey: keyName)
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////

// Solved the case conflict by changing it to _case
/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class TokenizeTextResponse:NSObject
{
    public var terms:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "terms" {
                    for item in keyValue {
                        let p = Terms(json: item as! NSDictionary)
                        self.terms.addObject(p)
                    }
                }
            }
        }
    }
    public class Terms:NSObject
    {
        public var _case:String = ""
        public var documents:Double = 0
        public var length:Double = 0
        public var numeric:Double = 0
        public var occurrences:Double = 0
        public var start_pos:Double = 0
        public var stop_word :String = ""
        public var term:String = ""
        public var weight:Double = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                if let v = checkValue(value) {
                    var keyName:String = (key as? String)!
                    if keyName == "case" {
                        keyName = "_case"
                    }
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class SentimentAnalysisResponse:NSObject
{
    public var positive:NSMutableArray = []
    public var negative:NSMutableArray = []
    public var aggregate : Aggregate!
    
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "positive" {
                    for item in keyValue {
                        let p = Entity(json: item as! NSDictionary)
                        self.positive.addObject(p)
                    }
                } else if keyName == "negative" {
                    for item in keyValue {
                        let p = Entity(json: item as! NSDictionary)
                        self.negative.addObject(p)
                    }
                }
            } else if let _ = value as? NSDictionary {
                if let keyValue:NSDictionary = (value as? NSDictionary) {
                    if keyName == "aggregate" {
                        if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                            self.aggregate = Aggregate(json:keyValue)
                        }
                    }
                }
            }
        }
    }
    public class Aggregate:NSObject {
        public var sentiment : String = ""
        public var score : Double = 0.0
        
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    public class Entity:NSObject
    {
        public var sentiment:String = ""
        public var topic:String = ""
        public var score:Double = 0.0
        public var original_text:String = ""
        public var original_length:Int = 0
        public var normalized_text:String = ""
        public var normalized_length:Int = 0
        
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class AddToTextIndexResponse:NSObject
{
    public var index:String = ""
    public var references:NSMutableArray = []
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "references" {
                    for item in keyValue {
                        if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                            let c = References(json: item as! NSDictionary)
                            self.references.addObject(c)
                        }
                    }
                }
            } else if let v = checkValue(value) {
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(v, forKey: keyName)
                }
            }
        }
    }
    public class References:NSObject
    {
        public var id:Int64 = 0
        public var reference:String = ""
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
        
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class CreateTextIndexResponse:NSObject
{
    public var index:String = ""
    public var message:String = ""
    init(json: NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let v = checkValue(value) {
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(v, forKey: keyName)
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class DeleteTextIndexResponse:NSObject
{
    public var confirm:String = ""
    public var deleted:Bool!
    public var index:String = ""
    init(json: NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let v = checkValue(value) {
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(v, forKey: keyName)
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class DeleteFromTextIndexResponse:NSObject
{
    public var documents_deleted :Double = 0
    public var index:String = ""
    init(json: NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let v = checkValue(value) {
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(v, forKey: keyName)
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////

// Solved the 24hr problem by changing it to _24hr
/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class IndexStatusResponse:NSObject
{
    public var _24hr_index_updates:Double = 0
    public var component_count:Double = 0
    public var total_documents:Double = 0
    public var total_index_size:Double = 0
    init(json: NSDictionary) {
        super.init()
        for (key, value) in json {
            if let v = checkValue(value) {
                var keyName:String = (key as? String)!
                if keyName == "24hr_index_updates" {
                    keyName = "_24hr_index_updates"
                }
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(v, forKey: keyName)
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////

// Solved the description conflict by changing it to _description
/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class ListResourcesResponse:NSObject
{
    public var private_resources:NSMutableArray = []
    public var public_resources:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "private_resources" {
                    for item in keyValue {
                        let p = Private_resources(json: item as! NSDictionary)
                        self.private_resources.addObject(p)
                    }
                } else if keyName == "public_resources" {
                    for item in keyValue {
                        let p = Public_resources(json: item as! NSDictionary)
                        self.public_resources.addObject(p)
                    }
                }
            }
        }
    }
    public class Private_resources:NSObject
    {
        public var date_created:String = ""
        public var _description:String = ""
        public var flavor:String = ""
        public var resource:String = ""
        public var type:String = ""
        public var display_name:String = ""
        public var resourceUUID:String = ""
        
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                if let v = checkValue(value) {
                    var keyName:String = (key as? String)!
                    if keyName == "description" {
                        keyName = "_description"
                    }
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    public class Public_resources:NSObject
    {
        public var _description:String = ""
        public var resource:String = ""
        public var type:String = ""
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                var keyName:String = (key as? String)!
                if keyName == "description" {
                    keyName = "_description"
                }
                if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class RestoreTextIndexResponse:NSObject
{
    public var restored:String = ""
    init(json: NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let v = checkValue(value) {
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(v, forKey: keyName)
                }
            }
        }
    }
}
//////////////////////---------------/////////////////////////

/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class AnomalyDetectionResponse:NSObject
{
    public var result:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "result" {
                    for item in keyValue {
                        let p = Result(json: item as! NSDictionary)
                        self.result.addObject(p)
                    }
                }
            }
        }
    }
    public class Result:NSObject
    {
        public var row:Int64 = 0
        public var row_anomaly_score:Double = 0.0
        public var anomalies:NSMutableArray = []
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSArray {
                    let keyValue:NSArray = (value as? NSArray)!
                    if keyName == "anomalies" {
                        for item in keyValue {
                            let p = Anomaly(json: item as! NSDictionary)
                            self.anomalies.addObject(p)
                        }
                    }
                } else if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    public class Anomaly:NSObject
    {
        public var type:String = ""
        public var anomaly_score:Double = 0.0
        public var columns:NSMutableArray = []
        
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSArray {
                    let keyValue:NSArray = (value as? NSArray)!
                    if keyName == "columns" {
                        for item in keyValue {
                            let p = Column(json: item as! NSDictionary)
                            self.columns.addObject(p)
                        }
                    }
                } else if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    public class Column:NSObject {
        public var column : String = ""
        public var value : String = ""
        
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class TrendAnalysisResponse:NSObject
{
    public var trend_collections:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "trend_collections" {
                    for item in keyValue {
                        let p = TrendCollection(json: item as! NSDictionary)
                        self.trend_collections.addObject(p)
                    }
                }
            }
        }
    }
    public class TrendCollection:NSObject
    {
        public var trends:NSMutableArray = []
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSArray {
                    let keyValue:NSArray = (value as? NSArray)!
                    if keyName == "trends" {
                        for item in keyValue {
                            let p = Trend(json: item as! NSDictionary)
                            self.trends.addObject(p)
                        }
                    }
                }
            }
        }
    }
    public class Trend:NSObject
    {
        public var trend:String = ""
        public var measure_percentage_main_group:Double = 0.0
        public var measure_value_main_group:Double = 0.0
        public var main_trend:String = ""
        public var score:Double = 0.0
        public var measure_percentage_compared_group:Double = 0.0
        public var measure:NSMutableArray = []
        public var category:NSMutableArray = []
        
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSArray {
                    let keyValue:NSArray = (value as? NSArray)!
                    if keyName == "category" {
                        for item in keyValue {
                            let p = Category(json: item as! NSDictionary)
                            self.category.addObject(p)
                        }
                    } else if keyName == "measure" {
                        for item in keyValue {
                            let p = Category(json: item as! NSDictionary)
                            self.measure.addObject(p)
                        }
                    }
                } else if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    public class Category:NSObject {
        public var column : String = ""
        public var value : String = ""
        
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
}
//////////////////////---------------/////////////////////////

// Utilities public functions
public func checkValue(value: AnyObject) -> AnyObject?
{
    var keyValue:AnyObject?
    if let _ = value as? String {
        keyValue = (value as? String)!
    } else if let _ = value as? Double {
        keyValue = (value as? Double)!
    } else if let _ = value as? Bool {
        keyValue = (value as? Bool)!
    }
    return keyValue
}