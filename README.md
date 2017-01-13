# iOS-Swift client library for Haven OnDemand
Official client library to help with calling Haven OnDemand APIs [http://havenondemand.com](http://havenondemand.com).

The library contains 2 packages:

* HODClient package for sending HTTP GET/POST requests to Haven OnDemand APIs.
* HODResponseParser package for parsing JSON responses from Haven OnDemand APIs.

The library requires Swift 3.0.

## What is Haven OnDemand?
Haven OnDemand is a set of over 60 APIs for handling all sorts of unstructured data. Here are just some of our APIs' capabilities:
* Speech to text
* OCR
* Text extraction
* Indexing documents
* Smart search
* Language identification
* Concept extraction
* Sentiment analysis
* Web crawlers
* Machine learning

For a full list of all the APIs and to try them out, check out https://www.havenondemand.com/developer/apis

## Integrate HODClient into iOS Swift project from  Cocoapods

1. Follow instructions from [this](https://guides.cocoapods.org/using/using-cocoapods.html) page to install and initialize CocoaPods
2. Run `open -a PodFile` and add the following: 

    ```
    platform :ios, '9.3'
    use_frameworks!

    target 'YourApp' do
    pod 'havenondemand', '1.0.6'
    end
```

3. Save the PodFile
4. Run `pod install`
4. Open `YourApp.xcworkspace` and build.
5. Add `import havenondemand` to your swift file


## Integrate HODClient directly into iOS Swift project
1. Download the HODClient library for iOS.
2. Create a new or open an existing iOS Swift project
3. Add the HODClient.swift file to the project.
>![](/images/importlibrary1.jpg)
4. Browse to the folder where you saved the library and select the HODClient.swift file.
5. If you want to use the HODResponseParser library, follow the step 4 to add also the HODResponseParser.swift and HODResponseObjects files.


----
## HODClient API References
###Constructor
Creates and initializes an HODClient object.

```
HODClient(apiKey:String, version:String = "v1")
```

*Parameters:*

* `apiKey` your developer apikey.
* `version` Haven OnDemand API version. Currently it only supports version 1. Thus, the default value is "v1".

*Example code:*
```
var hodClient:HODClient = HODClient(apiKey: "your-api-key")
```

###Function GetRequest
Sends a HTTP GET request to call a Haven OnDemand API.

```
GetRequest(inout params:Dictionary<String, AnyObject>, hodApp:String, async:Bool)
```

*Parameters:*

* `params` a Dictionary object containing key/value pair parameters to be sent to a Haven OnDemand API, where the keys are the parameters of that API.
* `hodApp` a string to identify a Haven OnDemand API. E.g. "extractentities". Current supported apps are listed in the HODApps object.
* `async` specifies API call as asynchronous or synchronous. The default value is true for asynchronous call.

*Response:*

* If the async is true, response will be returned via the requestCompletedWithJobID(response:String) callback function.
* If the async is false, response will be returned via the requestCompletedWithContent(response:String) callback function.
* If there is an error occurred, the error message will be sent via the onErrorOccurred(errorMessage:String) callback function.

*Example code:*

```
// Call the Entity Extraction API to find people and places from CNN website
   
var hodApp = hodClient.hodApps.ENTITY_EXTRACTION;
var entities = ["people_eng","places_eng"]
var params = Dictionary<String, AnyObject>()
params["url"] = "http://www.cnn.com"
params["entity_type"] = entities
hodClient.GetRequest(&params, hodApp:hodApp, async:false)
```

###Function PostRequest
Sends a HTTP POST request to call a Haven OnDemand API.

```
PostRequest(inout params:Dictionary<String, Object>, hodApp:String, async:Bool)
```

*Parameters:*

* `params` a Dictionary object containing key/value pair parameters to be sent to a Haven OnDemand API, where the keys are the parameters of that API.
* `hodApp` a string to identify a Haven OnDemand API. E.g. "ocrdocument". Current supported apps are listed in the HODApps object.
* `async` specifies API call as asynchronous or synchronous. The default value is true for asynchronous call.

*Response:*

* If the async is true, response will be returned via the requestCompletedWithJobID(response:String) callback function.
* If the async is false, response will be returned via the requestCompletedWithContent(response:String) callback function.
* If there is an error occurred, the error message will be sent via the onErrorOccurred(errorMessage:String) callback function.

*Example code:*

```
// Call the OCR Document API to scan text from an image file

var hodApp = hodClient.hodApps.OCR_DOCUMENT
var params =  Dictionary<String,Object>()
params["file"] = "full/path/filename.jpg"
params["mode"] = "document_photo"
hodClient.PostRequest(&params, hodApp:hodApp, async:true)
```

###Function GetRequestCombination

Sends a HTTP GET request to call a combination API.
```
GetRequestCombination(inout params:Dictionary<String,AnyObject>, hodApp:String), async:Bool = true)
```

*Parameters:*

* `params` a Dictionary object containing key/value pair parameters to be sent to a Haven OnDemand combination API, where the keys are the parameters of that API.
* `hodApp` a string to identify a Haven OnDemand combination API.
* `async` specifies API call as asynchronous or synchronous. The default value is true for asynchronous call.

*Example code:*

```
// Call a combination API named "ocrtoconcept", which recognizes text from an image and extract the concept of the text.
params["url"] =  "http://www.some.domain/review.jpg" as AnyObject
hodClient.GetRequestCombination(&params, hodApp:"ocrtoconcept", async: false);
```

###Function PostRequestCombination
Sends a HTTP POST request to call a combination API.

```
PostRequestCombination(inout params:Dictionary<String,AnyObject>, hodApp:String, async:Bool = true)
```

*Parameters:*

* `params` a Dictionary object containing key/value pair parameters to be sent to a Haven OnDemand combination API, where the keys are the parameters of that API.
* `hodApp` a string to identify a Haven OnDemand combination API.
* `async` specifies API call as asynchronous or synchronous. The default value is true for asynchronous call.

*Response:*

* If the async is true, response will be returned via the requestCompletedWithJobID(response:String) callback function.
* If the async is false, response will be returned via the requestCompletedWithContent(response:String) callback function.
* If there is an error occurred, the error message will be sent via the onErrorOccurred(errorMessage:String) callback function.

**Example code:**

```
// Call a combination API named "imagetosentiment", which recognizes text from an image and analyze the sentiment of the text.

var file = Dictionary<String,String>()
file["imageFile"] = "fullpath/image.jpg"
let files:NSMutableArray = []
files.add(file)
var params = Dictionary<String,AnyObject>()
params["file"] = files as AnyObject
hodClient.PostRequestCombination(&params, hodApp: "imagetosentiment")
```

###Function GetJobResult
Sends a request to Haven OnDemand to retrieve content identified by the jobID.

```
GetJobResult(jobID:String)
```

*Parameter:*

* `jobID` the job ID returned from a Haven OnDemand API upon an asynchronous call.

*Response:*

* Response will be returned via the requestCompletedWithContent(response:String)

###Function GetJobStatus
Sends a request to Haven OnDemand to retrieve status of a job identified by a job ID. If the job is completed, the response will be the result of that job. Otherwise, the response will contain the current status of the job.

```
GetJobStatus(jobID:String)
```

*Parameter:*

* `jobID` the job ID returned from a Haven OnDemand API upon an asynchronous call.

*Response:*

* Response will be returned via the requestCompletedWithContent(response:String)

###Callback functions
In your class, you will need to inherit the HODClientDelegate protocol and implement delegated functions to receive responses from the server

```
class MyAppClass : HODClientDelegate {

    hodClient.delegate = self

    func requestCompletedWithJobID(response:String){ }

    func requestCompletedWithContent(var response:String){ }

    func onErrorOccurred(errorMessage:String){ }
}
```
#
When you call the GetRequest() or PostRequest() with the ASYNC mode, the response will be returned to this callback function. The response is a JSON string containing the jobID.

```
func requestCompletedWithJobID(response:String)
{

}
```
When you call the GetRequest() or PostRequest() with the SYNC mode or call the GetJobResult() function, the response will be returned to this callback function. The response is a JSON string containing the actual result of the service.

```
func requestCompletedWithContent(var response:String)
{

}
```
If there is an error occurred, the error message will be returned to this callback function.

```
func onErrorOccurred(errorMessage:String)
{

}
```

## HODResponseParser API References
###Constructor
Creates and initializes an HODResponseParser object.

```
HODResponseParser()
```

*Example code:*

```
var hodParser:HODResponseParser = HODResponseParser()
```
###Function ParseJobID
Parses a jobID from a json string returned from an asynchronous API call.

```
ParseJobID(jsonStr:String) -> String?
```
*Parameters:*

* `jsonStr` a json string returned from an asynchronous API call.

*Returned value:*

* The jobID or nil if not found.

*Example code:*

```
func requestCompletedWithJobID(response:String) {
    let jobID : String? = hodParser.ParseJobID(response)
    if jobID != nil {
        hodClient.GetJobStatus(jobID!)
    }
}
```

###Function ParseSpeechRecognitionResponse
Parses a json response from Haven OnDemand Speech Recognition API and returns a SpeechRegconitionResponse object.

```
ParseSpeechRecognitionResponse(&jsonStr) -> SpeechRecognitionResponse?
```

>Note: See the full list of standard parser functions from the Standard response parser functions section at the end of this document.

*Parameters:*

* `jsonStr` a json string returned from a synchronous API call or from the GetJobResult() or GetJobStatus() function.

*Returned value:*

* An object containing API's response values. If there is an error or if the job is not completed (callback from a GetJobStatus call), the returned object is nil and the error or job status can be accessed by calling the GetLastError() function.

*Example code:*

```
func requestCompletedWithContent(var response:String) {
    if let resp = (hodParser.ParseSentimentAnalysisResponse(&response)) {
        var result = "Positive:\n"
        for item in resp.positive {
            let i  = item as! SentimentAnalysisResponse.Entity
            result += "Sentiment: " + i.sentiment + "\n"
            result += "Score: " + String(format:"%.6f",i.score) + "\n"
            result += "Topic: " + i.topic + "\n"
            result += "Statement: " + i.original_text + "\n"
            result += "Length: " + String(format:"%d",i.original_length) + "\n"
            result += "------\n"
        }
        result += "Negative:\n"
        for item in resp.negative {
            let i  = item as! SentimentAnalysisResponse.Entity
            result += "Sentiment: " + i.sentiment + "\n"
            result += "Score: " + String(format:"%.6f",i.score) + "\n"
            result += "Topic: " + i.topic + "\n"
            result += "Statement: " + i.original_text + "\n"
            result += "Length: " + String(format:"%d",i.original_length) + "\n"
            result += "------\n"
        }
        result += "Aggregate:\n"
        result += "Sentiment: " + resp.aggregate.sentiment + "\n"
        result += "Score: " + String(format:"%.6f",resp.aggregate.score)
        // print or consume result
    } else {
        let errors = hodParser.GetLastError()
        var errorStr = ""
        for error in errors {
            let err = error as! HODErrorObject
            errorMsg =  String(format: "Error code: %d\n", err.error)
            errorMsg += String(format: "Error reason: %@\n", err.reason)
            errorMsg += String(format: "Error detail: %@\n", err.detail)
            errorMsg += String(format: "JobID: %@\n", err.jobID)
            print(errorMsg)
            if err.error == HODErrorCode.QUEUED { // queues
                // sleep for a few seconds then check the job status again
                hodClient.GetJobStatus(err.jobID)
                break
            } else if err.error == HODErrorCode.IN_PROGRESS { // in progress
                // sleep for for a while then check the job status again
                hodClient.GetJobStatus(err.jobID)
                break
            }
        }
    }
}
```

###Function ParseCustomResponse
Parses a json string and returns the result as an NSDictionary object. You will need to define a custom class and parse the result into that class. See example below for more details.

```
ParseCustomResponse(_ jsonStr:inout String) -> NSDictionary?
```

*Parameters:*

* `jsonStr` a json string returned from a synchronous API call or from the GetJobResult() or GetJobStatus() function.

*Returned value:*

* A NSDictionary object containing API's result values. If there is an error or if the job is not completed (callback from a GetJobStatus call), the returned object is nil and the error or job status can be accessed by calling the GetLastError() function.

*Example code:*
##
    // Define a custom class to hold entity extraction API's response
    public class EntityExtractionResponse:NSObject {
        var entities:NSMutableArray = [];
        init(json : NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSArray {
                    let keyValue:NSArray = (value as? NSArray)!
                    if keyName == "entities" {
                        for item in keyValue {
                            let p = Entity(json: item as! NSDictionary)
                            self.entities.addObject(p)
                        }
                    }
                }
            }
        }
        public class AdditionalInformation:NSObject {
            var person_profession:NSMutableArray = []
            var person_date_of_birth:String = ""
            var wikidata_id:Int = 0
            var wikipedia_eng:String = ""
            var image:String = ""
            var person_date_of_death:String = ""
            var lon:Double = 0.0
            var lat:Double = 0.0
            var place_population:Int = 0
            var place_country_code:String = ""
            var place_region1:String = ""
            var place_region2:String = ""
            var place_elevation:Double = 0.0
            init(json:NSDictionary) {
                super.init()
                for (key, value) in json {
                    let keyName:String = (key as? String)!
                    if let _ = value as? NSArray {
                        let keyValue:NSArray = (value as? NSArray)!
                        for item in keyValue {
                            if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                                let c = item as! String
                                self.person_profession.addObject(c)
                            }
                        }
                    } else {
                        if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                            self.setValue(value, forKey: keyName)
                        }
                    }
                }
            }
        }
        public class Components:NSObject {
            var original_length: Int64 = 0
            var original_text: String = ""
            var type: String = ""
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
        public class Entity:NSObject {
            var normalized_text:String = ""
            var original_text:String = ""
            var type:String = ""
            var normalized_length:Int = 0
            var original_length:Int = 0
            var score:Double = 0.0
            var additional_information:AdditionalInformation?
            var components:NSMutableArray = []
            init(json: NSDictionary) {
                super.init()
                for (key, value) in json {
                    let keyName:String = (key as? String)!
                    if let _ = value as? NSDictionary {
                        let keyValue:NSDictionary = (value as? NSDictionary)!
                        if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                            self.additional_information = AdditionalInformation(json:keyValue)
                        }
                    } else if let _ = value as? NSArray {
                        let keyValue:NSArray = (value as? NSArray)!
                        for item in keyValue {
                            if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                                let c = Components(json:item as! NSDictionary)
                                self.components.addObject(c)
                            }
                        }
                    } else {
                        if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                            self.setValue(value, forKey: keyName)
                        }
                    }
                }
            }
        }
    }
    // parse json string to a custom data object
    func requestCompletedWithContent(var response:String) {
        if let dic = hodParser.ParseCustomResponse(&jsonData) {
            let obj = EntityExtractionResponse(json:dic)
            var result: String = ""
            for ent in obj.entities as NSArray as! [EntityExtractionResponse.Entity] {
                result += ent.normalized_text + "\n"
                result += ent.type + "\n"
                // access any other fields
            }
            // print or consume result
        } else {
            let errors = hodParser.GetLastError()
            var errorMsg = ""
            for error in errors {
                let err = error as! HODErrorObject
                errorMsg =  String(format: "Error code: %d\n", err.error)
                errorMsg += String(format: "Error reason: %@\n", err.reason)
                errorMsg += String(format: "Error detail: %@\n", err.detail)
                errorMsg += String(format: "JobID: %@\n", err.jobID)
                print(errorMsg)
                if err.error == HODErrorCode.QUEUED { // queues
                    // sleep for a few seconds then check the job status again
                    hodClient.GetJobStatus(err.jobID)
                    break
                } else if err.error == HODErrorCode.IN_PROGRESS { // in progress
                    // sleep for for a while then check the job status again
                    hodClient.GetJobStatus(err.jobID)
                    break
                }
            }
        }
    }


