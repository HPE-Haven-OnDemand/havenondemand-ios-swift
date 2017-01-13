//
//  HODClient.swift
//
//  Created by MAC_USER on 2/12/15.
//  Copyright (c) 2015 Paco Vu. All rights reserved.
//

import Foundation
import MobileCoreServices

public protocol HODClientDelegate {
    func requestCompletedWithContent(_ response:String)
    func requestCompletedWithJobID(_ response:String)
    func onErrorOccurred(_ errorMessage:String)
}



open class HODClient : NSObject
{
    public var delegate: HODClientDelegate?
    fileprivate var mApiKey : String = ""
    
    fileprivate let mHodBase : String = "https://api.havenondemand.com/1/api/"
    fileprivate let mHodJobResult : String = "https://api.havenondemand.com/1/job/result/"
    fileprivate let mHodJobStatus : String = "https://api.havenondemand.com/1/job/status/"
    fileprivate let mHodCombineAsync : String = "async/executecombination"
    fileprivate let mHodCombineSync : String = "sync/executecombination"
    fileprivate var getJobID = true
    fileprivate var isBusy = false
    fileprivate var mVersion = "v1"
    
    fileprivate var session = URLSession.shared
    
    public init(apiKey:String, version:String = "v1") {
        self.mApiKey = apiKey
        self.mVersion = version
        session.configuration.timeoutIntervalForRequest = 600
    }
    
