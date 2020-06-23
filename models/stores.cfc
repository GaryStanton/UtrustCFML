/**
 * Name: UTrust Stores API
 * Author: Gary Stanton (gary@simianenterprises.co.uk)
 * Description: Wrapper for the UTrust Stores API.
 */
component singleton accessors="true" {

    property name="apiURL" type="string";
    property name="apiKey" type="string";

    property name="sandbox_url"     type="string" default="https://merchants.api.sandbox-utrust.com/api/";
    property name="production_url"  type="string" default="https://merchants.api.utrust.com/api/";


    /**
     * Constructor
     * 
     * @apiKey Your API access key - get one at https://merchants.sandbox-utrust.com/onboarding/get-started
     */
    public stores function init(
            required    string ApiKey
        ,               string Environment = "sandbox"
    ){  
        setApiKey(Arguments.apiKey);
        setApiURL(Arguments.Environment == 'production' ? getProduction_url() : getSandbox_url());
        return this;
    }


    /**
     * Creates a Order.
     *
     * @orderData The Order struct.
     * @customerData The customer struct
     *
     * @return string|object Response data.
     * @throws Exception
     */
    public function createOrder(
            required struct orderData
        ,   required struct customerData   
    ){

        // Build body
        var body = {
            'data' : {
                'type' : 'orders',
                'attributes' : {
                    'order' : Arguments.orderData,
                    'customer' : Arguments.customerData
                }
            }
        }

        return makeRequest(
                endpoint    = 'stores/orders'
            ,   body        = body
        );
    }


    /**
     * Makes request to the API. Will return the content from the cfhttp request.
     * @endpoint The request endpoint
     * @body The body of the request
     */
    private function makeRequest(
            required string endpoint
        ,   required struct body
    ){

        var requestURL  = getApiURL() & Arguments.endpoint;
        var result      = {};

        cfhttp(
            method  = "POST", 
            charset = "utf-8", 
            url     = requestURL,
            result  = "result"
        ) {
            cfhttpparam(type="header", name="Authorization", value="Bearer #getApiKey()#");
            cfhttpparam(type="header", name="Content-Type", value="application/json");
            cfhttpparam(type="body", value="#SerializeJSON(Arguments.body)#");
        }

        if (StructKeyExists(result, 'fileContent') && isJSON(result.fileContent)) {
            return deserializeJSON(result.fileContent);
        }
        else {
            return {errors: 'Unable to parse JSON result'}
        }
    }
}