###Function GetLastError
Get the latest error(s) if any happened during parsing the json string or HOD error returned from HOD server.

```
GetLastError() -> NSMutableArray
```

> Note: The job "queued" or "in progress" status is also considered as an error situation. See the example below for how to detect and handle error status.

*Returned value:*

* A NSMutableArray contains HODErrorObject.

*Example code:*

```
let errors = hodParser.GetLastError()
var errorMsg = ""
for error in errors {
    let err = error as! HODErrorObject
    errorMsg =  String(format: "Error code: %d\n", err.error)
    errorMsg += String(format: "Error reason: %@\n", err.reason)
    errorMsg += String(format: "Error detail: %@\n", err.detail)
    errorMsg += String(format: "JobID: %@\n", err.jobID)
    print(errorMsg)
    if err.error == HODErrorCode.QUEUED { // queues
        // sleep for a few seconds then check the job status again
        hodClient.GetJobStatus(err.jobID)
        break
    } else if err.error == HODErrorCode.IN_PROGRESS { // in progress
        // sleep for for a while then check the job status again
        hodClient.GetJobStatus(err.jobID)
        break
    }
}
```

## Demo code 1:

**Use the Entity Extraction API to extract people and places from cnn.com website with a synchronous GET request**

```
class MyAppClass : HODClientDelegate {
    var hodClient:HODClient = HODClient(apiKey: "your-api-key")
    hodClient.delegate = self
    var hodParser:HODResponseParser = HODResponseParser()
    var hodApp = ""

    func useHODClient() {
        var hodApp = hodClient.hodApps.ENTITY_EXTRACTION
        var params =  Dictionary<String,Object>()

        params["url"] = "http://www.cnn.com"
        params["entity_type"] = ["people_eng","places_eng"]
        params["unique_entities"] = "true"

        hodClient.GetRequest(&params, hodApp:hodApp, async:false);
    }

    // implement delegated functions
    func requestCompletedWithContent(_ response:String){
        if let obj = (hodParser.ParseEntityExtractionResponse(&response)) {
            var people = ""
            var places = ""
            for ent in obj.entities as NSArray as! [EntityExtractionResponse.Entity] {
                if ent.type == "people_eng" {
                    people += ent.normalized_text + "\n"
                    // parse any other interested information about this person ...
                }
                else if type == "places_eng" {
                    places += ent.normalized_text + "\n"
                    // parse any other interested information about this place ...
                }
            }            
        }else{
            checkErrorInResponse()
        }
    }
    func checkErrorInResponse() {
        let errors = hodParser.GetLastError()
        var errorStr = ""
        for error in errors {
            let err = error as! HODErrorObject
            errorStr = "Error code: " + String(format: "%d", err.error) + "\n"
            errorStr += "Error reason: " + err.reason + "\n"
            errorStr += "Error detail: " + err.detail + "\n"
            errorStr += "Error jobID: " + err.jobID + "\n"
        }
        println(errorStr)
    }

    func onErrorOccurred(errorMessage:String){
        // handle error if any
    }
}
```

