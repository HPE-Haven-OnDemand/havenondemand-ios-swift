//
//  HODResponseParser.swift
//  Parse HOD API Responses
//
//  Created by MAC_USER on 9/25/15.
//  Copyright (c) 2015 PhongVu. All rights reserved.
//

import Foundation

public struct HODErrorCode {
    static let IN_PROGRESS = 1610
    static let QUEUED = 1620
    static let NONSTANDARD_RESPONSE = 1630
    static let INVALID_PARAM = 1640
    static let INVALID_HOD_RESPONSE = 1650
    static let UNKNOWN_ERROR = 1660
}

public class HODResponseParser
{
    var hodErrors : NSMutableArray = []

    public init() {
        
    }
    public func GetLastError() -> NSMutableArray
    {
        return hodErrors
    }
    private func resetErrors()
    {
        hodErrors.removeAllObjects()
    }
    private func addError(error : HODErrorObject)
    {
        hodErrors.addObject(error)
    }

    public func ParseJobID(jsonStr:String) -> String?
    {
        var jobID : String?
        
        if (jsonStr.characters.count != 0) {
            let resStr = jsonStr.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            let data = (resStr as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                guard let _ :NSDictionary = json as? NSDictionary else {
                    return jobID
                }
                jobID = json.valueForKey("jobID") as? String
            }
            catch {
                return jobID
            }
        }
        return jobID
    }
    public func getResult(inout jsonStr:String) -> String?
    {
        resetErrors()
        var result = jsonStr
        if (jsonStr.characters.count == 0) {
            let err = String(format: "%@%d%@", arguments: ["{\"error\":", HODErrorCode.INVALID_HOD_RESPONSE, ",\"reason\":\"Empty response.\"}"])
            let errData = (err as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            let jsonObj = (try! NSJSONSerialization.JSONObjectWithData(errData!, options: [])) as! NSDictionary
            let hodError = HODErrorObject(json: jsonObj)
            addError(hodError)
            return nil
        }
        let resStr = jsonStr.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let data = (resStr as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        do {
            let jsonObj = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            guard let _ :NSDictionary = jsonObj as? NSDictionary else {
                let err = String(format: "%@%d%@", arguments: ["{\"error\":", HODErrorCode.INVALID_HOD_RESPONSE, ",\"reason\":\"Invalid json response.\"}"])
                let errData = (err as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let jsonObj = (try! NSJSONSerialization.JSONObjectWithData(errData!, options: [])) as! NSDictionary
                let hodError = HODErrorObject(json: jsonObj)
                addError(hodError)
                return nil
            }
            
            if let actions = jsonObj["actions"] as? NSArray {
                let status = actions[0].valueForKey("status") as? String
                if status == "finished" || status == "FINISHED" {
                    let jsonData: NSData?
                    do {
                        jsonData = try NSJSONSerialization.dataWithJSONObject((actions[0].valueForKey("result") as? NSDictionary)!, options: [])
                        result = NSString(data: jsonData!, encoding: NSUTF8StringEncoding)! as String
                        
                    } catch let error as NSError {
                        
                        let err = String(format: "%@%d%@%@%@", arguments: ["{\"error\":", HODErrorCode.INVALID_HOD_RESPONSE, ",\"reason\":\"", error.localizedDescription, "\"}"])
                        let errData = (err as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                        let errorObj = (try! NSJSONSerialization.JSONObjectWithData(errData!, options: [])) as! NSDictionary
                        let hodError = HODErrorObject(json: errorObj)
                        addError(hodError)
                        return nil
                    }
                } else if status == "failed" {
                    let errors = actions[0].valueForKey("errors") as! NSArray
                    for item in errors {
                        let hodError = HODErrorObject(json: item as! NSDictionary)
                        addError(hodError)
                    }
                    return nil
                } else if status == "queued" {
                    var jobID = jsonObj.valueForKey("jobID") as? String
                    jobID = jobID!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                    let err = String(format: "%@%d%@%@%@", "{\"error\":", HODErrorCode.QUEUED,",\"reason\":\"Task is in queue\",\"jobID\":\"", jobID!, "\"}")
                    let errData = (err as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                    let errorObj = (try! NSJSONSerialization.JSONObjectWithData(errData!, options: [])) as! NSDictionary
                    let hodError = HODErrorObject(json: errorObj)
                    addError(hodError)
                    return nil
                } else if status == "in progress" {
                    var jobID = jsonObj.valueForKey("jobID") as? String
                    jobID = jobID!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                    let err = String(format: "%@%d%@%@%@", "{\"error\":",HODErrorCode.IN_PROGRESS,",\"reason\":\"Task is in progress\",\"jobID\":\"", jobID!, "\"}")
                    let errData = (err as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                    let errorObj = (try! NSJSONSerialization.JSONObjectWithData(errData!, options: [])) as! NSDictionary
                    let hodError = HODErrorObject(json: errorObj)
                    addError(hodError)
                    return nil
                } else {
                    let err = String(format: "%@%d%@%@", "{\"error\":",HODErrorCode.UNKNOWN_ERROR,",\"reason\":\"", status!, "\"}")
                    let errData = (err as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                    let errorObj = (try! NSJSONSerialization.JSONObjectWithData(errData!, options: [])) as! NSDictionary
                    let hodError = HODErrorObject(json: errorObj)
                    addError(hodError)
                    return nil
                }
            } else {
                // handle error for sync mode
                var isError = false
                for (key, _) in jsonObj as! NSDictionary {
                    if key as! String == "error" {
                        let hodError = HODErrorObject(json: jsonObj as! NSDictionary)
                        addError(hodError)
                        isError = true
                    }
                }
                if isError == true {
                    return nil
                }
            }
        }
        catch {
            let err = String(format: "%@%d%@", arguments: ["{\"error\":", HODErrorCode.INVALID_HOD_RESPONSE, ",\"reason\":\"Invalid json response\"}"])
            let errData = (err as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            let errorObj = (try! NSJSONSerialization.JSONObjectWithData(errData!, options: [])) as! NSDictionary
            let hodError = HODErrorObject(json: errorObj)
            addError(hodError)
            return nil
        }
        return result
    }
    private func logParserError(error:NSError) {
        let err = String(format: "%@%d%@%@", "{\"error\":",HODErrorCode.INVALID_HOD_RESPONSE,",\"reason\":\"", error.localizedDescription, "\"}")
        let errData = (err as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        let errorObj = (try! NSJSONSerialization.JSONObjectWithData(errData!, options: [])) as! NSDictionary
        let hodError = HODErrorObject(json: errorObj)
        addError(hodError)
    }
    public func ParseSpeechRecognitionResponse(inout jsonStr:String) -> SpeechRecognitionResponse?
    {
        var obj : SpeechRecognitionResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = SpeechRecognitionResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseCancelConnectorScheduleResponse(inout jsonStr:String) -> CancelConnectorScheduleResponse?
    {
        var obj : CancelConnectorScheduleResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = CancelConnectorScheduleResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseConnectorHistoryResponse(inout jsonStr:String) -> ConnectorHistoryResponse?
    {
        var obj : ConnectorHistoryResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = ConnectorHistoryResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseConnectorStatusResponse(inout jsonStr:String) -> ConnectorStatusResponse?
    {
        var obj : ConnectorStatusResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = ConnectorStatusResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseCreateConnectorResponse(inout jsonStr:String) -> CreateConnectorResponse?
    {
        var obj : CreateConnectorResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = CreateConnectorResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseDeleteConnectorResponse(inout jsonStr:String) -> DeleteConnectorResponse?
    {
        var obj : DeleteConnectorResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = DeleteConnectorResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseRetrieveConnectorConfigurationAttrResponse(inout jsonStr:String) -> RetrieveConnectorConfigurationAttrResponse?
    {
        var obj : RetrieveConnectorConfigurationAttrResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = RetrieveConnectorConfigurationAttrResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseRetrieveConnectorConfigurationFileResponse(inout jsonStr:String) -> RetrieveConnectorConfigurationFileResponse?
    {
        var obj : RetrieveConnectorConfigurationFileResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = RetrieveConnectorConfigurationFileResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseStartConnectorResponse(inout jsonStr:String) -> StartConnectorResponse?
    {
        var obj : StartConnectorResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = StartConnectorResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseStopConnectorResponse(inout jsonStr:String) -> StopConnectorResponse?
    {
        var obj : StopConnectorResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = StopConnectorResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseUpdateConnectorResponse(inout jsonStr:String) -> UpdateConnectorResponse?
    {
        var obj : UpdateConnectorResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = UpdateConnectorResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseExpandContainerResponse(inout jsonStr:String) -> ExpandContainerResponse?
    {
        var obj : ExpandContainerResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = ExpandContainerResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseStoreObjectResponse(inout jsonStr:String) -> StoreObjectResponse?
    {
        var obj : StoreObjectResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = StoreObjectResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseViewDocumentResponse(inout jsonStr:String) -> ViewDocumentResponse?
    {
        var obj : ViewDocumentResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = ViewDocumentResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseGetCommonNeighborsResponse(inout jsonStr:String) -> GetCommonNeighborsResponse?
    {
        var obj : GetCommonNeighborsResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = GetCommonNeighborsResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseGetNeighborsResponse(inout jsonStr:String) -> GetNeighborsResponse?
    {
        var obj : GetNeighborsResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = GetNeighborsResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseGetNodesResponse(inout jsonStr:String) -> GetNodesResponse?
    {
        var obj : GetNodesResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = GetNodesResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseGetShortestPathResponse(inout jsonStr:String) -> GetShortestPathResponse?
    {
        var obj : GetShortestPathResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = GetShortestPathResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseGetSubgraphResponse(inout jsonStr:String) -> GetSubgraphResponse?
    {
        var obj : GetSubgraphResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = GetSubgraphResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseSuggestLinksResponse(inout jsonStr:String) -> SuggestLinksResponse?
    {
        var obj : SuggestLinksResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = SuggestLinksResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseSummarizeGraphResponse(inout jsonStr:String) -> SummarizeGraphResponse?
    {
        var obj : SummarizeGraphResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = SummarizeGraphResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseOCRDocumentResponse(inout jsonStr:String) -> OCRDocumentResponse?
    {
        var obj : OCRDocumentResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = OCRDocumentResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseRecognizeBarcodesResponse(inout jsonStr:String) -> RecognizeBarcodesResponse?
    {
        var obj : RecognizeBarcodesResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = RecognizeBarcodesResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseDetectFacesResponse(inout jsonStr:String) -> DetectFacesResponse?
    {
        var obj : DetectFacesResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = DetectFacesResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseRecognizeImagesResponse(inout jsonStr:String) -> RecognizeImagesResponse?
    {
        var obj : RecognizeImagesResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = RecognizeImagesResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParsePredictResponse(inout jsonStr:String) -> PredictResponse?
    {
        var obj : PredictResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = PredictResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseRecommendResponse(inout jsonStr:String) -> RecommendResponse?
    {
        var obj : RecommendResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = RecommendResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseTrainPredictorResponse(inout jsonStr:String) -> TrainPredictorResponse?
    {
        var obj : TrainPredictorResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = TrainPredictorResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseCreateQueryProfileResponse(inout jsonStr:String) -> CreateQueryProfileResponse?
    {
        var obj : CreateQueryProfileResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = CreateQueryProfileResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseDeleteQueryProfileResponse(inout jsonStr:String) -> DeleteQueryProfileResponse?
    {
        var obj : DeleteQueryProfileResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = DeleteQueryProfileResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseRetrieveQueryProfileResponse(inout jsonStr:String) -> RetrieveQueryProfileResponse?
    {
        var obj : RetrieveQueryProfileResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = RetrieveQueryProfileResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseUpdateQueryProfileResponse(inout jsonStr:String) -> UpdateQueryProfileResponse?
    {
        var obj : UpdateQueryProfileResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = UpdateQueryProfileResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseFindRelatedConceptsResponse(inout jsonStr:String) -> FindRelatedConceptsResponse?
    {
        var obj : FindRelatedConceptsResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = FindRelatedConceptsResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseAutoCompleteResponse(inout jsonStr:String) -> AutoCompleteResponse?
    {
        var obj : AutoCompleteResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = AutoCompleteResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseExtractConceptsResponse(inout jsonStr:String) -> ExtractConceptsResponse?
    {
        var obj : ExtractConceptsResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = ExtractConceptsResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseExpandTermsResponse(inout jsonStr:String) -> ExpandTermsResponse?
    {
        var obj : ExpandTermsResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = ExpandTermsResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseHighlightTextResponse(inout jsonStr:String) -> HighlightTextResponse?
    {
        var obj : HighlightTextResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = HighlightTextResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseIdentifyLanguageResponse(inout jsonStr:String) -> IdentifyLanguageResponse?
    {
        var obj : IdentifyLanguageResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = IdentifyLanguageResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseSentimentAnalysisResponse(inout jsonStr:String) -> SentimentAnalysisResponse?
    {
        var obj : SentimentAnalysisResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = SentimentAnalysisResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseTokenizeTextResponse(inout jsonStr:String) -> TokenizeTextResponse?
    {
        var obj : TokenizeTextResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = TokenizeTextResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseAddToTextIndexResponse(inout jsonStr:String) -> AddToTextIndexResponse?
    {
        var obj : AddToTextIndexResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = AddToTextIndexResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseCreateTextIndexResponse(inout jsonStr:String) -> CreateTextIndexResponse?
    {
        var obj : CreateTextIndexResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = CreateTextIndexResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseDeleteTextIndexResponse(inout jsonStr:String) -> DeleteTextIndexResponse?
    {
        var obj : DeleteTextIndexResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = DeleteTextIndexResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseDeleteFromTextIndexResponse(inout jsonStr:String) -> DeleteFromTextIndexResponse?
    {
        var obj : DeleteFromTextIndexResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = DeleteFromTextIndexResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseIndexStatusResponse(inout jsonStr:String) -> IndexStatusResponse?
    {
        var obj : IndexStatusResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = IndexStatusResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseListResourcesResponse(inout jsonStr:String) -> ListResourcesResponse?
    {
        var obj : ListResourcesResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = ListResourcesResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseRestoreTextIndexResponse(inout jsonStr:String) -> RestoreTextIndexResponse?
    {
        var obj : RestoreTextIndexResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = RestoreTextIndexResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseAnomalyDetectionResponse(inout jsonStr:String) -> AnomalyDetectionResponse?
    {
        var obj : AnomalyDetectionResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = AnomalyDetectionResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseTrendAnalysisResponse(inout jsonStr:String) -> TrendAnalysisResponse?
    {
        var obj : TrendAnalysisResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                obj = TrendAnalysisResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    public func ParseCustomResponse(inout jsonStr:String) -> NSDictionary?
    {
        resetErrors()
        var obj : NSDictionary!
        if (jsonStr.characters.count == 0) {
            let err = String(format: "%@%d%@", arguments: ["{\"error\":", HODErrorCode.INVALID_HOD_RESPONSE, ",\"reason\":\"Empty response.\"}"])
            let errData = (err as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            let jsonObj = (try! NSJSONSerialization.JSONObjectWithData(errData!, options: [])) as! NSDictionary
            let hodError = HODErrorObject(json: jsonObj)
            addError(hodError)
            return nil
        }
        let resStr = jsonStr.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let data = (resStr as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        do {
            let jsonObj = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            guard let _ :NSDictionary = jsonObj as? NSDictionary else {
                let err = String(format: "%@%d%@", arguments: ["{\"error\":", HODErrorCode.INVALID_HOD_RESPONSE, ",\"reason\":\"Invalid json response.\"}"])
                let errData = (err as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let jsonObj = (try! NSJSONSerialization.JSONObjectWithData(errData!, options: [])) as! NSDictionary
                let hodError = HODErrorObject(json: jsonObj)
                addError(hodError)
                return nil
            }
            
            var result = jsonStr
            
            if let actions = jsonObj["actions"] as? NSArray {
                let status = actions[0].valueForKey("status") as? String
                if status == "finished" || status == "FINISHED" {
                    let jsonData: NSData?
                    do {
                        jsonData = try NSJSONSerialization.dataWithJSONObject((actions[0].valueForKey("result") as? NSDictionary)!, options: [])
                        result = NSString(data: jsonData!, encoding: NSUTF8StringEncoding)! as String
                        
                    } catch let error as NSError {
                        
                        let err = String(format: "%@%d%@%@%@", arguments: ["{\"error\":", HODErrorCode.INVALID_HOD_RESPONSE, ",\"reason\":\"", error.localizedDescription, "\"}"])
                        let errData = (err as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                        let errorObj = (try! NSJSONSerialization.JSONObjectWithData(errData!, options: [])) as! NSDictionary
                        let hodError = HODErrorObject(json: errorObj)
                        addError(hodError)
                        return nil
                    }
                } else if status == "failed" {
                    let errors = actions[0].valueForKey("errors") as! NSArray
                    for item in errors {
                        let hodError = HODErrorObject(json: item as! NSDictionary)
                        addError(hodError)
                    }
                    return nil
                } else if status == "queued" {
                    var jobID = jsonObj.valueForKey("jobID") as? String
                    jobID = jobID!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                    let err = String(format: "%@%d%@%@%@", "{\"error\":", HODErrorCode.QUEUED,",\"reason\":\"Task is in queue\",\"jobID\":\"", jobID!, "\"}")
                    let errData = (err as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                    let errorObj = (try! NSJSONSerialization.JSONObjectWithData(errData!, options: [])) as! NSDictionary
                    let hodError = HODErrorObject(json: errorObj)
                    addError(hodError)
                    return nil
                } else if status == "in progress" {
                    var jobID = jsonObj.valueForKey("jobID") as? String
                    jobID = jobID!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                    let err = String(format: "%@%d%@%@%@", "{\"error\":",HODErrorCode.IN_PROGRESS,",\"reason\":\"Task is in progress\",\"jobID\":\"", jobID!, "\"}")
                    let errData = (err as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                    let errorObj = (try! NSJSONSerialization.JSONObjectWithData(errData!, options: [])) as! NSDictionary
                    let hodError = HODErrorObject(json: errorObj)
                    addError(hodError)
                    return nil
                } else {
                    let err = String(format: "%@%d%@%@", "{\"error\":",HODErrorCode.UNKNOWN_ERROR,",\"reason\":\"", status!, "\"}")
                    let errData = (err as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                    let errorObj = (try! NSJSONSerialization.JSONObjectWithData(errData!, options: [])) as! NSDictionary
                    let hodError = HODErrorObject(json: errorObj)
                    addError(hodError)
                    return nil
                }
            } else {
                // handle error for sync mode
                var isError = false
                for (key, _) in jsonObj as! NSDictionary {
                    if key as! String == "error" {
                        let hodError = HODErrorObject(json: jsonObj as! NSDictionary)
                        addError(hodError)
                        isError = true
                    }
                }
                if isError {
                    return nil
                }
            }
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                obj = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
            } catch let error as NSError {
                let err = String(format: "%@%d%@%@", "{\"error\":",HODErrorCode.INVALID_HOD_RESPONSE,",\"reason\":\"", error.localizedDescription, "\"}")
                let errData = (err as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let errorObj = (try! NSJSONSerialization.JSONObjectWithData(errData!, options: [])) as! NSDictionary
                let hodError = HODErrorObject(json: errorObj)
                addError(hodError)
                return nil
            }
        }
        catch {
            let err = String(format: "%@%d%@", arguments: ["{\"error\":", HODErrorCode.INVALID_HOD_RESPONSE, ",\"reason\":\"Invalid json response\"}"])
            let errData = (err as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            let errorObj = (try! NSJSONSerialization.JSONObjectWithData(errData!, options: [])) as! NSDictionary
            let hodError = HODErrorObject(json: errorObj)
            addError(hodError)
            return nil
        }
        return obj
    }
}