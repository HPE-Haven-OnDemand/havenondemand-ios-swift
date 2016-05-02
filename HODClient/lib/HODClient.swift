//
//  HODClient.swift
//
//  Created by MAC_USER on 2/12/15.
//  Copyright (c) 2015 Paco Vu. All rights reserved.
//

import Foundation
import MobileCoreServices

public protocol HODClientDelegate {
    func requestCompletedWithContent(var response:String)
    func requestCompletedWithJobID(response:String)
    func onErrorOccurred(errorMessage:String)
}



public class HODClient : NSObject
{
    public enum REQ_MODE { case SYNC, ASYNC }
    
    public var delegate: HODClientDelegate?
    private var apikey : String = ""

    private let havenBase : String = "https://api.havenondemand.com/1/api/"
    private let havenJobResult : String = "https://api.havenondemand.com/1/job/result/"
    private let havenJobStatus : String = "https://api.havenondemand.com/1/job/status/"
    private var getJobID = true
    private var isBusy = false
    private var version = "v1"
    
    private var session = NSURLSession.sharedSession()
    
    public init(apiKey:String, version:String = "v1") {
        apikey = apiKey
        self.version = version
        session.configuration.timeoutIntervalForRequest = 600
    }
    public func GetJobResult(jobID:String)
    {
        if !isBusy {
            let queryStr:String = String(format: "%@%@?apikey=%@", arguments: [havenJobResult,jobID,apikey])
            getJobID = false
            let uri = NSURL(string: queryStr)
            let request = NSMutableURLRequest(URL: uri!)
            request.HTTPMethod = "GET"
            isBusy = true
            sendRequest(request)
        } else {
            self.delegate?.onErrorOccurred("Busy. Previous operation is in progress.")
	}
    }
    public func GetJobStatus(jobID:String)
    {
        if !isBusy {
            let queryStr:String = String(format: "%@%@?apikey=%@", arguments: [havenJobStatus,jobID,apikey])
            getJobID = false
            let uri = NSURL(string: queryStr)
            let request = NSMutableURLRequest(URL: uri!)
            request.HTTPMethod = "GET"
            isBusy = true
            sendRequest(request)
        } else {
            self.delegate?.onErrorOccurred("Busy. Previous operation is in progress.")
	}
    }
    public func GetRequest(inout params:Dictionary<String, AnyObject>, hodApp:String, requestMode:REQ_MODE = .ASYNC)
    {
        if !isBusy {
            var endPoint:String = havenBase
            if requestMode == .SYNC {
                endPoint += String(format: "sync/%@/%@?apikey=%@", arguments: [hodApp,version,apikey])
                getJobID = false
            } else {
                endPoint += String(format: "async/%@/%@?apikey=%@", arguments: [hodApp,version,apikey])
                getJobID = true
            }
            var queryStr:String = ""
            if params.count > 0 {
                for (key, value) in params {
                    if (key == "file") {
                        self.delegate?.onErrorOccurred("Failed. File upload must be used with PostRequest function.")
                        return
                    }
                    if let arr = value as? Array<String> {
                        for item in arr {
                            queryStr += String(format: "&%@=%@", arguments: [key,item])
                        }
                    } else if let _ = value as? String {
                        queryStr += String(format: "&%@=%@", arguments: [key,value as! String])
                    }
                }
            }
            
            let encodedUrl = queryStr.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
            endPoint = endPoint.stringByAppendingString(encodedUrl!)
            let uri = NSURL(string: endPoint)
            let request = NSMutableURLRequest(URL: uri!)
            request.HTTPMethod = "GET"
            isBusy = true
            sendRequest(request)
        } else {
            self.delegate?.onErrorOccurred("Busy. Previous operation is in progress.")
	}
    }
    public func PostRequest(inout params : Dictionary<String, AnyObject>, hodApp:String, requestMode:REQ_MODE = .ASYNC)
    {
        if !isBusy {
            var queryStr:String = havenBase
            if requestMode == .SYNC {
                queryStr += String(format: "sync/%@/%@", arguments: [hodApp,version])
                getJobID = false
            } else {
                queryStr += String(format: "async/%@/%@", arguments: [hodApp,version])
                getJobID = true
            }
            let appUrl = NSURL(string: queryStr)
            let request = NSMutableURLRequest()
            request.URL = appUrl!
            
            let boundary = generateBoundaryString()
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
            let postData = createBodyWithParameters(&params, boundary: boundary)
            if postData != nil {
                request.HTTPBody = postData
                request.setValue("\(postData!.length)", forHTTPHeaderField: "Content-Length")
                request.HTTPMethod = "POST"
                isBusy = true
                sendRequest(request)
            }
        } else {
            self.delegate?.onErrorOccurred("Busy. Previous operation is in progress.")
	}
    }
    /********
    // private functions
    ********/
    private func createBodyWithParameters(inout parameters: Dictionary<String, AnyObject>, boundary: String) -> NSData? {
        let body = NSMutableData()
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition: form-data; name=\"apikey\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("\(apikey)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        if parameters.count > 0 {
            for (key, value) in parameters {
                //let type:String = "array" //value.type
                //if type == "array" {
                if let arr = value as? Array<String> {
                    if (key == "file") {
                        for file in arr {
                            let fullFileNameWithPath = file
                            let fileUrl = NSURL(fileURLWithPath: fullFileNameWithPath)
                            do {
                                let data = try NSData(contentsOfURL: fileUrl,options: NSDataReadingOptions.DataReadingMappedIfSafe)
                                var index = fullFileNameWithPath.rangeOfString("/", options: .BackwardsSearch)?.endIndex
                                let fileName = fullFileNameWithPath.substringFromIndex(index!)
                                index = fileName.rangeOfString(".", options: .BackwardsSearch)?.endIndex
                                let fileExtension = fileName.substringFromIndex(index!)
                            
                                let mimeType = DetermineMIMEType(fileExtension)!
                            
                                body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                                body.appendData("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                                body.appendData("Content-Type: \(mimeType)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                                body.appendData(data)
                                body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                            
                            } catch let error as NSError {
                                self.delegate!.onErrorOccurred(error.localizedDescription as String)
                                return nil
                            }
                        }
                    } else {
                        for item in arr {
                            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                            body.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                            body.appendData("\(item )\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                        }
                    }
                } else if let _ = value as? String {
                    if (key == "file") {
                        let fullFileNameWithPath = value as! String
                        let fileUrl = NSURL(fileURLWithPath: fullFileNameWithPath)
                        do {
                            let data = try NSData(contentsOfURL: fileUrl,options: NSDataReadingOptions.DataReadingMappedIfSafe)
                            var index = fullFileNameWithPath.rangeOfString("/", options: .BackwardsSearch)?.endIndex
                            let fileName = fullFileNameWithPath.substringFromIndex(index!)
                            index = fileName.rangeOfString(".", options: .BackwardsSearch)?.endIndex
                            let fileExtension = fileName.substringFromIndex(index!)
                            
                            let mimeType = DetermineMIMEType(fileExtension)!
                            
                            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                            body.appendData("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                            body.appendData("Content-Type: \(mimeType)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                            body.appendData(data)
                            body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                            
                        } catch let error as NSError {
                            self.delegate!.onErrorOccurred(error.localizedDescription as String)
                            return nil
                        }
                    } else {
                        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                        body.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                        body.appendData("\(value as! String)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                    }
                }
            }
        }
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        return body
    }
    // util funcs
    private func generateBoundaryString() -> String {
        return "Boundary--\(NSUUID().UUIDString)"
    }
    private func DetermineMIMEType(fileExtension: String) -> String? {
        if !fileExtension.isEmpty {
            let UTIRef = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, nil)
            let UTI = UTIRef!.takeUnretainedValue()
            UTIRef!.release()
            
            let MIMETypeRef = UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType)
            if MIMETypeRef != nil
            {
                let MIMEType = MIMETypeRef!.takeUnretainedValue()
                MIMETypeRef!.release()
                return MIMEType as String
            }
        }
        return "application/octet-stream"
    }
    private func sendRequest(request: NSMutableURLRequest)
    {
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            self.isBusy = false
            if (error != nil) {
                dispatch_async(dispatch_get_main_queue(), {
                    let errorStr = error!.localizedDescription
                    self.delegate!.onErrorOccurred(errorStr)
                })
            } else {
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                dispatch_async(dispatch_get_main_queue(), {
                    if (self.getJobID) {
                        self.delegate!.requestCompletedWithJobID(strData! as String)
                    } else {
                        self.delegate!.requestCompletedWithContent(strData! as String)
                    }
                })
            }
        })
        task.resume()
    }
}
extension String
{
    func trim() -> String
    {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
}
public struct HODApps {
    public static let RECOGNIZE_SPEECH = "recognizespeech"
    
    public static let CANCEL_CONNECTOR_SCHEDULE = "cancelconnectorschedule"
    public static let CONNECTOR_HISTORY = "connectorhistory"
    public static let CONNECTOR_STATUS = "connectorstatus"
    public static let CREATE_CONNECTOR = "createconnector"
    public static let DELETE_CONNECTOR = "deleteconnector"
    public static let RETRIEVE_CONFIG = "retrieveconfig"
    public static let START_CONNECTOR = "startconnector"
    public static let STOP_CONNECTOR = "stopconnector"
    public static let UPDATE_CONNECTOR = "updateconnector"
    
    public static let EXPAND_CONTAINER = "expandcontainer"
    public static let STORE_OBJECT = "storeobject"
    public static let EXTRACT_TEXT = "extracttext"
    public static let VIEW_DOCUMENT = "viewdocument"
    
    public static let OCR_DOCUMENT = "ocrdocument"
    public static let RECOGNIZE_BARCODES = "recognizebarcodes"
    public static let DETECT_FACES = "detectfaces"
    public static let RECOGNIZE_IMAGES = "recognizeimages"
    
    public static let GET_COMMON_NEIGHBORS = "getcommonneighbors"
    public static let GET_NEIGHBORS = "getneighbors"
    public static let GET_NODES = "getnodes"
    public static let GET_SHORTEST_PATH = "getshortestpath"
    public static let GET_SUB_GRAPH = "getsubgraph"
    public static let SUGGEST_LINKS = "suggestlinks"
    public static let SUMMARIZE_GRAPH = "summarizegraph"
    
    public static let ANOMALY_DETECTION = "anomalydetection"
    public static let TREND_ANALYSIS = "trendanalysis"
    
    public static let CREATE_CLASSIFICATION_OBJECTS = "createclassificationobjects"
    public static let CREATE_POLICY_OBJECTS = "createpolicyobjects"
    public static let DELETE_CLASSIFICATION_OBJECTS = "deleteclassificationobjects"
    public static let DELETE_POLICY_OBJECTS = "deletepolicyobjects"
    public static let RETRIEVE_CLASSIFICATION_OBJECTS = "retrieveclassificationobjects"
    public static let RETRIEVE_POLICY_OBJECTS = "retrievepolicyobjects"
    public static let UPDATE_CLASSIFICATION_OBJECTS = "updateclassificationobjects"
    public static let UPDATE_POLICY_OBJECTS = "updatepolicyobjects"
    
    public static let PREDICT = "predict"
    public static let RECOMMEND = "recommend"
    public static let TRAIN_PREDICTOR = "trainpredictor"
    
    public static let CREATE_QUERY_PROFILE = "createqueryprofile"
    public static let DELETE_QUERY_PROFILE = "deletequeryprofile"
    public static let RETRIEVE_QUERY_PROFILE = "retrievequeryprofile"
    public static let UPDATE_QUERY_PROFILE = "updatequeryprofile"
    
    public static let FIND_RELATED_CONCEPTS = "findrelatedconcepts"
    public static let FIND_SIMILAR = "findsimilar"
    public static let GET_CONTENT = "getcontent"
    public static let GET_PARAMETRIC_VALUES = "getparametricvalues"
    public static let QUERY_TEXT_INDEX = "querytextindex"
    public static let RETRIEVE_INDEX_FIELDS = "retrieveindexfields"
    
    public static let AUTO_COMPLETE = "autocomplete"
    public static let CLASSIFY_DOCUMENT = "classifydocument"
    public static let EXTRACT_CONCEPTS = "extractconcepts"
    public static let CATEGORIZE_DOCUMENT = "categorizedocument"
    public static let ENTITY_EXTRACTION = "extractentities"
    public static let EXPAND_TERMS = "expandterms"
    public static let HIGHLIGHT_TEXT = "highlighttext"
    public static let IDENTIFY_LANGUAGE = "identifylanguage"
    public static let ANALYZE_SENTIMENT = "analyzesentiment"
    public static let TOKENIZE_TEXT = "tokenizetext"
    
    public static let ADD_TO_TEXT_INDEX = "addtotextindex"
    public static let CREATE_TEXT_INDEX = "createtextindex"
    public static let DELETE_TEXT_INDEX = "deletetextindex"
    public static let DELETE_FROM_TEXT_INDEX = "deletefromtextindex"
    public static let INDEX_STATUS = "indexstatus"
    //public static let LIST_INDEXES = "listindexes" REMOVED
    public static let LIST_RESOURCES = "listresources"
    public static let RESTORE_TEXT_INDEX = "restoretextindex"
}