## Demo code 2:

**Use the OCR Document API to scan text from an image with an asynchronous POST request**

```
class MyAppClass : HODClientDelegate {
    var hodClient:HODClient = HODClient(apiKey: "your-api-key")
    var hodParser:HODResponseParser = HODResponseParser()
    hodClient.delegate = self

    func useHODClient() {
        var hodApp = hodClient.hodApps.OCR_DOCUMENT
        var params =  Dictionary<String,AnyObject>()
        params["file"] = "full/path/filename.jpg"
        params["mode"] = "document_photo"

        hodClient.PostRequest(&params, hodApp:hodApp)
        }

    // implement delegated functions
    /**************************************************************************************
    * An async request will result in a response with a jobID. We parse the response to get
    * the jobID and send a request for the actual content identified by the jobID.
    **************************************************************************************/
    func requestCompletedWithJobID(response:String){
        let jobID:String? = hodParser.ParseJobID(response)
        if jobID != nil {
            hodClient.GetJobStatus(jobID!)
        }
    }
    func requestCompletedWithContent(var response:String){
        if let resp = (hodParser.ParseOCRDocumentResponse(&response)) {
            var result = "Scanned text:\n"
            for item in resp.text_block {
                let i  = item as! OCRDocumentResponse.TextBlock
                result += "Text: " + i.text + "\n"
                result += "Top/Left: " + String(format: "%d/%d", i.top, i.left) + "\n"
                result += "------\n"
            }
            // print or consume result
        }else{
            let errors = hodParser.GetLastError()
            var errorMsg = ""
            for error in errors {
                let err = error as! HODErrorObject
                errorMsg =  String(format: "Error code: %d\n", err.error)
                errorMsg += String(format: "Error reason: %@\n", err.reason)
                errorMsg += String(format: "Error detail: %@\n", err.detail)
                errorMsg += String(format: "JobID: %@\n", err.jobID)
                print(errorMsg)
                if err.error == HODErrorCode.QUEUED { // queues
                    // sleep for a few seconds then check the job status again
                    hodClient.GetJobStatus(err.jobID)
                    break
                }else if err.error == HODErrorCode.IN_PROGRESS { // in progress
                    // sleep for for a while then check the job status again
                    hodClient.GetJobStatus(err.jobID)
                    break
                }
            }
        }
    }
    func onErrorOccurred(errorMessage:String){
        // handle error if any
    }
}
```