    public func SetVersion(_ version:String)
    {
        self.mVersion = version
    }
    public func SetAPIKey(_ apiKey:String)
    {
        self.mApiKey = apiKey
    }
    public func GetJobResult(_ jobID:String)
    {
        if !isBusy {
            let queryStr:String = String(format: "%@%@?apikey=%@", arguments: [mHodJobResult,jobID,mApiKey])
            getJobID = false
            let uri = URL(string: queryStr)
            var request = URLRequest(url: uri!)
            request.httpMethod = "GET"
            isBusy = true
            sendRequest(request)
        }
    }
    public func GetJobStatus(_ jobID:String)
    {
        if !isBusy {
            let queryStr:String = String(format: "%@%@?apikey=%@", arguments: [mHodJobStatus,jobID,mApiKey])
            getJobID = false
            let uri = URL(string: queryStr)
            var request = URLRequest(url: uri!)
            request.httpMethod = "GET"
            isBusy = true
            sendRequest(request)
        }
    }
    public func GetRequest(_ params:inout Dictionary<String, AnyObject>, hodApp:String, async: Bool = true)
    {
        if !isBusy {
            var endPoint:String = mHodBase
            getJobID = async
            if async {
                endPoint += String(format: "async/%@/%@?apikey=%@", arguments: [hodApp,mVersion,mApiKey])
            } else {
                endPoint += String(format: "sync/%@/%@?apikey=%@", arguments: [hodApp,mVersion,mApiKey])
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
            
            let encodedUrl = queryStr.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            endPoint = endPoint + encodedUrl!
            let uri = URL(string: endPoint)
            var request = URLRequest(url: uri!)
            request.httpMethod = "GET"
            isBusy = true
            sendRequest(request)
        }
    }
    public func GetRequestCombination(_ params:inout Dictionary<String, AnyObject>, hodApp:String,  async: Bool = true)
    {
        if !isBusy {
            var endPoint:String = mHodBase
            getJobID = async
            if async {
                endPoint += String(format: "%@/%@?apikey=%@", arguments: [mHodCombineAsync,mVersion,mApiKey])
            } else {
                endPoint += String(format: "%@/%@?apikey=%@", arguments: [mHodCombineSync,mVersion,mApiKey])
            }
            
            endPoint += String(format: "&combination=%@", arguments: [hodApp])
            var queryStr:String = ""
            if params.count > 0 {
                for (key, value) in params {
                    if (key == "file") {
                        self.delegate?.onErrorOccurred("Failed. File upload must be used with PostRequest function.")
                        return
                    }
                    if let arr = value as? Array<String> {
                        for item in arr {
                            queryStr += String(format: "&parameters={\"name\":\"%@\",\"value\":\"%@\"}", arguments: [key,item])
                        }
                    } else if let _ = value as? String {
                        queryStr += String(format: "&parameters={\"name\":\"%@\",\"value\":\"%@\"}", arguments: [key,value as! String])
                    }
                }
            }
            let encodedUrl = queryStr.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            endPoint = endPoint + encodedUrl!
            let uri = URL(string: endPoint)
            var request = URLRequest(url: uri!)
            request.httpMethod = "GET"
            isBusy = true
            sendRequest(request)
        }
    }
    public func PostRequest(_ params : inout Dictionary<String, AnyObject>, hodApp:String,  async: Bool = true)
    {
        if !isBusy {
            var queryStr:String = mHodBase
            getJobID = async
            if async {
                queryStr += String(format: "async/%@/%@", arguments: [hodApp,mVersion])
            } else {
                queryStr += String(format: "sync/%@/%@", arguments: [hodApp,mVersion])
            }
            let appUrl = URL(string: queryStr)
            var request = URLRequest(url: appUrl!)
            
            let boundary = generateBoundaryString()
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            let postData = createBodyWithParameters(&params, boundary: boundary)
            if postData != nil {
                request.httpBody = postData
                request.setValue("\(postData!.count)", forHTTPHeaderField: "Content-Length")
                request.httpMethod = "POST"
                isBusy = true
                sendRequest(request)
            }
        }
    }
    public func PostRequestCombination(_ params : inout Dictionary<String, AnyObject>, hodApp:String,  async: Bool = true)
    {
        if !isBusy {
            var queryStr:String = mHodBase
            getJobID = async
            if async {
                queryStr += String(format: "%@/%@?", arguments: [mHodCombineAsync,mVersion])
            } else {
                queryStr += String(format: "%@/%@?", arguments: [mHodCombineSync,mVersion])
            }
            
            let appUrl = URL(string: queryStr)
            var request = URLRequest(url: appUrl!)
            //request.url = appUrl!
            
            let boundary = generateBoundaryString()
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            let postData = createCombiBodyWithParameters(&params, boundary: boundary, hodapp: hodApp)
            if postData != nil {
                request.httpBody = postData
                request.setValue("\(postData!.count)", forHTTPHeaderField: "Content-Length")
                request.httpMethod = "POST"
                isBusy = true
                sendRequest(request)
            }
        }
    }
    /********
     // private functions
     ********/
    fileprivate func createBodyWithParameters(_ parameters: inout Dictionary<String, AnyObject>, boundary: String) -> Data? {
        let body = NSMutableData()
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\"apikey\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(mApiKey)\r\n".data(using: String.Encoding.utf8)!)
        
        if parameters.count > 0 {
            for (key, value) in parameters {
                if let arr = value as? Array<String> {
                    if (key == "file") {
                        for file in arr {
                            let fullFileNameWithPath = file
                            let fileUrl = URL(fileURLWithPath: fullFileNameWithPath)
                            do {
                                let data = try Data(contentsOf: fileUrl,options: NSData.ReadingOptions.mappedIfSafe)
                                var index = fullFileNameWithPath.range(of: "/", options: .backwards)?.upperBound
                                let fileName = fullFileNameWithPath.substring(from: index!)
                                index = fileName.range(of: ".", options: .backwards)?.upperBound
                                let fileExtension = fileName.substring(from: index!)
                                
                                let mimeType = DetermineMIMEType(fileExtension)!
                                
                                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                                body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName)\"\r\n".data(using: String.Encoding.utf8)!)
                                body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: String.Encoding.utf8)!)
                                body.append(data)
                                body.append("\r\n".data(using: String.Encoding.utf8)!)
                                
                            } catch let error as NSError {
                                self.delegate!.onErrorOccurred(error.localizedDescription as String)
                                return nil
                            }
                        }
                    } else {
                        for item in arr {
                            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                            body.append("\(item )\r\n".data(using: String.Encoding.utf8)!)
                        }
                    }
                } else if let _ = value as? String {
                    if (key == "file") {
                        let fullFileNameWithPath = value as! String
                        let fileUrl = URL(fileURLWithPath: fullFileNameWithPath)
                        do {
                            let data = try Data(contentsOf: fileUrl,options: NSData.ReadingOptions.mappedIfSafe)
                            var index = fullFileNameWithPath.range(of: "/", options: .backwards)?.upperBound
                            let fileName = fullFileNameWithPath.substring(from: index!)
                            index = fileName.range(of: ".", options: .backwards)?.upperBound
                            let fileExtension = fileName.substring(from: index!)
                            
                            let mimeType = DetermineMIMEType(fileExtension)!
                            
                            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                            body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName)\"\r\n".data(using: String.Encoding.utf8)!)
                            body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: String.Encoding.utf8)!)
                            body.append(data)
                            body.append("\r\n".data(using: String.Encoding.utf8)!)
                            
                        } catch let error as NSError {
                            self.delegate!.onErrorOccurred(error.localizedDescription as String)
                            return nil
                        }
                    } else {
                        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                        body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                        body.append("\(value as! String)\r\n".data(using: String.Encoding.utf8)!)
                    }
                }
            }
        }
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        return body as Data
    }
    fileprivate func createCombiBodyWithParameters(_ parameters: inout Dictionary<String, AnyObject>, boundary: String, hodapp: String) -> Data? {
        let body = NSMutableData()
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\"apikey\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(mApiKey)\r\n".data(using: String.Encoding.utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\"combination\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(hodapp)\r\n".data(using: String.Encoding.utf8)!)
        
        if parameters.count > 0 {
            for (key, value) in parameters {
                if let arr = value as? Array<AnyObject> {
                    if (key == "file") {
                        // expect a Dictionary<String,String> object
                        for item in arr {
                            let file = item as! Dictionary<String,String>
                            let inputName:String = (file.first?.key)! as String
                            let fullFileNameWithPath = file.first?.value
                            let fileUrl = URL(fileURLWithPath: fullFileNameWithPath!)
                            do {
                                let data = try Data(contentsOf: fileUrl,options: NSData.ReadingOptions.mappedIfSafe)
                                var index = fullFileNameWithPath?.range(of: "/", options: .backwards)?.upperBound
                                let fileName = fullFileNameWithPath?.substring(from: index!)
                                index = fileName?.range(of: ".", options: .backwards)?.upperBound
                                let fileExtension = fileName?.substring(from: index!)
                                
                                let mimeType = DetermineMIMEType(fileExtension!)!
                                
                                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                                body.append("Content-Disposition: form-data; name=\"file_parameters\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                                body.append("\(inputName)\r\n".data(using: String.Encoding.utf8)!)
                                
                                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                                body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: String.Encoding.utf8)!)
                                body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: String.Encoding.utf8)!)
                                body.append(data)
                                body.append("\r\n".data(using: String.Encoding.utf8)!)
                                
                            } catch let error as NSError {
                                self.delegate!.onErrorOccurred(error.localizedDescription as String)
                                return nil
                            }
                        }
                    } else {
                        for item in arr {
                            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                            body.append("Content-Disposition: form-data; name=\"parameters\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                            
                            var jsonval = item as! String
                            if isJson(jsonval) {
                                jsonval = String(format: "{\"name\":\"%@\",\"value\":%@}", arguments: [key, jsonval])
                            }else{
                                jsonval = String(format: "{\"name\":\"%@\",\"value\":\"%@\"}", arguments: [key, jsonval])
                            }
                            body.append("\(jsonval)\r\n".data(using: String.Encoding.utf8)!)
                        }
                    }
                } else if let _ = value as? String {
                    if (key == "file") {
                        self.delegate!.onErrorOccurred("file for combination needs to be packed in a dictionary object")
                        return nil
                    } else {
                        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                        body.append("Content-Disposition: form-data; name=\"parameters\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                        
                        var jsonval = value as! String
                        if isJson(jsonval) {
                            jsonval = String(format: "{\"name\":\"%@\",\"value\":%@}", arguments: [key, jsonval])
                        }else{
                            jsonval = String(format: "{\"name\":\"%@\",\"value\":\"%@\"}", arguments: [key, jsonval])
                        }
                        body.append("\(jsonval)\r\n".data(using: String.Encoding.utf8)!)
                    }
                } else { // a single object
                    if (key == "file") { // single file
                        let file = value as! Dictionary<String,String>
                        let inputName:String = (file.first?.key)! as String
                        let fullFileNameWithPath = file.first?.value
                        let fileUrl = URL(fileURLWithPath: fullFileNameWithPath!)
                        do {
                            var index = fullFileNameWithPath?.range(of: "/", options: .backwards)?.upperBound
                            let fileName:String = (fullFileNameWithPath?.substring(from: index!))!
                            index = fileName.range(of: ".", options: .backwards)?.upperBound
                            let fileExtension = fileName.substring(from: index!)
                            
                            let mimeType = DetermineMIMEType(fileExtension)!
                            print(mimeType)
                            print(fileName)
                            print(inputName)
                            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                            body.append("Content-Disposition: form-data; name=\"file_parameters\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                            body.append("\(inputName)\r\n".data(using: String.Encoding.utf8)!)
                            
                            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: String.Encoding.utf8)!)
                            body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: String.Encoding.utf8)!)
                            let data = try Data(contentsOf: fileUrl,options: NSData.ReadingOptions.mappedIfSafe)
                            body.append(data)
                            body.append("\r\n".data(using: String.Encoding.utf8)!)
                            
                        } catch let error as NSError {
                            self.delegate!.onErrorOccurred(error.localizedDescription as String)
                            return nil
                        }
                    } else {
                        self.delegate!.onErrorOccurred("invalid params")
                        return nil
                    }
                }
            }
        }
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        return body as Data
    }
    // util funcs
    fileprivate func generateBoundaryString() -> String {
        return "Boundary--\(UUID().uuidString)"
    }
    fileprivate func DetermineMIMEType(_ fileExtension: String) -> String? {
        if !fileExtension.isEmpty {
            let UTIRef = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension as CFString, nil)
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
    fileprivate func sendRequest(_ request: URLRequest)
    {
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            self.isBusy = false
            if (error != nil) {
                DispatchQueue.main.async(execute: {
                    let errorStr = error!.localizedDescription
                    self.delegate!.onErrorOccurred(errorStr)
                })
            } else {
                let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                DispatchQueue.main.async(execute: {
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
    
    // utils
    fileprivate func isJson(_ str:String) -> Bool {
        var ret = true
        let data = (str as NSString).data(using: String.Encoding.utf8.rawValue)
        do {
            let _ = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
        }
        catch {
            ret = false
        }
        return ret
    }
}
extension String
{
    func trim() -> String
    {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
}
public struct HODApps {
    public static let RECOGNIZE_SPEECH = "recognizespeech"
    public static let DETECT_SCENE_CHANGES = "detectscenechanges"
    public static let RECOGNIZE_LICENSE_PLATES = "recognizelicenseplates"
    
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
    
    public static let MAP_COORDINATES = "mapcoordinates"
    
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
    public static let GET_TEXT_STATISTICS = "gettextstatistics"
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
