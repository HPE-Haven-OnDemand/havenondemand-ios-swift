//
//  HODClient.swift
//
//  Created by MAC_USER on 2/12/15.
//  Copyright (c) 2015 Paco Vu. All rights reserved.
//

import Foundation
import MobileCoreServices

protocol HODClientDelegate {
    func requestCompletedWithContent(_ response:String)
    func requestCompletedWithJobID(_ response:String)
    func onErrorOccurred(_ errorMessage:String)
}



class HODClient : NSObject
{
    //enum REQ_MODE { case sync, async }
    
    var delegate: HODClientDelegate?
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
    
    init(apiKey:String, version:String = "v1") {
        self.mApiKey = apiKey
        self.mVersion = version
        session.configuration.timeoutIntervalForRequest = 600
    }
    internal func SetVersion(_ version:String)
    {
        self.mVersion = version
    }
    internal func SetAPIKey(_ apiKey:String)
    {
        self.mApiKey = apiKey
    }
    internal func GetJobResult(_ jobID:String)
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
    internal func GetJobStatus(_ jobID:String)
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
    internal func GetRequest(_ params:inout Dictionary<String, AnyObject>, hodApp:String, async: Bool = true)
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
    internal func GetRequestCombination(_ params:inout Dictionary<String, AnyObject>, hodApp:String,  async: Bool = true)
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
    internal func PostRequest(_ params : inout Dictionary<String, AnyObject>, hodApp:String,  async: Bool = true)
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
            //request.url = appUrl!
            
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
    internal func PostRequestCombination(_ params : inout Dictionary<String, AnyObject>, hodApp:String,  async: Bool = true)
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
                //let type:String = "array" //value.type
                //if type == "array" {
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
struct HODApps {
    static let RECOGNIZE_SPEECH = "recognizespeech"
    static let DETECT_SCENE_CHANGES = "detectscenechanges"
    static let RECOGNIZE_LICENSE_PLATES = "recognizelicenseplates"
    
    static let CANCEL_CONNECTOR_SCHEDULE = "cancelconnectorschedule"
    static let CONNECTOR_HISTORY = "connectorhistory"
    static let CONNECTOR_STATUS = "connectorstatus"
    static let CREATE_CONNECTOR = "createconnector"
    static let DELETE_CONNECTOR = "deleteconnector"
    static let RETRIEVE_CONFIG = "retrieveconfig"
    static let START_CONNECTOR = "startconnector"
    static let STOP_CONNECTOR = "stopconnector"
    static let UPDATE_CONNECTOR = "updateconnector"
    
    static let EXPAND_CONTAINER = "expandcontainer"
    static let STORE_OBJECT = "storeobject"
    static let EXTRACT_TEXT = "extracttext"
    static let VIEW_DOCUMENT = "viewdocument"
    
    static let MAP_COORDINATES = "mapcoordinates"
    
    static let OCR_DOCUMENT = "ocrdocument"
    static let RECOGNIZE_BARCODES = "recognizebarcodes"
    static let DETECT_FACES = "detectfaces"
    static let RECOGNIZE_IMAGES = "recognizeimages"
    
    static let GET_COMMON_NEIGHBORS = "getcommonneighbors"
    static let GET_NEIGHBORS = "getneighbors"
    static let GET_NODES = "getnodes"
    static let GET_SHORTEST_PATH = "getshortestpath"
    static let GET_SUB_GRAPH = "getsubgraph"
    static let SUGGEST_LINKS = "suggestlinks"
    static let SUMMARIZE_GRAPH = "summarizegraph"
    
    static let ANOMALY_DETECTION = "anomalydetection"
    static let TREND_ANALYSIS = "trendanalysis"
    
    static let CREATE_CLASSIFICATION_OBJECTS = "createclassificationobjects"
    static let CREATE_POLICY_OBJECTS = "createpolicyobjects"
    static let DELETE_CLASSIFICATION_OBJECTS = "deleteclassificationobjects"
    static let DELETE_POLICY_OBJECTS = "deletepolicyobjects"
    static let RETRIEVE_CLASSIFICATION_OBJECTS = "retrieveclassificationobjects"
    static let RETRIEVE_POLICY_OBJECTS = "retrievepolicyobjects"
    static let UPDATE_CLASSIFICATION_OBJECTS = "updateclassificationobjects"
    static let UPDATE_POLICY_OBJECTS = "updatepolicyobjects"
    
    static let PREDICT = "predict"
    static let RECOMMEND = "recommend"
    static let TRAIN_PREDICTOR = "trainpredictor"
    
    static let CREATE_QUERY_PROFILE = "createqueryprofile"
    static let DELETE_QUERY_PROFILE = "deletequeryprofile"
    static let RETRIEVE_QUERY_PROFILE = "retrievequeryprofile"
    static let UPDATE_QUERY_PROFILE = "updatequeryprofile"
    
    static let FIND_RELATED_CONCEPTS = "findrelatedconcepts"
    static let FIND_SIMILAR = "findsimilar"
    static let GET_CONTENT = "getcontent"
    static let GET_PARAMETRIC_VALUES = "getparametricvalues"
    static let QUERY_TEXT_INDEX = "querytextindex"
    static let RETRIEVE_INDEX_FIELDS = "retrieveindexfields"
    
    static let AUTO_COMPLETE = "autocomplete"
    static let CLASSIFY_DOCUMENT = "classifydocument"
    static let EXTRACT_CONCEPTS = "extractconcepts"
    static let CATEGORIZE_DOCUMENT = "categorizedocument"
    static let ENTITY_EXTRACTION = "extractentities"
    static let EXPAND_TERMS = "expandterms"
    static let HIGHLIGHT_TEXT = "highlighttext"
    static let IDENTIFY_LANGUAGE = "identifylanguage"
    static let ANALYZE_SENTIMENT = "analyzesentiment"
    static let GET_TEXT_STATISTICS = "gettextstatistics"
    static let TOKENIZE_TEXT = "tokenizetext"
    
    static let ADD_TO_TEXT_INDEX = "addtotextindex"
    static let CREATE_TEXT_INDEX = "createtextindex"
    static let DELETE_TEXT_INDEX = "deletetextindex"
    static let DELETE_FROM_TEXT_INDEX = "deletefromtextindex"
    static let INDEX_STATUS = "indexstatus"
    //static let LIST_INDEXES = "listindexes" REMOVED
    static let LIST_RESOURCES = "listresources"
    static let RESTORE_TEXT_INDEX = "restoretextindex"
}