## Standard response parser functions
```
ParseSpeechRecognitionResponse(_ jsonStr:inout String) -> SpeechRecognitionResponse?
ParseDetectSceneChangesResponse(_ jsonStr:inout String) -> DetectSceneChangesResponse?
ParseLicensePlateRecognitionResponse(_ jsonStr:inout String) -> LicensePlateRecognitionResponse?
ParseCancelConnectorScheduleResponse(_ jsonStr:inout String) -> CancelConnectorScheduleResponse?
ParseConnectorHistoryResponse(_ jsonStr:inout String) -> ConnectorHistoryResponse?
ParseConnectorStatusResponse(_ jsonStr:inout String) -> ConnectorStatusResponse?
ParseCreateConnectorResponse(_ jsonStr:inout String) -> CreateConnectorResponse?
ParseDeleteConnectorResponse(_ jsonStr:inout String) -> DeleteConnectorResponse?
ParseRetrieveConnectorConfigurationFileResponse(_ jsonStr:inout String) -> RetrieveConnectorConfigurationFileResponse?
ParseRetrieveConnectorConfigurationAttrResponse(_ jsonStr:inout String) -> RetrieveConnectorConfigurationAttrResponse?
ParseStartConnectorResponse(_ jsonStr:inout String) -> StartConnectorResponse?
ParseStopConnectorResponse(_ jsonStr:inout String) -> StopConnectorResponse?
ParseUpdateConnectorResponse(_ jsonStr:inout String) -> ConnectorResponse?
ParseExpandContainerResponse(_ jsonStr:inout String) -> ExpandContainerResponse?
ParseStoreObjectResponse(_ jsonStr:inout String) -> StoreObjectResponse?
ParseViewDocumentResponse(_ jsonStr:inout String) -> ViewDocumentResponse?
ParseGetCommonNeighborsResponse(_ jsonStr:inout String) -> GetCommonNeighborsResponse?
ParseGetNeighborsResponse(_ jsonStr:inout String) -> GetNeighborsResponse?
ParseGetNodesResponse(_ jsonStr:inout String) -> GetNodesResponse?
ParseGetShortestPathResponse(_ jsonStr:inout String) -> GetShortestPathResponse?
ParseGetSubgraphResponse(_ jsonStr:inout String) -> GetSubgraphResponse?
ParseSuggestLinksResponse(_ jsonStr:inout String) -> SuggestLinksResponse?
ParseSummarizeGraphResponse(_ jsonStr:inout String) -> SummarizeGraphResponse?
ParseOCRDocumentResponse(_ jsonStr:inout String) -> OCRDocumentResponse?
ParseRecognizeBarcodesResponse(_ jsonStr:inout String) -> RecognizeBarcodesResponse?
ParseRecognizeImagesResponse(_ jsonStr:inout String) -> RecognizeImagesResponse?
ParseDetectFacesResponse(_ jsonStr:inout String) -> DetectFacesResponse?
ParsePredictResponse(_ jsonStr:inout String) -> PredictResponse?
ParsePredictV2Response(_ jsonStr:inout String) -> PredictV2Response?
ParseRecommendResponse(_ jsonStr:inout String) -> RecommendResponse?
ParseRecommendV2Response(_ jsonStr:inout String) -> RecommendV2Response?
ParseTrainPredictionResponse(_ jsonStr:inout String) -> TrainPredictionResponse?
ParseTrainPredictionV2Response(_ jsonStr:inout String) -> TrainPredictionV2Response?
ParseCreateQueryProfileResponse(_ jsonStr:inout String) -> CreateQueryProfileResponse?
ParseDeleteQueryProfileResponse(_ jsonStr:inout String) -> DeleteQueryProfileResponse?
ParseRetrieveQueryProfileResponse(_ jsonStr:inout String) -> RetrieveQueryProfileResponse?
ParseUpdateQueryProfileResponse(_ jsonStr:inout String) -> UpdateQueryProfileResponse?
ParseFindRelatedConceptsResponse(_ jsonStr:inout String) -> FindRelatedConceptsResponse?
ParseAutoCompleteResponse(_ jsonStr:inout String) -> AutoCompleteResponse?
ParseExtractConceptsResponse(_ jsonStr:inout String) -> ExtractConceptsResponse?
ParseEntityExtractionResponse(_ jsonStr:inout String) -> EntityExtractionResponse?
ParseEntityExtractionV2Response(_ jsonStr:inout String) -> EntityExtractionV2Response?
ParseExpandTermsResponse(_ jsonStr:inout String) -> ExpandTermsResponse?
ParseHighlightTextResponse(_ jsonStr:inout String) -> HighlightTextResponse?
ParseIdentifyLanguageResponse(_ jsonStr:inout String) -> IdentifyLanguageResponse?
ParseTokenizeTextResponse(_ jsonStr:inout String) -> TokenizeTextResponse?
ParseSentimentAnalysisResponse(_ jsonStr:inout String) -> SentimentAnalysisResponse?
ParseSentimentAnalysisV2Response(_ jsonStr:inout String) -> SentimentAnalysisV2Response?
ParseAddToTextIndexResponse(_ jsonStr:inout String) -> AddToTextIndexResponse?
ParseCreateTextIndexResponse(_ jsonStr:inout String) -> CreateTextIndexResponse?
ParseDeleteTextIndexResponse(_ jsonStr:inout String) -> DeleteTextIndexResponse?
ParseDeleteFromTextIndexResponse(_ jsonStr:inout String) -> DeleteFromTextIndexResponse?
ParseIndexStatusResponse(_ jsonStr:inout String) -> IndexStatusResponse?
ParseListResourcesResponse(_ jsonStr:inout String) -> ListResourcesResponse?
ParseRestoreTextIndexResponse(_ jsonStr:inout String) -> RestoreTextIndexResponse?
ParseAnomalyDetectionResponse(_ jsonStr:inout String) -> AnomalyDetectionResponse?
ParseTrendAnalysisResponse(_ jsonStr:inout String) -> TrendAnalysisResponse?
```

## License
Licensed under the MIT License.
