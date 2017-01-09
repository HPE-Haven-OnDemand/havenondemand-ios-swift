//
//  HODResponseObjects.swift
//  Response predefined objects
//
//  Created by Van Phong Vu on 10/1/15.
//  Copyright (c) 2015 Van Phong Vu. All rights reserved.
//

import Foundation

open class HODErrorObject:NSObject
{
    open var error:Int = 0
    open var reason:String = ""
    open var detail:String = ""
    open var jobID:String = ""
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if (self.responds(to: NSSelectorFromString(keyName))) {
                self.setValue(value, forKey: keyName)
            }
        }
    }
}

/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
open class SpeechRecognitionResponse : NSObject{
    open var document:NSMutableArray = [] // Document
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "document" {
                    for item in keyValue {
                        let p = Document(json: item as! NSDictionary)
                        self.document.add(p)
                    }
                }
            }
        }
    }
    open class Document:NSObject {
        open var offset:Int64 = 0
        open var content:String = ""
        open var confidence:Int = 0
        open var duration:Int = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class DetectSceneChangesResponse:NSObject {
    open var message:String = ""
    open var items:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "items" {
                    for item in keyValue {
                        let p = Item(json: item as! NSDictionary)
                        self.items.add(p)
                    }
                }
            } else if let v = checkValue(value as AnyObject) {
                if (self.responds(to: NSSelectorFromString(keyName))) {
                    self.setValue(v, forKey: keyName)
                }
            }
        }
    }
    open class Item:NSObject{
        open var time:Double = 0.0
        open var width:Int = 0
        open var height:Int = 0
        open var image:String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class LicensePlateRecognitionResponse:NSObject {
    open var items:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "items" {
                    for item in keyValue {
                        let p = Item(json: item as! NSDictionary)
                        self.items.add(p)
                    }
                }
            }
        }
    }
    open class Item:NSObject{
        open var start_time:Double = 0.0
        open var end_time:Double = 0.0
        open var time:Double = 0.0
        open var license_plate_info:LicensePlateInfo!
        open var confidence:Double = 0.0
        open var region:Region!
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        if keyName == "license_plate_info"{
                            self.license_plate_info = LicensePlateInfo(json:keyValue)
                        }else if keyName == "region"{
                            self.region = Region(json:keyValue)
                        }
                    }
                } else {
                    if let v = checkValue(value as AnyObject) {
                        if (self.responds(to: NSSelectorFromString(keyName))) {
                            self.setValue(v, forKey: keyName)
                        }
                    }
                }
            }
        }
    }
    open class LicensePlateInfo:NSObject {
        open var plate_origin:String = ""
        open var plate_read:NSMutableArray = []
        open var unformatted_read:String = ""
        open var plate_shape:NSMutableArray = []
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSArray {
                    let keyValue:NSArray = (value as? NSArray)!
                    for item in keyValue {
                        if (self.responds(to: NSSelectorFromString(keyName))) {
                            let c = item as! String
                            if keyName == "plate_read"{
                                self.plate_read.add(c)
                            }else if keyName == "plate_shape"{
                                self.plate_shape.add(c)
                            }
                        }
                    }
                } else if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    open class Region:NSObject {
        open var x:Double!
        open var y:Double!
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class CancelConnectorScheduleResponse:NSObject {
    open var connector: String = ""
    open var stopped_schedule: Bool = false
    
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let v = checkValue(value as AnyObject) {
                if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class ConnectorHistoryResponse:NSObject {
    open var history:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "history" {
                    for item in keyValue {
                        let p = History(json: item as! NSDictionary)
                        self.history.add(p)
                    }
                }
            }
        }
    }
    open class History:NSObject
    {
        open var connector: String = ""
        open var document_counts: Document_counts?
        open var error:String = ""
        open var failed:String = ""
        open var process_end_time: String = ""
        open var process_start_time: String = ""
        open var start_time: String = ""
        open var queued_time: String = ""
        open var status: String = ""
        open var time_in_queue: Double = 0
        open var time_processing: Double = 0
        open var token: String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.document_counts = Document_counts(json:keyValue)
                    }
                } else {
                    if let v = checkValue(value as AnyObject) {
                        if (self.responds(to: NSSelectorFromString(keyName))) {
                            self.setValue(v, forKey: keyName)
                        }
                    }
                }
            }
        }
    }
    open class Document_counts:NSObject {
        open var added: Int = 0
        open var deleted: Int = 0
        open var errors: Int = 0
        open var ingest_added: Int = 0
        open var ingest_deleted: Int = 0
        open var ingest_failed: Int = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class ConnectorStatusResponse:NSObject {
    open var connector: String = ""
    open var status: String = ""
    open var document_counts: Document_counts?
    open var error: String = ""
    open var failed: String = ""
    open var process_end_time: String = ""
    open var process_start_time: String = ""
    open var start_time: String = ""
    open var queued_time: String = ""
    open var time_in_queue: Int64 = 0
    open var time_processing: Int64 = 0
    open var token: String = ""
    open var schedule: Schedule?
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSDictionary {
                let keyValue:NSDictionary = (value as? NSDictionary)!
                if (self.responds(to: NSSelectorFromString(keyName))) {
                    if keyName == "document_counts" {
                        self.document_counts = Document_counts(json:keyValue)
                    } else if keyName == "schedule" {
                        self.schedule = Schedule(json:keyValue)
                    }
                }
            } else {
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    open class Document_counts:NSObject
    {
        open var added: Int = 0
        open var deleted: Int = 0
        open var errors: Int = 0
        open var ingest_added: Int = 0
        open var ingest_deleted: Int = 0
        open var ingest_failed: Int = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    open class Schedule:NSObject
    {
        open var last_run_time: String = ""
        open var next_run_time: String = ""
        open var occurrences_remaining: Double = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class CreateConnectorResponse:NSObject {
    open var connector: String = ""
    open var download_link: Download_link?
    open var message: String = ""
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSDictionary {
                let keyValue:NSDictionary = (value as? NSDictionary)!
                if (self.responds(to: NSSelectorFromString(keyName))) {
                    if keyName == "download_link" {
                        self.download_link = Download_link(json:keyValue)
                    }
                }
            } else {
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    open class Download_link:NSObject
    {
        open var linux_x86: String = ""
        open var linux_x86_64: String = ""
        open var windows_x86: String = ""
        open var windows_x86_64: String = ""
        
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class DeleteConnectorResponse:NSObject {
    open var connector: String = ""
    open var deleted: Bool = false
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let v = checkValue(value as AnyObject) {
                if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class RetrieveConnectorConfigurationFileResponse:NSObject {
    open var name: String = ""
    open var flavor: String = ""
    open var config: String = ""
    open var licenseKey: String = ""
    open var validation: String = ""
    open var verification: String = ""
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let v = checkValue(value as AnyObject) {
                if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class RetrieveConnectorConfigurationAttrResponse:NSObject {
    open var name: String = ""
    open var flavor: String = ""
    open var config: Config!
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSDictionary {
                let keyValue:NSDictionary = (value as? NSDictionary)!
                if (self.responds(to: NSSelectorFromString(keyName))) {
                    if keyName == "config" {
                        self.config = Config(json:keyValue)
                    }
                }
            } else {
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    open class Config:NSObject
    {
        open var config:ConfigObj!
        open var destination:DestinationObj!
        open var schedule:ScheduleObj!
        open var credentials:CredentialsObj!
        open var credentials_policy:CredentialsPolicy!
        open var _description:String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                var keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.responds(to: NSSelectorFromString(keyName))) {
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
                    if let v = checkValue(value as AnyObject) {
                        if (self.responds(to: NSSelectorFromString(keyName))) {
                            self.setValue(v, forKey: keyName)
                        }
                    }
                }
            }
        }
    }
    
    open class ConfigObj:NSObject
    {
        open var url:String = ""
        open var max_pages:Int64 = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    open class DestinationObj:NSObject
    {
        open var action:String = ""
        open var index:String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    open class ScheduleObj:NSObject
    {
        open var frequency:FrequencyObj!
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        if keyName == "frequency" {
                            self.frequency = FrequencyObj(json:keyValue)
                        }
                    }
                }
            }
        }
        open class FrequencyObj:NSObject
        {
            open var frequency_type:String = ""
            open var interval:Int64 = 0
            init(json:NSDictionary) {
                super.init()
                for (key, value) in json {
                    let keyName:String = (key as? String)!
                    if let v = checkValue(value as AnyObject) {
                        if (self.responds(to: NSSelectorFromString(keyName))) {
                            self.setValue(v, forKey: keyName)
                        }
                    }
                }
            }
        }
    }
    open class CredentialsObj:NSObject
    {
        open var login_value:String = ""
        open var password_value:String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    
    open class CredentialsPolicy:NSObject
    {
        open var notification_email:String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class StartConnectorResponse:NSObject {
    open var connector: String = ""
    open var token: String = ""
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let v = checkValue(value as AnyObject) {
                if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class StopConnectorResponse:NSObject {
    open var connector: String = ""
    open var message: String = ""
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let v = checkValue(value as AnyObject) {
                if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class UpdateConnectorResponse:NSObject {
    open var connector: String = ""
    open var message: String = ""
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let v = checkValue(value as AnyObject) {
                if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class ExpandContainerResponse:NSObject {
    open var files:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "files" {
                    for item in keyValue {
                        let p = Files(json: item as! NSDictionary)
                        self.files.add(p)
                    }
                }
            }
        }
    }
    open class Files:NSObject
    {
        open var name: String = ""
        open var reference: String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class StoreObjectResponse:NSObject {
    open var reference: String = ""
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let v = checkValue(value as AnyObject) {
                if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class ViewDocumentResponse:NSObject {
    open var document: String = ""
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let v = checkValue(value as AnyObject) {
                if (self.responds(to: NSSelectorFromString(keyName))) {
                    self.setValue(v, forKey: keyName)
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
open class GetCommonNeighborsResponse:NSObject
{
    open var nodes:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "nodes" {
                    for item in keyValue {
                        let p = Nodes(json: item as! NSDictionary)
                        self.nodes.add(p)
                    }
                }
            }
        }
    }
    
    open class Nodes:NSObject
    {
        open var attributes:Attributes!
        open var id:Int64 = 0
        open var commonality: Int64 = 0
        open var sort_value:Int = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.attributes = Attributes(json:keyValue)
                    }
                } else {
                    if let v = checkValue(value as AnyObject) {
                        if (self.responds(to: NSSelectorFromString(keyName))) {
                            self.setValue(v, forKey: keyName)
                        }
                    }
                }
            }
        }
    }
    open class Attributes:NSObject
    {
        open var name: String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class GetNeighborsResponse:NSObject
{
    open var neighbors:NSMutableArray = [] //(array[Neighbors] , optional)
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "neighbors" {
                    for item in keyValue {
                        let p = Neighbors(json: item as! NSDictionary)
                        self.neighbors.add(p)
                    }
                }
            }
        }
    }
    open class Neighbors:NSObject
    {
        open var target: TargetOrSource!
        open var source: TargetOrSource!
        open var nodes:NSMutableArray = [] //(array[Nodes] )
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        if keyName == "target" {
                            self.target = TargetOrSource(json:keyValue)
                        } else if keyName == "source" {
                            self.source = TargetOrSource(json:keyValue)
                        }
                    }
                } else if let _ = value as? NSArray {
                    let keyValue:NSArray = (value as? NSArray)!
                    if keyName == "nodes" {
                        for item in keyValue {
                            let p = Nodes(json: item as! NSDictionary)
                            self.nodes.add(p)
                        }
                    }
                }
            }
        }
    }
    
    open class Nodes:NSObject
    {
        open var attributes: Attributes!
        open var id: Int64 = 0 //(integer )  Node ID
        open var sort_value: Double = 0.0 //(number , optional)
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.attributes = Attributes(json:keyValue)
                    }
                } else {
                    if let v = checkValue(value as AnyObject) {
                        if (self.responds(to: NSSelectorFromString(keyName))) {
                            self.setValue(v, forKey: keyName)
                        }
                    }
                }
            }
        }
    }
    open class Attributes:NSObject
    {
        open var name: String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    open class TargetOrSource:NSObject
    {
        open var id: Int64 = 0
        open var attributes: Attributes!
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.attributes = Attributes(json:keyValue)
                    }
                } else {
                    if let v = checkValue(value as AnyObject) {
                        if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class GetNodesResponse:NSObject
{
    open var nodes: NSMutableArray = [] //(array[Nodes] )
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "nodes" {
                    for item in keyValue {
                        let p = Nodes(json: item as! NSDictionary)
                        self.nodes.add(p)
                    }
                }
            }
        }
    }
    open class Nodes:NSObject
    {
        open var attributes: Attributes!
        open var id: Int64 = 0 //(integer )  Node ID
        open var sort_value: Double = 0.0 //(number , optional)
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.attributes = Attributes(json:keyValue)
                    }
                } else {
                    if let v = checkValue(value as AnyObject) {
                        if (self.responds(to: NSSelectorFromString(keyName))) {
                            self.setValue(v, forKey: keyName)
                        }
                    }
                }
            }
        }
    }
    open class Attributes:NSObject
    {
        open var name: String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class GetShortestPathResponse:NSObject
{
    open var edges: NSMutableArray = []
    open var nodes: NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "nodes" {
                    for item in keyValue {
                        let p = Nodes(json: item as! NSDictionary)
                        self.nodes.add(p)
                    }
                } else if keyName == "edges" {
                    for item in keyValue {
                        let p = Edges(json: item as! NSDictionary)
                        self.edges.add(p)
                    }
                }
            }
        }
    }
    open class Edges:NSObject
    {
        open var attributes: Attributes!
        open var length: Int64 = 0 //(number )  Length/weight/cost of edge.
        open var source: Int64 = 0 //( integer )  Source node ID.
        open var target: Int64 = 0 //( integer )  Target node ID.
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.attributes = Attributes(json:keyValue)
                    }
                } else {
                    if let v = checkValue(value as AnyObject) {
                        if (self.responds(to: NSSelectorFromString(keyName))) {
                            self.setValue(v, forKey: keyName)
                        }
                    }
                }
            }
        }
    }
    
    open class Attributes:NSObject
    {
        open var weight: Double = 0.0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    
    open class Nodes:NSObject
    {
        open var attributes: Attributes!
        open var id: Int64 = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.attributes = Attributes(json:keyValue)
                    }
                } else {
                    if let v = checkValue(value as AnyObject) {
                        if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class GetSubgraphResponse:NSObject
{
    open var edges: NSMutableArray = []
    open var nodes: NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "nodes" {
                    for item in keyValue {
                        let p = Nodes(json: item as! NSDictionary)
                        self.nodes.add(p)
                    }
                } else if keyName == "edges" {
                    for item in keyValue {
                        let p = Edges(json: item as! NSDictionary)
                        self.edges.add(p)
                    }
                }
            }
        }
    }
    
    open class Edges:NSObject
    {
        open var attributes: Attributes!
        open var source: Int64 = 0
        open var target: Int64 = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.attributes = Attributes(json:keyValue)
                    }
                } else if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    
    open class Attributes:NSObject
    {
        open var weight: Double = 0.0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    
    open class Nodes:NSObject
    {
        open var attributes: Attributes!
        open var id: Int64 = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.attributes = Attributes(json:keyValue)
                    }
                } else if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class SuggestLinksResponse:NSObject
{
    open var suggestions: NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "suggestions" {
                    for item in keyValue {
                        let p = Suggestions(json: item as! NSDictionary)
                        self.suggestions.add(p)
                    }
                }
            }
        }
    }
    
    open class Suggestions:NSObject
    {
        open var source : Source!
        open var nodes:NSMutableArray = []  //(array[Nodes] )
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.source = Source(json:keyValue)
                    }
                } else if let _ = value as? NSArray {
                    let keyValue:NSArray = (value as? NSArray)!
                    if keyName == "nodes" {
                        for item in keyValue {
                            let p = Nodes(json: item as! NSDictionary)
                            self.nodes.add(p)
                        }
                    }
                }
            }
        }
    }
    
    open class Source:NSObject
    {
        open var id: Int64 = 0
        open var attributes: Attributes!
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.attributes = Attributes(json:keyValue)
                    }
                } else if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    
    open class Attributes:NSObject
    {
        open var name: String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    
    open class Nodes:NSObject
    {
        open var attributes: Attributes!
        open var id: Int64 = 0
        open var sort_value: Double = 0.0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.attributes = Attributes(json:keyValue)
                    }
                } else if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class SummarizeGraphResponse:NSObject
{
    open var attributes: NSMutableArray = []
    open var edges: Int64 = 0
    open var nodes: Int64 = 0
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "attributes" {
                    for item in keyValue {
                        if (self.responds(to: NSSelectorFromString(keyName))) {
                            let c = Attributes(json: item as! NSDictionary)
                            self.attributes.add(c)
                        }
                    }
                }
            } else if let v = checkValue(value as AnyObject) {
                if (self.responds(to: NSSelectorFromString(keyName))) {
                    self.setValue(v, forKey: keyName)
                }
            }
        }
    }
    open class Attributes:NSObject
    {
        open var data_type: String = ""
        open var element_type: String = ""
        open var name: String = ""
        open var number: Int64 = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class OCRDocumentResponse:NSObject {
    open var text_block:NSMutableArray = [] // TextBlock
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "text_block" {
                    for item in keyValue {
                        let p = TextBlock(json: item as! NSDictionary)
                        self.text_block.add(p)
                    }
                }
            }
        }
    }
    open class TextBlock:NSObject
    {
        open var text:String = ""
        open var left:Int = 0
        open var top:Int = 0
        open var width:Int = 0
        open var height:Int = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class RecognizeBarcodesResponse:NSObject {
    open var barcode:NSMutableArray = [] // Barcode
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "barcode" {
                    for item in keyValue {
                        let p = Barcode(json: item as! NSDictionary)
                        self.barcode.add(p)
                    }
                }
            }
        }
    }
    open class Barcode:NSObject
    {
        open var text:String = ""
        open var barcode_type:String = ""
        open var left:Int = 0
        open var top:Int = 0
        open var width:Int = 0
        open var height:Int = 0
        open var additional_information:AdditionalInformation?
        
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.additional_information = AdditionalInformation(json:keyValue)
                    }
                } else if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    open class AdditionalInformation:NSObject
    {
        open var country:String = ""
        
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class RecognizeImagesResponse : NSObject{
    open var object:NSMutableArray = [] // HODObject
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "object" {
                    for item in keyValue {
                        let p = HODObject(json: item as! NSDictionary)
                        self.object.add(p)
                    }
                }
            }
        }
    }
    open class HODObject:NSObject {
        open var unique_name:String = ""
        open var name:String = ""
        open var db:String = ""
        open var corners:NSMutableArray = []
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSArray {
                    let keyValue:NSArray = (value as? NSArray)!
                    for item in keyValue {
                        if (self.responds(to: NSSelectorFromString(keyName))) {
                            let c = Corners(json:item as! NSDictionary)
                            self.corners.add(c)
                        }
                    }
                } else if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    open class Corners:NSObject {
        open var x:Int = 0
        open var y:Int = 0
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class DetectFacesResponse : NSObject {
    open var face:NSMutableArray = []
    
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "face" {
                    for item in keyValue {
                        let p = Face(json: item as! NSDictionary)
                        self.face.add(p)
                    }
                }
            }
        }
    }
    
    open class Face:NSObject {
        open var left:Int = 0
        open var top:Int = 0
        open var width:Int = 0
        open var height:Int = 0
        open var additional_information:AdditionalInformation?
        
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.additional_information = AdditionalInformation(json:keyValue)
                    }
                } else if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    open class AdditionalInformation:NSObject {
        open var age:String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class PredictResponse:NSObject {
    open var fields:NSMutableArray = []
    open var values:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "fields" {
                    for item in keyValue {
                        let p = Fields(json: item as! NSDictionary)
                        self.fields.add(p)
                    }
                } else if keyName == "values" {
                    for item in keyValue {
                        let p = Values(json: item as! NSDictionary)
                        self.values.add(p)
                    }
                }
            }
        }
    }
    open class Fields:NSObject
    {
        open var name: String = ""
        open var order: Double = 0
        open var type: String = ""
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    open class Values:NSObject
    {
        open var row:NSMutableArray = []
        init(json : NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSArray {
                    let keyValue:NSArray = (value as? NSArray)!
                    if keyName == "row" {
                        for item in keyValue {
                            let p = item as! String
                            self.row.add(p)
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
open class PredictV2Response:NSObject {
    open var dataset:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "dataset" {
                    for item in keyValue {
                        let p = Dataset(json: item as! NSDictionary)
                        self.dataset.add(p)
                    }
                }
            }
        }
    }
    open class Dataset:NSObject
    {
        open var row:AnyObject = AnyObject.self as AnyObject
        open var prediction:String = ""
        open var confidence:Double = 0.0
        
        init(json : NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if keyName == "row" {
                    if let v = checkValue(value as AnyObject) {
                        if (self.responds(to: NSSelectorFromString(keyName))) {
                            self.setValue(v, forKey: keyName)
                        }
                    }
                }else{
                    if let v = checkValue(value as AnyObject) {
                        if (self.responds(to: NSSelectorFromString(keyName))) {
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
/************************************************************/
open class RecommendResponse:NSObject
{
    open var allRecommendations:NSMutableArray = []
    open var fields:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "fields" {
                    for item in keyValue {
                        let p = Fields(json: item as! NSDictionary)
                        self.fields.add(p)
                    }
                } else if keyName == "allRecommendations" {
                    for item in keyValue {
                        let p = Allrecommendations(json: item as! NSDictionary)
                        self.allRecommendations.add(p)
                    }
                }
            }
        }
    }
    open class Allrecommendations:NSObject
    {
        open var originalValues:NSMutableArray = []
        open var recommendations:NSMutableArray = []
        init(json : NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSArray {
                    let keyValue:NSArray = (value as? NSArray)!
                    if keyName == "originalValues" {
                        for item in keyValue {
                            let p = item as! String
                            self.originalValues.add(p)
                        }
                    } else if keyName == "recommendations" {
                        for item in keyValue {
                            let p = Recommendations(json: item as! NSDictionary)
                            self.recommendations.add(p)
                        }
                    }
                }
            }
        }
    }
    open class Recommendations:NSObject
    {
        open var confidence:Double = 0
        open var distance:Double = 0
        open var new_prediction:String = ""
        open var recommendation:NSMutableArray = []
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSArray {
                    let keyValue:NSArray = (value as? NSArray)!
                    for item in keyValue {
                        if (self.responds(to: NSSelectorFromString(keyName))) {
                            let c = item as! String
                            self.recommendation.add(c)
                        }
                    }
                } else if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    open class Fields:NSObject
    {
        open var name:String = ""
        open var order:Int = 0
        open var type:String = ""
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class RecommendV2Response:NSObject
{
    open var dataset:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "dataset" {
                    for item in keyValue {
                        let p = Dataset(json: item as! NSDictionary)
                        self.dataset.add(p)
                    }
                }
            }
        }
    }
    open class Dataset:NSObject
    {
        open var row:AnyObject = AnyObject.self as AnyObject
        open var prediction:String = ""
        open var recommendations:NSMutableArray = []
        
        init(json : NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if keyName == "recommendations" {
                    if let _ = value as? NSArray {
                        let keyValue:NSArray = (value as? NSArray)!
                        for item in keyValue {
                            let p = Recommendations(json: item as! NSDictionary)
                            self.recommendations.add(p)
                        }
                    }
                }else{
                    if let v = checkValue(value as AnyObject) {
                        if (self.responds(to: NSSelectorFromString(keyName))) {
                            self.setValue(v, forKey: keyName)
                        }
                    }
                }
            }
        }
    }
    open class Recommendations:NSObject
    {
        open var confidence:Double = 0
        open var distance:Double = 0
        open var prediction:String = ""
        open var recommendation:AnyObject = AnyObject.self as AnyObject
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if keyName == "recommendation" {
                    if let v = checkValue(value as AnyObject) {
                        if (self.responds(to: NSSelectorFromString(keyName))) {
                            self.setValue(v, forKey: keyName)
                        }
                    }
                } else if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class TrainPredictionResponse:NSObject
{
    open var message:String = ""
    open var service:String = ""
    init(json: NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let v = checkValue(value as AnyObject) {
                if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class TrainPredictionV2Response:NSObject
{
    open var message:String = ""
    open var model:String = ""
    init(json: NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let v = checkValue(value as AnyObject) {
                if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class GetPredictionModelDetailsResponse:NSObject
{
    open var models:NSMutableArray = []
    init(json: NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "models" {
                    for item in keyValue {
                        let p = Models(json: item as! NSDictionary)
                        self.models.add(p)
                    }
                }
            }
        }
    }
    open class Models:NSObject {
        open var model_name:String = ""
        open var date_created:String = ""
        open var model_type:String = ""
        open var structure: Structure!
        open var performance_measures:Performance_measures!
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.performance_measures = Performance_measures(json:keyValue)
                    }
                } else if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    open class Structure:NSObject {
        open var name:String = ""
        open var order:String = ""
        open var type:String = ""
        open var properties:Properties!
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.properties = Properties(json:keyValue)
                    }
                } else if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    open class Properties:NSObject {
        open var label:Bool!
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    open class Performance_measures:NSObject {
        open var selected_algorithm:String = ""
        open var algorithm_params:Algorithm_params!
        open var prediction_field:String = ""
        open var classification_measures:Classification_measures!
        open var regression_measures:Regression_measures!
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        if keyName == "classification_measures"{
                            self.classification_measures = Classification_measures(json:keyValue)
                        }else if keyName == "regression_measures"{
                            self.regression_measures = Regression_measures(json:keyValue)
                        }else if keyName == "algorithm_params"{
                            self.algorithm_params = Algorithm_params(json:keyValue)
                        }
                    }
                } else if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    
    open class Algorithm_params:NSObject {
        open var param_name:String = ""
        open var param_value:String = ""
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    open class Classification_measures:NSObject {
        open var accuracy:Double = 0.0
        open var precision:Double = 0.0
        open var recall:Double = 0.0
        open var f_measure:Double = 0.0
        open var confusion_matrix:Confusion_matrix!
        open var train_accuracy:Double = 0.0
        open var overfitting:Bool!
        open var underfitting:Bool!
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        if keyName == "confusion_matrix"{
                            self.confusion_matrix = Confusion_matrix(json:keyValue)
                        }
                    }
                } else if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    
    open class Confusion_matrix:NSObject {
        open var predicted_label:String = ""
        open var actual_label:String = ""
        open var amount:Double = 0.0
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    
    open class Regression_measures:NSObject {
        open var overfitting:Bool!
        open var mean_squared_error:Double = 0.0
        open var root_mean_squared_error:Double = 0.0
        open var mean_absolute_error:Double = 0.0
        open var coefficient_of_determination:Double = 0.0
        open var train_mean_squared_error:Double = 0.0
        open var train_root_mean_squared_error:Double = 0.0
        open var train_mean_absolute_error:Double = 0.0
        open var train_coefficient_of_determination:Double = 0.0
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class DeletePredictionModelResponse:NSObject {
    open var model_name:String = "" //(string )  The name of the model to delete.
    open var deleted:Bool = false //( boolean )  Indicates whether the deletion process was successful.
    init(json: NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let v = checkValue(value as AnyObject) {
                if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class CreateQueryProfileResponse:NSObject
{
    open var message:String = ""
    open var query_profile:String = ""
    init(json: NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let v = checkValue(value as AnyObject) {
                if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class DeleteQueryProfileResponse:NSObject
{
    open var message:String = ""
    open var query_profile:String = ""
    init(json: NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let v = checkValue(value as AnyObject) {
                if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class RetrieveQueryProfileResponse:NSObject
{
    open var query_profile:String = ""
    open var _description:String = ""
    open var query_manipulation_index:String = ""
    open var promotions_enabled:Bool = false
    open var promotion_categories:NSMutableArray = []
    open var promotions_identified:Bool = false
    open var synonyms_enabled:Bool = false
    open var synonym_categories:NSMutableArray = []
    open var blacklists_enabled:Bool = false
    open var blacklist_categories:NSMutableArray = []
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            var keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "promotion_categories" {
                    for item in keyValue {
                        if (self.responds(to: NSSelectorFromString(keyName))) {
                            let c = item as! String
                            self.promotion_categories.add(c)
                        }
                    }
                } else if keyName == "synonym_categories" {
                    for item in keyValue {
                        if (self.responds(to: NSSelectorFromString(keyName))) {
                            let c = item as! String
                            self.synonym_categories.add(c)
                        }
                    }
                } else if keyName == "blacklist_categories" {
                    for item in keyValue {
                        if (self.responds(to: NSSelectorFromString(keyName))) {
                            let c = item as! String
                            self.blacklist_categories.add(c)
                        }
                    }
                }
            } else {
                if let v = checkValue(value as AnyObject) {
                    if keyName == "description" {
                        keyName = "_description"
                    }
                    if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class UpdateQueryProfileResponse:NSObject
{
    open var message:String = ""
    open var query_profile:String = ""
    init(json: NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let v = checkValue(value as AnyObject) {
                if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class FindRelatedConceptsResponse:NSObject
{
    open var entities:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "entities" {
                    for item in keyValue {
                        let p = Entities(json: item as! NSDictionary)
                        self.entities.add(p)
                    }
                }
            }
        }
    }
    open class Entities:NSObject
    {
        open var cluster:Int64 = 0
        open var docs_with_all_terms:Int64 = 0
        open var docs_with_phrase:Int64 = 0
        open var occurrences:Int64 = 0
        open var text:String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class AutoCompleteResponse:NSObject
{
    open var words:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "words" {
                    for item in keyValue {
                        let p = item as! String
                        self.words.add(p)
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
open class ExtractConceptsResponse:NSObject
{
    open var concepts:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "concepts" {
                    for item in keyValue {
                        let p = Concepts(json: item as! NSDictionary)
                        self.concepts.add(p)
                    }
                }
            }
        }
    }
    open class Concepts:NSObject
    {
        open var concept:String = ""
        open var occurrences:Int64 = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class ExpandTermsResponse:NSObject
{
    open var terms:NSMutableArray = [] // ( array[Terms] )  The details of the expanded terms.
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "terms" {
                    for item in keyValue {
                        let p = Terms(json: item as! NSDictionary)
                        self.terms.add(p)
                    }
                }
            }
        }
    }
    open class Terms:NSObject
    {
        open var documents:Int64 = 0
        open var term:String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class HighlightTextResponse:NSObject
{
    open var text:String = ""
    init(json: NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let v = checkValue(value as AnyObject) {
                if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class EntityExtractionResponse:NSObject
{
    open var entities:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "entities" {
                    for item in keyValue {
                        let p = Entity(json: item as! NSDictionary)
                        self.entities.add(p)
                    }
                }
            }
        }
    }
    open class Entity:NSObject
    {
        open var normalized_text:String = ""
        open var original_text:String = ""
        open var type:String = ""
        open var normalized_length:Int32 = 0
        open var original_length:Int = 0
        open var score:Double = 0.0
        open var normalized_date:String = ""
        open var additional_information:AdditionalInformation!
        open var components:NSMutableArray = [] // Components
        open var documentIndex:Int = 0
        open var offset:Int = 0
        
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSArray {
                    let keyValue:NSArray = (value as? NSArray)!
                    for item in keyValue {
                        if (self.responds(to: NSSelectorFromString(keyName))) {
                            let c = Components(json:item as! NSDictionary)
                            self.components.add(c)
                        }
                    }
                }else{
                    if let v = checkValue(value as AnyObject) {
                        if (self.responds(to: NSSelectorFromString(keyName))) {
                            self.setValue(v, forKey: keyName)
                        }
                    }
                }
            }
        }
    }
    open class AdditionalInformation:NSObject
    {
        open var person_date_of_birth:String = ""
        open var wikidata_id:Int = 0
        open var wikipedia_eng:String = ""
        open var image:String = ""
        open var person_date_of_death:String = ""
        
        open var lon:Double = 0.0
        open var lat:Double = 0.0
        open var place_population:Int = 0
        open var place_country_code:String = ""
        open var place_region1:String = ""
        open var place_region2:String = ""
        open var place_elevation:Double = 0.0
        
        open var place_type:String = ""
        open var place_timezone:Int = 0
        open var place_continent:String = ""
        
        open var url_homepage:String = ""
        open var country:String = ""
        open var film_budget:String = ""
        open var film_gross:String = ""
        open var team_league:String = ""
        open var language_family:String = ""
        open var language_iso639_1:String = ""
        open var language_nativespeakers:Int = 0
        
        open var person_profession:NSMutableArray = []
        open var company_wikipedia:NSMutableArray = [] // String
        open var company_ric:NSMutableArray = [] // String
        open var company_bloomberg:NSMutableArray = [] // String
        open var company_google:NSMutableArray = [] // String
        open var company_yahoo:NSMutableArray = [] // String
        open var disease_icd10:NSMutableArray = [] // String
        open var disease_diseasesdb:NSMutableArray = [] // String
        open var film_director:NSMutableArray = [] // String
        open var film_producer:NSMutableArray = [] // String
        open var film_writer:NSMutableArray = [] // String
        open var film_starring:NSMutableArray = [] // String
        open var film_composer:NSMutableArray = [] // String
        open var film_studio:NSMutableArray = [] // String
        open var film_year:NSMutableArray = [] // String
        open var film_runtime:NSMutableArray = [] // String
        open var film_country:NSMutableArray = [] // String
        open var film_language:NSMutableArray = [] // String
        open var film_screenwriter:NSMutableArray = [] // String
        open var film_imdb:NSMutableArray = [] // String
        open var film_dir_photography:NSMutableArray = [] // String
        open var film_distributor:NSMutableArray = [] // String
        open var film_genre:NSMutableArray = [] // String
        open var team_sport:NSMutableArray = [] // String
        open var language_iso639_2:NSMutableArray = [] // String
        open var language_iso639_3:NSMutableArray = [] // String
        open var language_script:NSMutableArray = [] // String
        open var language_group:NSMutableArray = [] // String
        open var language_official_country_code:NSMutableArray = [] // String
        
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSArray {
                    let keyValue:NSArray = (value as? NSArray)!
                    for item in keyValue {
                        if (self.responds(to: NSSelectorFromString(keyName))) {
                            let c = item as! String
                            if keyName == "person_profession"{
                                self.person_profession.add(c)
                            }else if keyName == "company_wikipedia"{
                                self.company_wikipedia.add(c)
                            }else if keyName == "company_ric"{
                                self.company_ric.add(c)
                            }else if keyName == "company_bloomberg"{
                                self.company_bloomberg.add(c)
                            }else if keyName == "company_google"{
                                self.company_google.add(c)
                            }else if keyName == "company_yahoo"{
                                self.company_yahoo.add(c)
                            }else if keyName == "disease_icd10"{
                                self.disease_icd10.add(c)
                            }else if keyName == "disease_diseasesdb"{
                                self.disease_diseasesdb.add(c)
                            }else if keyName == "film_director"{
                                self.film_director.add(c)
                            }else if keyName == "film_producer"{
                                self.film_producer.add(c)
                            }else if keyName == "film_writer"{
                                self.film_writer.add(c)
                            }else if keyName == "film_starring"{
                                self.film_starring.add(c)
                            }else if keyName == "film_composer"{
                                self.film_composer.add(c)
                            }else if keyName == "film_studio"{
                                self.film_studio.add(c)
                            }else if keyName == "film_year"{
                                self.film_year.add(c)
                            }else if keyName == "film_runtime"{
                                self.film_runtime.add(c)
                            }else if keyName == "film_country"{
                                self.film_country.add(c)
                            }else if keyName == "film_language"{
                                self.film_language.add(c)
                            }else if keyName == "film_screenwriter"{
                                self.film_screenwriter.add(c)
                            }else if keyName == "film_imdb"{
                                self.film_imdb.add(c)
                            }else if keyName == "film_dir_photography"{
                                self.film_dir_photography.add(c)
                            }else if keyName == "film_distributor"{
                                self.film_distributor.add(c)
                            }else if keyName == "film_genre"{
                                self.film_genre.add(c)
                            }else if keyName == "team_sport"{
                                self.team_sport.add(c)
                            }else if keyName == "language_iso639_2"{
                                self.language_iso639_2.add(c)
                            }else if keyName == "language_iso639_3"{
                                self.language_iso639_3.add(c)
                            }else if keyName == "language_script"{
                                self.language_script.add(c)
                            }else if keyName == "language_group"{
                                self.language_group.add(c)
                            }else if keyName == "language_official_country_code"{
                                self.language_official_country_code.add(c)
                            }
                        }
                    }
                } else if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    open class Components:NSObject
    {
        open var original_length:Int = 0
        open var original_text:String = ""
        open var type:String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class EntityExtractionV2Response:NSObject
{
    open var entities:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "entities" {
                    for item in keyValue {
                        let p = Entity(json: item as! NSDictionary)
                        self.entities.add(p)
                    }
                }
            }
        }
    }
    open class Entity:NSObject
    {
        open var normalized_text:String = ""
        open var original_text:String = ""
        open var type:String = ""
        open var normalized_length:Int32 = 0
        open var original_length:Int = 0
        open var score:Double = 0.0
        open var normalized_date:String = ""
        open var additional_information:AdditionalInformation!
        open var components:NSMutableArray = [] // Components
        open var matches:NSMutableArray = [] // Matches
        open var documentIndex:Int = 0
        
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSArray {
                    let keyValue:NSArray = (value as? NSArray)!
                    for item in keyValue {
                        if (self.responds(to: NSSelectorFromString(keyName))) {
                            if keyName == "components"{
                                let c = Components(json:item as! NSDictionary)
                                self.components.add(c)
                            }else if keyName == "matches"{
                                let c = Matches(json:item as! NSDictionary)
                                self.matches.add(c)
                            }
                        }
                    }
                }else{
                    if let v = checkValue(value as AnyObject) {
                        if (self.responds(to: NSSelectorFromString(keyName))) {
                            self.setValue(v, forKey: keyName)
                        }
                    }
                }
            }
        }
    }
    open class AdditionalInformation:NSObject
    {
        open var person_date_of_birth:String = ""
        open var wikidata_id:Int = 0
        open var wikipedia_eng:String = ""
        open var image:String = ""
        open var person_date_of_death:String = ""
        
        open var lon:Double = 0.0
        open var lat:Double = 0.0
        open var place_population:Int = 0
        open var place_country_code:String = ""
        open var place_region1:String = ""
        open var place_region2:String = ""
        open var place_elevation:Double = 0.0
        
        open var place_type:String = ""
        open var place_timezone:Int = 0
        open var place_continent:String = ""
        
        open var url_homepage:String = ""
        open var country:String = ""
        open var film_budget:String = ""
        open var film_gross:String = ""
        open var team_league:String = ""
        open var language_family:String = ""
        open var language_iso639_1:String = ""
        open var language_nativespeakers:Int = 0
        
        open var person_profession:NSMutableArray = []
        open var company_wikipedia:NSMutableArray = [] // String
        open var company_ric:NSMutableArray = [] // String
        open var company_bloomberg:NSMutableArray = [] // String
        open var company_google:NSMutableArray = [] // String
        open var company_yahoo:NSMutableArray = [] // String
        open var disease_icd10:NSMutableArray = [] // String
        open var disease_diseasesdb:NSMutableArray = [] // String
        open var film_director:NSMutableArray = [] // String
        open var film_producer:NSMutableArray = [] // String
        open var film_writer:NSMutableArray = [] // String
        open var film_starring:NSMutableArray = [] // String
        open var film_composer:NSMutableArray = [] // String
        open var film_studio:NSMutableArray = [] // String
        open var film_year:NSMutableArray = [] // String
        open var film_runtime:NSMutableArray = [] // String
        open var film_country:NSMutableArray = [] // String
        open var film_language:NSMutableArray = [] // String
        open var film_screenwriter:NSMutableArray = [] // String
        open var film_imdb:NSMutableArray = [] // String
        open var film_dir_photography:NSMutableArray = [] // String
        open var film_distributor:NSMutableArray = [] // String
        open var film_genre:NSMutableArray = [] // String
        open var team_sport:NSMutableArray = [] // String
        open var language_iso639_2:NSMutableArray = [] // String
        open var language_iso639_3:NSMutableArray = [] // String
        open var language_script:NSMutableArray = [] // String
        open var language_group:NSMutableArray = [] // String
        open var language_official_country_code:NSMutableArray = [] // String
        
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSArray {
                    let keyValue:NSArray = (value as? NSArray)!
                    for item in keyValue {
                        if (self.responds(to: NSSelectorFromString(keyName))) {
                            let c = item as! String
                            if keyName == "person_profession"{
                                self.person_profession.add(c)
                            }else if keyName == "company_wikipedia"{
                                self.company_wikipedia.add(c)
                            }else if keyName == "company_ric"{
                                self.company_ric.add(c)
                            }else if keyName == "company_bloomberg"{
                                self.company_bloomberg.add(c)
                            }else if keyName == "company_google"{
                                self.company_google.add(c)
                            }else if keyName == "company_yahoo"{
                                self.company_yahoo.add(c)
                            }else if keyName == "disease_icd10"{
                                self.disease_icd10.add(c)
                            }else if keyName == "disease_diseasesdb"{
                                self.disease_diseasesdb.add(c)
                            }else if keyName == "film_director"{
                                self.film_director.add(c)
                            }else if keyName == "film_producer"{
                                self.film_producer.add(c)
                            }else if keyName == "film_writer"{
                                self.film_writer.add(c)
                            }else if keyName == "film_starring"{
                                self.film_starring.add(c)
                            }else if keyName == "film_composer"{
                                self.film_composer.add(c)
                            }else if keyName == "film_studio"{
                                self.film_studio.add(c)
                            }else if keyName == "film_year"{
                                self.film_year.add(c)
                            }else if keyName == "film_runtime"{
                                self.film_runtime.add(c)
                            }else if keyName == "film_country"{
                                self.film_country.add(c)
                            }else if keyName == "film_language"{
                                self.film_language.add(c)
                            }else if keyName == "film_screenwriter"{
                                self.film_screenwriter.add(c)
                            }else if keyName == "film_imdb"{
                                self.film_imdb.add(c)
                            }else if keyName == "film_dir_photography"{
                                self.film_dir_photography.add(c)
                            }else if keyName == "film_distributor"{
                                self.film_distributor.add(c)
                            }else if keyName == "film_genre"{
                                self.film_genre.add(c)
                            }else if keyName == "team_sport"{
                                self.team_sport.add(c)
                            }else if keyName == "language_iso639_2"{
                                self.language_iso639_2.add(c)
                            }else if keyName == "language_iso639_3"{
                                self.language_iso639_3.add(c)
                            }else if keyName == "language_script"{
                                self.language_script.add(c)
                            }else if keyName == "language_group"{
                                self.language_group.add(c)
                            }else if keyName == "language_official_country_code"{
                                self.language_official_country_code.add(c)
                            }
                        }
                    }
                } else if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    open class Components:NSObject
    {
        open var original_length:Int = 0
        open var original_text:String = ""
        open var type:String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    open class Matches:NSObject
    {
        open var original_length:Int = 0
        open var original_text:String = ""
        open var offset:Int32 = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class IdentifyLanguageResponse:NSObject
{
    open var encoding:String = ""
    open var language:String = ""
    open var language_iso639_2b:String = ""
    open var unicode_scripts:NSMutableArray = []
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "unicode_scripts" {
                    for item in keyValue {
                        if (self.responds(to: NSSelectorFromString(keyName))) {
                            let c = item as! String
                            self.unicode_scripts.add(c)
                        }
                    }
                }
            } else if let v = checkValue(value as AnyObject) {
                if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class TokenizeTextResponse:NSObject
{
    open var terms:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "terms" {
                    for item in keyValue {
                        let p = Terms(json: item as! NSDictionary)
                        self.terms.add(p)
                    }
                }
            }
        }
    }
    open class Terms:NSObject
    {
        open var _case:String = ""
        open var documents:Double = 0
        open var length:Double = 0
        open var numeric:Double = 0
        open var occurrences:Double = 0
        open var start_pos:Double = 0
        open var stop_word :String = ""
        open var term:String = ""
        open var weight:Double = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                if let v = checkValue(value as AnyObject) {
                    var keyName:String = (key as? String)!
                    if keyName == "case" {
                        keyName = "_case"
                    }
                    if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class SentimentAnalysisResponse:NSObject
{
    open var positive:NSMutableArray = []
    open var negative:NSMutableArray = []
    open var aggregate : Aggregate!
    
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "positive" {
                    for item in keyValue {
                        let p = Entity(json: item as! NSDictionary)
                        self.positive.add(p)
                    }
                } else if keyName == "negative" {
                    for item in keyValue {
                        let p = Entity(json: item as! NSDictionary)
                        self.negative.add(p)
                    }
                }
            } else if let _ = value as? NSDictionary {
                if let keyValue:NSDictionary = (value as? NSDictionary) {
                    if keyName == "aggregate" {
                        if (self.responds(to: NSSelectorFromString(keyName))) {
                            self.aggregate = Aggregate(json:keyValue)
                        }
                    }
                }
            }
        }
    }
    open class Aggregate:NSObject {
        open var sentiment : String = ""
        open var score : Double = 0.0
        
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    open class Entity:NSObject
    {
        open var sentiment:String = ""
        open var topic:String = ""
        open var score:Double = 0.0
        open var original_text:String = ""
        open var original_length:Int = 0
        open var normalized_text:String = ""
        open var normalized_length:Int = 0
        
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class SentimentAnalysisV2Response:NSObject
{
    open var sentiment_analysis:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "sentiment_analysis" {
                    for item in keyValue {
                        let p = SentimentObj(json: item as! NSDictionary)
                        self.sentiment_analysis.add(p)
                    }
                }
            }
        }
    }
    open class SentimentObj:NSObject
    {
        open var positive:NSMutableArray = []
        open var negative:NSMutableArray = []
        open var aggregate : Aggregate!
        
        init(json : NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSArray {
                    let keyValue:NSArray = (value as? NSArray)!
                    if keyName == "positive" {
                        for item in keyValue {
                            let p = Entity(json: item as! NSDictionary)
                            self.positive.add(p)
                        }
                    } else if keyName == "negative" {
                        for item in keyValue {
                            let p = Entity(json: item as! NSDictionary)
                            self.negative.add(p)
                        }
                    }
                } else if let _ = value as? NSDictionary {
                    if let keyValue:NSDictionary = (value as? NSDictionary) {
                        if keyName == "aggregate" {
                            if (self.responds(to: NSSelectorFromString(keyName))) {
                                self.aggregate = Aggregate(json:keyValue)
                            }
                        }
                    }
                }
            }
        }
        
        open class Aggregate:NSObject {
            open var sentiment : String = ""
            open var score : Double = 0.0
            
            init(json: NSDictionary) {
                super.init()
                for (key, value) in json {
                    let keyName:String = (key as? String)!
                    if let v = checkValue(value as AnyObject) {
                        if (self.responds(to: NSSelectorFromString(keyName))) {
                            self.setValue(v, forKey: keyName)
                        }
                    }
                }
            }
        }
        open class Entity:NSObject
        {
            open var sentiment:String = ""
            open var topic:String = ""
            open var score:Double = 0.0
            open var original_text:String = ""
            open var original_length:Int = 0
            open var normalized_text:String = ""
            open var normalized_length:Int = 0
            open var offset:Int = 0
            
            init(json: NSDictionary) {
                super.init()
                for (key, value) in json {
                    let keyName:String = (key as? String)!
                    if let v = checkValue(value as AnyObject) {
                        if (self.responds(to: NSSelectorFromString(keyName))) {
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
/************************************************************/
open class AddToTextIndexResponse:NSObject
{
    open var index:String = ""
    open var references:NSMutableArray = []
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "references" {
                    for item in keyValue {
                        if (self.responds(to: NSSelectorFromString(keyName))) {
                            let c = References(json: item as! NSDictionary)
                            self.references.add(c)
                        }
                    }
                }
            } else if let v = checkValue(value as AnyObject) {
                if (self.responds(to: NSSelectorFromString(keyName))) {
                    self.setValue(v, forKey: keyName)
                }
            }
        }
    }
    open class References:NSObject
    {
        open var id:Int64 = 0
        open var reference:String = ""
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class CreateTextIndexResponse:NSObject
{
    open var index:String = ""
    open var message:String = ""
    init(json: NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let v = checkValue(value as AnyObject) {
                if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class DeleteTextIndexResponse:NSObject
{
    open var confirm:String = ""
    open var deleted:Bool!
    open var index:String = ""
    init(json: NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let v = checkValue(value as AnyObject) {
                if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class DeleteFromTextIndexResponse:NSObject
{
    open var documents_deleted :Double = 0
    open var index:String = ""
    init(json: NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let v = checkValue(value as AnyObject) {
                if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class IndexStatusResponse:NSObject
{
    open var _24hr_index_updates:Double = 0
    open var component_count:Double = 0
    open var total_documents:Double = 0
    open var total_index_size:Double = 0
    init(json: NSDictionary) {
        super.init()
        for (key, value) in json {
            if let v = checkValue(value as AnyObject) {
                var keyName:String = (key as? String)!
                if keyName == "24hr_index_updates" {
                    keyName = "_24hr_index_updates"
                }
                if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class ListResourcesResponse:NSObject
{
    open var private_resources:NSMutableArray = []
    open var public_resources:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "private_resources" {
                    for item in keyValue {
                        let p = Private_resources(json: item as! NSDictionary)
                        self.private_resources.add(p)
                    }
                } else if keyName == "public_resources" {
                    for item in keyValue {
                        let p = Public_resources(json: item as! NSDictionary)
                        self.public_resources.add(p)
                    }
                }
            }
        }
    }
    open class Private_resources:NSObject
    {
        open var date_created:String = ""
        open var _description:String = ""
        open var flavor:String = ""
        open var resource:String = ""
        open var type:String = ""
        open var display_name:String = ""
        open var resourceUUID:String = ""
        
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                if let v = checkValue(value as AnyObject) {
                    var keyName:String = (key as? String)!
                    if keyName == "description" {
                        keyName = "_description"
                    }
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    open class Public_resources:NSObject
    {
        open var _description:String = ""
        open var resource:String = ""
        open var type:String = ""
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                var keyName:String = (key as? String)!
                if keyName == "description" {
                    keyName = "_description"
                }
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class RestoreTextIndexResponse:NSObject
{
    open var restored:String = ""
    init(json: NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let v = checkValue(value as AnyObject) {
                if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class AnomalyDetectionResponse:NSObject
{
    open var result:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "result" {
                    for item in keyValue {
                        let p = Result(json: item as! NSDictionary)
                        self.result.add(p)
                    }
                }
            }
        }
    }
    open class Result:NSObject
    {
        open var row:Int64 = 0
        open var row_anomaly_score:Double = 0.0
        open var anomalies:NSMutableArray = []
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSArray {
                    let keyValue:NSArray = (value as? NSArray)!
                    if keyName == "anomalies" {
                        for item in keyValue {
                            let p = Anomaly(json: item as! NSDictionary)
                            self.anomalies.add(p)
                        }
                    }
                } else if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    open class Anomaly:NSObject
    {
        open var type:String = ""
        open var anomaly_score:Double = 0.0
        open var columns:NSMutableArray = []
        
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSArray {
                    let keyValue:NSArray = (value as? NSArray)!
                    if keyName == "columns" {
                        for item in keyValue {
                            let p = Column(json: item as! NSDictionary)
                            self.columns.add(p)
                        }
                    }
                } else if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    open class Column:NSObject {
        open var column : String = ""
        open var value : String = ""
        
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
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
open class TrendAnalysisResponse:NSObject
{
    open var trend_collections:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "trend_collections" {
                    for item in keyValue {
                        let p = TrendCollection(json: item as! NSDictionary)
                        self.trend_collections.add(p)
                    }
                }
            }
        }
    }
    open class TrendCollection:NSObject
    {
        open var trends:NSMutableArray = []
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSArray {
                    let keyValue:NSArray = (value as? NSArray)!
                    if keyName == "trends" {
                        for item in keyValue {
                            let p = Trend(json: item as! NSDictionary)
                            self.trends.add(p)
                        }
                    }
                }
            }
        }
    }
    open class Trend:NSObject
    {
        open var trend:String = ""
        open var measure_percentage_main_group:Double = 0.0
        open var measure_value_main_group:Double = 0.0
        open var main_trend:String = ""
        open var score:Double = 0.0
        open var measure_percentage_compared_group:Double = 0.0
        open var measure:NSMutableArray = []
        open var category:NSMutableArray = []
        
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSArray {
                    let keyValue:NSArray = (value as? NSArray)!
                    if keyName == "category" {
                        for item in keyValue {
                            let p = Category(json: item as! NSDictionary)
                            self.category.add(p)
                        }
                    } else if keyName == "measure" {
                        for item in keyValue {
                            let p = Category(json: item as! NSDictionary)
                            self.measure.add(p)
                        }
                    }
                } else if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
    open class Category:NSObject {
        open var column : String = ""
        open var value : String = ""
        
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let v = checkValue(value as AnyObject) {
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.setValue(v, forKey: keyName)
                    }
                }
            }
        }
    }
}
//////////////////////---------------/////////////////////////

// Utilities public functions
public func checkValue(_ value: AnyObject) -> AnyObject?
{
    var keyValue:AnyObject?
    if let _ = value as? String {
        keyValue = (value as? String)! as AnyObject?
    } else if let _ = value as? Double {
        keyValue = (value as? Double)! as AnyObject?
    } else if let _ = value as? Bool {
        keyValue = (value as? Bool)! as AnyObject?
    }
    return keyValue
}
